#' Retrieve Pardot Lifecycle Histories
#'
#' Make a call to the Pardot API and return the lifecycle histories matching the specified criteria parameters. 
#'
#' @param ... Comma separated list of parameter name and parameter value pairs. Parameter names are not quoted. 
#'   Allowed parameter names are created_after, created_before, id_greater_than, id_less_than.
#' @param verbose Verbose output. See pardot_client(). 
#' @return A data frame.
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' df <- pardot_lifecycle_histories()
#' df <- pardot_lifecycle_histories(id_greater_than = '123')}
#' @export pardot_lifecycle_histories
#'

pardot_lifecycle_histories <- function(..., verbose = 0) {
	# Evaluate parameters in the context of the parent environment,
	# combine parameters to a querystring e.g. param1=value1&param2=value2&...
	newcall <- quote(pardot_client(object = "lifecycleHistory", operator = "query"))
	thiscall <- match.call()
	thiscall <- thiscall[names(thiscall) != "verbose"]
	request_params <- paste(paste(names(thiscall[-1]), thiscall[-1], sep = "="), collapse = "&")
	newcall[["request_pars"]] <- request_params
	newcall[["verbose"]] <- verbose
	eval(newcall, parent.frame())
}
