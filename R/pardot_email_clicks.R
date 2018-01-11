#' Retrieve Pardot Email Clicks
#'
#' Make a call to the Pardot API and return the email clicks matching the specified criteria parameters. 
#'
#' @param ... Comma separated list of parameter name and parameter value pairs. Parameter names are not quoted. 
#'   Allowed parameter names are created_after, created_before, id_greater_than, list_email_id, drip_program_action_id, email_template_id, tracker_redirect_id.
#' @param verbose Verbose output. See pardot_client(). 
#' @return A data frame. See http://developer.pardot.com/kb/object-field-references/#email-clicks.
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' df <- pardot_email_clicks()
#' df <- pardot_email_clicks(created_after = 'yesterday') }
#' @export pardot_email_clicks

pardot_email_clicks <- function(..., verbose = 0) {
    # Evaluate parameters in the context of the parent environment,
    # combine parameters to a querystring e.g. param1=value1&param2=value2&...
    newcall <- quote(pardot_client(object = "emailClick", operator = "query"))
    thiscall <- match.call()
    thiscall <- thiscall[names(thiscall) != "verbose"]
    request_params <- paste(paste(names(thiscall[-1]), thiscall[-1], sep = "="), collapse = "&")
    newcall[["request_pars"]] <- request_params
    newcall[["verbose"]] <- verbose
    eval(newcall, parent.frame())
}
