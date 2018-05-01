#' Upsert a DF into a table
#'
#' @param df data.frame to upsert
#' @param db database src at which the target table resides (can be a \code{tbl} object)
#' @param target_table name of the target table (as a character vector)
#'
#' @return NULL
#' @importFrom stringi stri_rand_strings
#' @importFrom dplyr copy_to
#' @importFrom glue glue
#' @importFrom dbi dbSendQuery
#' @export
upsert <- function(df, db, target_table){
    ## TODO: PUT SOME TYPE SAFETY HERE

    tbhsh <- stringi::stri_rand_strings(1, 30, pattern="[a-z]")
    itab <- dplyr::copy_to(db, df, name = tbhsh)
    tbvars <- names(df)

    ## Maybe make conflict columns a parameter?
    q <- "BEGIN;
          INSERT INTO {target_table}({tbvars})
          (SELECT {tbvars} FROM {tbhsh})
          ON CONFLICT (state, county, precinct, office, district, candidate, party)
          DO UPDATE SET votes = excluded.votes;
          COMMIT;"

    query <- as.character(glue::glue(q))

    ## TODO: test whether `db` is an src (db$con) or a postgres src
    DBI::dbSendQuery(db$con, query)

    invisible(NULL)
}
