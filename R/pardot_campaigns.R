#' Make a call to the Pardot API and return a dataframe listing all campaigns
#'
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' pardot_campaigns()}
#' @export
#' pardot_campaigns
#' @import httr
#' @import xml2
#' @import XML
#' @import jsonlite

pardot_campaigns <- function() {

  if (!exists('api_key')) {
    pardot_client.authenticate()
  } else if (exists('api_key') && api_key == "Login failed" ) {
    pardot_client.authenticate()
  } else {
    pardot_campaigns.api_call()
  }
}

pardot_campaigns.api_call <- function() {
  request_url <- paste0("https://pi.pardot.com/api/campaign/version/3/do/query?api_key=",api_key,"&user_key=",Sys.getenv("PARDOT_USER_KEY"),"&output=bulk&format=json&sort_by=id&sort_order=ascending")
  resp <- GET(request_url)

  if ( resp$status != 200 ) {
    pardot_client.authenticate()
    resp <- GET(request_url, content_type_json())
    jsonresp <- fromJSON(request_url)
  }

  raw_df <- pardot_client.get_data_frame(request_url)
  lowest_id <- tail(raw_df, 1)$result.campaign.id
  polished_df <- rbind(raw_df)

  while (!nrow(raw_df) < 200) {
    print(paste0("Pulling data from low ID", lowest_id))
    loop_url <- pardot_campaigns.iterative_request_url(request_url, lowest_id)
    raw_df <- pardot_client.get_data_frame(loop_url)
    lowest_id <- tail(raw_df, 1)$result.campaign.id

    polished_df <- rbind(polished_df, raw_df)
  }

  return(polished_df)
}

pardot_campaigns.iterative_request_url <- function(requestUrl, theId) {
  iterative_request_url <- paste0(requestUrl,"&id_greater_than=",theId,"&sort_by=id&sort_order=ascending")
}