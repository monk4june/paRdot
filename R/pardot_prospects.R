#' Retrieve Pardot Prospects
#'
#' Make a call to the Pardot API and return the prospects matching the specified criteria parameters. 
#'
#' @param ... Comma separated list of parameter name and parameter value pairs. Parameter names are not quoted. 
#'   Allowed parameter names are assigned, assigned_to_user, created_after, created_before, deleted, grade_equal_to,
#'   grade_greater_than, grade_less_than, id_greater_than, id_less_than, is_starred, last_activity_before, 
#'   last_activity_after, last_activity_never, list_id, new, score_equal_to, score_greater_than, score_less_than, 
#'   updated_after, updated_before.
#' @return A tbl_df data frame.
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' df <- pardot_prospects()
#' df <- pardot_prospects(created_after = 'today')}
#' @export pardot_prospects
#'

pardot_prospects <- function(...) {
	# Evaluate parameters in the context of the parent environment,
	# combine parameters to a querystring e.g. param1=value1&param2=value2&...
	newcall <- quote(pardot_client(object = "prospect", operator = "query"))
	thiscall <- match.call()
	request_params <- paste(paste(names(thiscall[-1]), thiscall[-1], sep = "="), collapse = "&")
	newcall[["request_pars"]] <- request_params
	eval(newcall, parent.frame())
}
