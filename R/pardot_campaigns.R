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