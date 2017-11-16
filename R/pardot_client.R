#' Make a call to the Pardot API and return XML or data frame
#'
#' @param object A string containing a Pardot Object
#' @param operator A string containing a Pardot Operator
#' @param identifier_field A string with an optional identifier field. Can be null
#' @param identifier A string with an optional identifier that can be null if identifier_field is null
#' @param request_pars A string of query parameters. Can be null
#' @param result_format A string specifying the result format used for API calls: "json" or "xml". If json, pardot_client() returns a data frame.
#' @return XML or a data frame in tbl_df (dplyr) format
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' pardot_client("campaign", "query")
#' pardot_client(object = "campaign", operator = "query", 
#'   request_params = "created_after=yesterday&id_greater_than=1234XYZ")}
#' @export pardot_client
#' @import httr
#' @import xml2
#' @import XML
#' @import jsonlite
#' @import dplyr

pardot_client <- function(object, operator, identifier_field=NULL, identifier=NULL, request_pars=NULL, result_format="json") {
  # object & operator are required fields
  # identifier fields / identifier are optional
  # optional field to implement <- api_request_params,"&format=",api_format
  param_list <- (as.list(match.call()))

  if (!exists('api_key')) {
    pardot_client.authenticate()
  } else if (exists('api_key') && api_key == "Login failed" ) {
    pardot_client.authenticate()
  } else {
	message("Perform API request")
    request_url <- pardot_client.build_url(param_list)
	if (result_format == "json") {
		pardot_client.api_call_json(request_url)
	} else {
		pardot_client.api_call(request_url)
	}
  }
}

pardot_client.authenticate <- function() {
  # body params must be set in list. Add .env get that will fetch these items
  auth_body  <- list(email = .paRdotEnv$data$pardot_username,
                     password = .paRdotEnv$data$pardot_password,
                     user_key = .paRdotEnv$data$pardot_user_key)

  # make initial API call to authenticate
  fetch_api_call <- POST("https://pi.pardot.com/api/login/version/3", body= auth_body)

  # returns xml node with <api_key>
  api_key <<- xml_text(content(fetch_api_call))
}

pardot_client.api_call_json <- function(request_url) {
	
	# Perform request
	resp <- GET(request_url)
	if (resp$status != 200) {
		pardot_client.authenticate()
		resp <- GET(request_url, content_type_json())
		jsonresp <- fromJSON(request_url)
	}

	# Retrieve results in chunks
	polished_df <- data.frame()
	ready <- FALSE
	n_offset <- 0
	while (!ready) {
		cat(".")
		if (n_offset == 0) {
			raw_df <- pardot_client.get_data_frame(request_url)
		} else {
			raw_df <- pardot_client.get_data_frame(pardot_client.iterative_request_url(request_url, n_offset = n_offset))
		}
		# Substitute embedded campaign dataframe column by the "name" column it contains
		colCampaign <- grep("\\.campaign$", colnames(raw_df), ignore.case = FALSE, value = TRUE)
		colCampaignName <- paste0(colCampaign, "_name")
		raw_df[, colCampaignName] <- raw_df[, colCampaign]$name
		raw_df[, colCampaign] <- NULL
		# Append
		n <- nrow(raw_df)
		if (n > 0) {
			n_offset <- n_offset + n
			polished_df <- bind_rows(polished_df, raw_df)
		} else {
			ready <- TRUE
		}
	}
	return(polished_df)
}

pardot_client.api_call <- function(request_url) {
  resp <- GET(request_url)

  if ( resp$status != 200 ) {
    pardot_client.authenticate()
    resp <- GET(request_url, content_type_xml())
  }

  xml_response <- xmlNode(content(resp, "parsed"))
  return(xml_response)
}


pardot_client.get_data_frame <- function(theUrl) {
  jsonResponse <- fromJSON(theUrl)
  d <- as.data.frame(jsonResponse[2])
  return(d)
}

pardot_client.build_url <- function(param_list) {
  # required fields
  api_object = param_list$object
  api_operator = param_list$operator

  # optional fields
  api_identifier_field = pardot_client.scrub_opts(param_list$identifier_field)
  api_identifier = pardot_client.scrub_opts(param_list$identifier)
  api_request_params = param_list$request_pars
  api_request_params <- if (!is.null(api_request_params)) paste0("&", sub("^&+", "", api_request_params)) else NULL  

  request_url <- paste0("https://pi.pardot.com/api/",api_object,"/version/3/do/",api_operator,api_identifier_field,api_identifier,"?api_key=",api_key,"&user_key=",Sys.getenv("PARDOT_USER_KEY"),api_request_params,"&output=bulk&format=json")
  print(request_url)
  return(request_url)
}

pardot_client.iterative_request_url <- function(request_url, theDate = NULL, n_offset = NULL) {
	# Keep original parameter theDate for backward compatibility
	# Check n_offset first as offset is the preferred method for navigating.
	# Consequence is that n_offset must be named when the function is called.
	if (!missing(n_offset)) {
		iterative_request_url <- paste0(request_url, "&offset=", n_offset)
	} else if (!missing(theDate)) {
		theDate <- gsub(' ', 'T', theDate)
		iterative_request_url <- paste0(requestUrl,"&created_after=",theDate,"&sort_by=created_at&sort_order=ascending")
	} else {
		iterative_request_url <- request_url
	}
	print(iterative_request_url)
	return(iterative_request_url)
}

pardot_client.scrub_opts <- function(opt) {
  if( is.null(opt) || opt == '' ) {
    return('')
  } else {
    new_opt <- paste0('/',opt)
    return(new_opt)
  }
}
