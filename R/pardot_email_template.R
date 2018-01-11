#' Retrieve Pardot Email Template
#'
#' Make a call to the Pardot API and return the data for the specified email template.
#'
#' @param email_template_id The Pardot ID of the target email template.
#' @param verbose Verbose output. See pardot_client(). 
#' @return A data frame.
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' df <- pardot_email_template(email_template_id = 21918)}
#' @export pardot_email_template
#'

pardot_email_template <- function(email_template_id, verbose = 0) {
	# Evaluate parameters in the context of the parent environment,
	# combine parameters to a querystring e.g. param1=value1&param2=value2&...
	newcall <- quote(pardot_client(object = "emailTemplate", operator = "read", identifier_field = "id", identifier = email_template_id))
	#thiscall <- match.call()
	#request_params <- paste(paste(names(thiscall[-(1:2)]), thiscall[-(1:2)], sep = "="), collapse = "&")
	newcall[["identifier"]] <- email_template_id
	#newcall[["request_pars"]] <- request_params
	newcall[["verbose"]] <- verbose
	eval(newcall, parent.frame())
}
