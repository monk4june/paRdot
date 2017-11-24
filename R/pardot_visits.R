#' Retrieve Pardot Visits
#'
#' Make a call to the Pardot API and returns the visits matching the specified criteria parameters. 
#'
#' @param ... Comma separated list of parameter name and parameter value pairs. Parameter names are not quoted. 
#'   Allowed parameter names are ids, visitor_ids, prospect_ids.
#' @return A data frame. Note: The field visitor_page_view in the returned data frame contains nested lists. Use pardot_client() parameter unlist_dataframe = TRUE to expand the list field into data frame rows, or unlist_dataframe = FALSE to retain the lists as they are.
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' df <- pardot_visits()
#' df <- pardot_visits(created_after = 'yesterday', prospect_id = 123) }
#' @export pardot_visits

pardot_visits <- function(...) {
    # Evaluate parameters in the context of the parent environment,
    # combine parameters to a querystring e.g. param1=value1&param2=value2&...
    newcall <- quote(pardot_client(object = "visit", operator = "query"))
    thiscall <- match.call()
    request_params <- paste(paste(names(thiscall[-1]), thiscall[-1], sep = "="), collapse = "&")
    newcall[["request_pars"]] <- request_params
    eval(newcall, parent.frame())
}
