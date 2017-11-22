#' Retrieve Pardot Lifecycle Stages
#'
#' Make a call to the Pardot API and return the lifecycle stages matching the specified criteria parameters. 
#'
#' @param ... Comma separated list of parameter name and parameter value pairs. Parameter names are not quoted. 
#'   Allowed parameter names are id_greater_than, id_less_than.
#' @return A tbl_df data frame.
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' df <- pardot_lifecycle_stages()
#' df <- pardot_lifecycle_stages(id_greater_than = '123')}
#' @export pardot_lifecycle_stages
#'

pardot_lifecycle_stages <- function(...) {
	# Evaluate parameters in the context of the parent environment,
	# combine parameters to a querystring e.g. param1=value1&param2=value2&...
	newcall <- quote(pardot_client(object = "lifecycleStage", operator = "query"))
	thiscall <- match.call()
	request_params <- paste(paste(names(thiscall[-1]), thiscall[-1], sep = "="), collapse = "&")
	newcall[["request_pars"]] <- request_params
	eval(newcall, parent.frame())
}
