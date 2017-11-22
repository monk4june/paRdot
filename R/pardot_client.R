#' Make a call to the Pardot API and return XML or data frame
#'
#' @param object A string containing a Pardot Object
#' @param operator A string containing a Pardot Operator
#' @param identifier_field A string with an optional identifier field. Can be null
#' @param identifier A string with an optional identifier that can be null if identifier_field is null
#' @param request_pars A string of query parameters. Can be null
#' @param result_format A string specifying the result format used for API calls: "json" or "xml". If json, pardot_client() returns a data frame.
#' @param verbose A logical, default FALSE. If TRUE it shows the successive call urls and the data structure returned by the first call
#' @return XML or a data frame in tbl_df format
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

pardot_client <- function(object, operator, identifier_field=NULL, identifier=NULL, request_pars=NULL, result_format="json", verbose = FALSE) {
  # object & operator are required fields
  # identifier fields / identifier are optional
  # optional field to implement <- api_request_params,"&format=",api_format
  param_list <- (as.list(match.call()))

  if (!exists('api_key')) {
    pardot_client.authenticate()
  } else if (exists('api_key') && api_key == "Login failed" ) {
    pardot_client.authenticate()
  } else {
    request_url <- pardot_client.build_url(param_list)
	if (result_format == "json") {
		pardot_client.api_call_json(request_url, verbose = verbose)
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

pardot_client.api_call_json <- function(request_url, verbose = FALSE) {
	
	# Retrieve results in chunks
	polished_df <- data.frame()
	ready <- FALSE
	n_offset <- 0
	while (!ready) {
		cat(".")
		if (n_offset == 0) {
		    if (verbose) print(request_url)
			raw_df <- pardot_client.get_data_frame(request_url)
			if (verbose) print(str(raw_df))
		} else {
		    iterative_request_url <- 
		        pardot_client.iterative_request_url(request_url, n_offset = n_offset)
            if (verbose) print(iterative_request_url)
			raw_df <- pardot_client.get_data_frame(iterative_request_url)
		}
	    # Unnest nested data frames
	    flat_df <- flatten(raw_df, recursive = TRUE)
		# Append
		n <- nrow(flat_df)
		if (n > 0) {
			n_offset <- n_offset + n
			polished_df <- bind_rows(polished_df, flat_df)
			if (n < 200) ready <- TRUE
		} else {
			ready <- TRUE
		}
	}
	# Substitute dots by underscores
	colnames(polished_df) <- gsub(".", "_", colnames(polished_df), fixed = TRUE) 
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
    message("pardot_client.get_data_frame")
    # GET the url response in json format and convert to list
    # Replace NULL values by NA so that list can be cast to data frame
    respjson <- GET(theUrl, content_type_json())
    if (respjson$status != 200) {
        warning(sprintf("GET returned %s", as.character(respjson$status)))
        return(data.frame())
    }
    res <- fromJSON(content(respjson, as = "text", encoding = "UTF-8"))
    if (res$`@attributes`$stat == "fail") {
        warning(res$err)
        return(data.frame())
    } else if ((names(res))[2] == "account") {
        res_data  <- pardot_client.nonnull_list(res[[2]])
        d <- as.data.frame(res_data, stringsAsFactors = FALSE)
    } else if ((names(res))[2] == "result") {
        res_data  <- pardot_client.nonnull_list(res[[2]][[1]])
        d <- as.data.frame(res_data, stringsAsFactors = FALSE)
    } else {
        warning("Unknown paRdot API response format")
        return(data.frame())
    }
    return(d)
}

pardot_client.nonnull_list <- function(list_with_nulls) {
    list_without_nulls <- lapply(list_with_nulls, function(x) {
        if (class(x) == "list")
            x
        else if (is.null(x))
            NA
        else
            x
    })
    return(list_without_nulls)
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
		iterative_request_url <- paste0(request_url,"&created_after=",theDate,"&sort_by=created_at&sort_order=ascending")
	} else {
		iterative_request_url <- request_url
	}
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

pardot_client.unnest_dataframe <- function(df, verbose = FALSE) {
    # Unnest any nested data frames in the data frame
    df_colclasses <- sapply(df, class)
    df_colclasses_dataframe <- names(df_colclasses[df_colclasses == "data.frame"])
    if (length(df_colclasses_dataframe) == 0) {
        # Nothing to unnest
        return(df)
    }
    # Start with flat data frame, then subsequently bind the unnested data frames
    df0 <- df[, setdiff(colnames(df), df_colclasses_dataframe)]
    for (d in df_colclasses_dataframe) {
        if (verbose) message("Unnesting nested data frame ", d)
        # Use recursion to unnest any fields of class data frame in this data frame
        df_embedded <- Recall(df[, d])
        nested_colnames <- colnames(df_embedded)
        unnested_colnames <- paste(d, nested_colnames, sep = ".")
        colnames(df_embedded) <- unnested_colnames
        df0 <- bind_cols(df0, df_embedded)
    }
    return(df0)
}
