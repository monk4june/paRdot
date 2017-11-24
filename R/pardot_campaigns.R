#' Retrieve Pardot Campaigns
#'
#' Make a call to the Pardot API and return the campaigns matching the specified criteria parameters. 
#'
#' @param ... Comma separated list of parameter name and parameter value pairs. Parameter names are not quoted. 
#'   Allowed parameter names are created_after, created_before, id_greater_than, id_less_than, name, 
#'   updated_before, updated_after.
#' @return A data frame.
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' df <- pardot_campaigns()
#' df <- pardot_campaigns(created_after = 'today')}
#' @export pardot_campaigns

pardot_campaigns <- function(...) {
    # Evaluate parameters in the context of the parent environment,
    # combine parameters to a querystring e.g. param1=value1&param2=value2&...
    newcall <- quote(pardot_client(object = "campaign", operator = "query"))
    thiscall <- match.call()
    request_params <- paste(paste(names(thiscall[-1]), thiscall[-1], sep = "="), collapse = "&")
    newcall[["request_pars"]] <- request_params
    eval(newcall, parent.frame())
}
