#' Upload results to postgres database
#'
#' @param df results dataframe in schema format
#' @param db src_postgres to results database
#' @param target_table target table in results db to append to
#'
#' @importFrom stringi stri_rand_strings
#' @importFrom glue glue
#' @importFrom DBI dbSendQuery
#' @export
results_upload <- function(df, db, target_table){
    ## typesafety time
    ## cols present?
    df <- results_schema(df)

    if(!dplyr::is.src(db)) stop("`db` must be a `src` object. Please use results_connect().")

    tbhsh_p <- stringi::stri_rand_strings(1, 30, pattern="[a-z]")
    itab <- db %>% dplyr::copy_to(df, name = tbhsh_p)
    tbvars <- paste(names(df), collapse = ", ")
    target_table <- "precincts_all"

    q <- "INSERT INTO {target_table}({tbvars}) SELECT {tbvars} FROM {tbhsh_p};"
    query <- as.character(glue::glue(q))
    DBI::dbSendQuery(db$con, query)
    return(invisible(df))
}
