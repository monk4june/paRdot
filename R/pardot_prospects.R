#' Make a call to the Pardot API and return a dataframe listing all prospects
#'
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' pardot_prospects()}
#' @export
#' pardot_prospects
#' @import httr
#' @import xml2
#' @import XML
#' @import jsonlite

pardot_prospects <- function() {

  if (!exists('api_key')) {
    pardot_client.authenticate()
  } else if (exists('api_key') && api_key == "Login failed" ) {
    pardot_client.authenticate()
  } else {
    pardot_prospects.api_call()
  }
}

pardot_prospects.api_call <- function() {
  request_url <- paste0("https://pi.pardot.com/api/prospect/version/3/do/query?api_key=",api_key,"&user_key=",Sys.getenv("PARDOT_USER_KEY"),"&output=bulk&format=json&sort_by=created_at&sort_order=ascending")
  resp <- GET(request_url)

  if ( resp$status != 200 ) {
    pardot_client.authenticate()
    resp <- GET(request_url, content_type_json())
    jsonresp <- fromJSON(request_url)
  }

  raw_df <- pardot_client.get_data_frame(request_url)
  raw_df$result.prospect.campaign_name <- raw_df$result.prospect.campaign$name
  raw_df <- subset(raw_df, select=-result.prospect.campaign)
  lowest_date <- tail(raw_df, 1)$result.prospect.created_at
  polished_df <- rbind(raw_df)

  while (!nrow(raw_df) < 200) {
    print(paste0("Pulling data from", lowest_date))
    loop_url <- pardot_prospects.iterative_request_url(request_url, lowest_date)
    raw_df <- pardot_client.get_data_frame(loop_url)
    lowest_date <- tail(raw_df, 1)$result.prospect.created_at
    raw_df$result.prospect.campaign_name <- raw_df$result.prospect.campaign$name
    raw_df <- subset(raw_df, select=-result.prospect.campaign)
    polished_df <- rbind(polished_df, raw_df)
  }

  return(polished_df)
}

pardot_prospects.iterative_request_url <- function(requestUrl, theDate) {
  theDate <- gsub(' ', 'T', theDate)
  iterative_request_url <- paste0(requestUrl,"&created_after=",theDate,"&sort_by=created_at&sort_order=ascending")
}



