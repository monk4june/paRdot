#' Retrieve Pardot users
#'
#' Make a call to the Pardot API and return the users matching the specified criteria parameters. 
#'
#' @param ... Comma separated list of parameter name and parameter value pairs. Parameter names are not quoted. 
#'   Allowed parameter names are created_after, created_before, id_greater_than, id_less_than.
#' @return A tbl_df (dplyr) dataframe.
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' df <- pardot_users()
#' df <- pardot_users(created_after = 'yesterday') }
#' @export pardot_users

pardot_users <- function(...) {
    # Evaluate parameters in the context of the parent environment,
    # combine parameters to a querystring e.g. param1=value1&param2=value2&...
    newcall <- quote(pardot_client(object = "user", operator = "query"))
    thiscall <- match.call()
    request_params <- paste(paste(names(thiscall[-1]), thiscall[-1], sep = "="), collapse = "&")
    newcall[["request_pars"]] <- request_params
    eval(newcall, parent.frame())
}