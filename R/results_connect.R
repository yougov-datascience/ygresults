#' Connects to results database
#' @param dbname database name
#' @param host postgresql host. defaults to \code{getOption("results_host")}
#' @param port port \code{getOption("results_port")}
#' @param username username \code{getOption("results_user")}
#' @param password password \code{getOption("results_pass")}
#'
#' @importFrom dplyr src_postgres
#' @export
results_connect <- function(dbname = "precinct_results",
                            host = getOption("results_host", NA),
                            port = getOption("results_port", NA),
                            username = getOption("results_user", NA),
                            password = getOption("results_pass", NA)){

    missingLogin <- any(is.na(host), is.na(port), is.na(username), is.na(password))
    if(missingLogin) stop("You must supply a valid host, port, username and password", call. = F)

    dplyr::src_postgres(dbname = dbname, host = host, port = port,
                 username = username, passwrod = password)
}


