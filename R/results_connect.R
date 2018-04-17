#' Connect to precinct results database
#'
#' \code{host, port, user} and \code{pass} can be passed in as \code{options("results_*")}
#'
#' @param dbname database name
#' @param host hostname
#' @param port port
#' @param user username
#' @param pass password
#'
#' @return a database connection object
#' @export
#'
#' @importFrom dplyr src_postgres
results_connect <- function(dbname,
                            host = getOption("results_host", NA),
                            port = getOption("results_port", NA),
                            user = getOption("results_user", NA),
                            pass = getOption("results_pass", NA)) {
    dplyr::src_postgres(dbname = dbname, host = host,
                        port = port, user = user, pass = pass)
}


