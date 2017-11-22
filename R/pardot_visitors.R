#' Retrieve Pardot Visitors
#'
#' Make a call to the Pardot API and returns the visitors matching the specified criteria parameters. 
#'
#' @param ... Comma separated list of parameter name and parameter value pairs. Parameter names are not quoted. 
#'   Allowed parameter names are created_after, created_before, id_greater_than, name, update_before, 
#'   updated_after, only_identified, prospect_ids.
#' @return A tbl_df data frame.
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' df <- pardot_visitors()
#' df <- pardot_visitors(created_after = 'yesterday', only_identified = 'true') }
#' @export pardot_visitors

pardot_visitors <- function(...) {
    # Evaluate parameters in the context of the parent environment,
    # combine parameters to a querystring e.g. param1=value1&param2=value2&...
    newcall <- quote(pardot_client(object = "visitor", operator = "query"))
    thiscall <- match.call()
    request_params <- paste(paste(names(thiscall[-1]), thiscall[-1], sep = "="), collapse = "&")
    newcall[["request_pars"]] <- request_params
    eval(newcall, parent.frame())
}
