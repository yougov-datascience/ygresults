#' ygresults: rapid results download and tidy
#'
#' ygresults allows for rapid results download and analysis from the yougov precinct data api
#'
#' @docType package
#' @name ygresults
NULL

.onLoad <- function(lib, pkgname = 'ygresults'){
    ## disables parallel execution if on non-unix OS
    if(.Platform$OS.type != "unix") {
        setIfNotAlready(
            parallel_unpacking = FALSE,
            parallel_packing = FALSE
        )
    }
}

#' @importFrom utils modifyList
setIfNotAlready <- function(...) {
    newopts <- list(...)
    oldopts <- options()
    oldopts <- oldopts[intersect(names(newopts), names(oldopts))]
    newopts <- modifyList(newopts, oldopts)
    do.call(options, newopts)
    invisible(oldopts)
}
