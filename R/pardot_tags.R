#' Retrieve Pardot Tags
#'
#' Make a call to the Pardot API and return the tags matching the specified criteria parameters. 
#'
#' @param ... Comma separated list of parameter name and parameter value pairs. Parameter names are not quoted. 
#'   Allowed parameter names are created_after, created_before, id_greater_than, id_less_than.
#' @param verbose Verbose output. See pardot_client(). 
#' @return A data frame. See http://developer.pardot.com/kb/object-field-references/#tag.
#' @examples
#' \dontrun{
#' set_credentials("your-username", "your-password", "your-user-key")
#' df <- pardot_tags()
#' df <- pardot_tags(created_after = 'yesterday') }
#' @export pardot_tags
#' @import pryr

pardot_tags <- function(..., verbose = 0) {
    # Evaluate parameters in the context of the parent environment,
    # combine parameters to a querystring e.g. param1=value1&param2=value2&...
    dots <- lapply(pryr::named_dots(...), function(p) {
        eval(p, parent.frame())
    })
    request_pars <- paste(paste(names(dots), unlist(dots), sep = "="), collapse = "&")
    pardot_client("tag", "query", request_pars = request_pars, verbose = verbose)  
}
