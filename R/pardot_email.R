#' Retrieve Pardot Email
#'
#' Make a call to the Pardot API and return the data for the specified email.
#'
#' @param list_email_id The Pardot ID of the target email.
#' @param verbose Verbose output. See pardot_client(). 
#' @param ... Comma separated list of parameter name and parameter value pairs. Parameter names are not quoted. 
#'   Allowed parameter names are include_message.
#' @return A data frame.
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' df <- pardot_emaildata(email_id = 747447245)}
#' @export pardot_email
#'

pardot_email <- function(list_email_id, verbose = 0, ...) {
	# Evaluate parameters in the context of the parent environment,
	# combine parameters to a querystring e.g. param1=value1&param2=value2&...
	newcall <- quote(pardot_client(object = "email", operator = "read", identifier_field = "id"))
	thiscall <- match.call()
	print(thiscall)
	request_params <- paste(paste(names(thiscall[-(1:2)]), thiscall[-(1:2)], sep = "="), collapse = "&")
	newcall[["identifier"]] <- list_email_id
	newcall[["request_pars"]] <- request_params
	newcall[["verbose"]] <- verbose
	eval(newcall, parent.frame())
}
