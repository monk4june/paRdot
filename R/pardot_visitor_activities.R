#' Retrieve Pardot Visitor Activities
#'
#' Make a call to the Pardot API and return the visitor activities matching the specified criteria parameters. 
#'
#' @param ... Comma separated list of parameter name and parameter value pairs. Parameter names are not quoted. 
#'   Allowed parameter names are created_after, created_before, id_greater_than, id_less_than, prospect_only, type,
#'   custom_url_only, email_only, file_only, form_only, form_handler_only, landing_page_only, campaign_id, 
#'   custom_url_id, email_id, file_id, form_id, form_handler_id, landing_page_id, prospect_id, visitor_id.
#' @param verbose Verbose output. See pardot_client(). 
#' @return A data frame.
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' df <- pardot_visitor_activity()
#' df <- pardot_visitor_activity(created_after = 'yesterday', prospect_only = 'true') }
#' @export pardot_visitor_activities

pardot_visitor_activities <- function(..., verbose = 0) {
    # Evaluate parameters in the context of the parent environment,
    # combine parameters to a querystring e.g. param1=value1&param2=value2&...
    newcall <- quote(pardot_client(object = "visitorActivity", operator = "query"))
    thiscall <- match.call()
    thiscall <- thiscall[names(thiscall) != "verbose"]
    request_params <- paste(paste(names(thiscall[-1]), thiscall[-1], sep = "="), collapse = "&")
    newcall[["request_pars"]] <- request_params
    newcall[["verbose"]] <- verbose
    eval(newcall, parent.frame())
}
