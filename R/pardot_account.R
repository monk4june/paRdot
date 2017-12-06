#' Retrieve Pardot Account
#'
#' Make a call to the Pardot API and return the account data.
#'
#' @param verbose Verbose output. See pardot_client(). 
#' @return A data frame.
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' df <- pardot_account()}
#' @export pardot_account
#'

pardot_account <- function(verbose = 0) {
	# Evaluate parameters in the context of the parent environment,
	# combine parameters to a querystring e.g. param1=value1&param2=value2&...
	newcall <- quote(pardot_client(object = "account", operator = "read"))
	#thiscall <- match.call()
	#request_params <- paste(paste(names(thiscall[-1]), thiscall[-1], sep = "="), collapse = "&")
	#newcall[["request_pars"]] <- request_params
	newcall[["verbose"]] <- verbose
	eval(newcall, parent.frame())
}
