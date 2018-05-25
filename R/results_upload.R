#' @importFrom stringi stri_rand_strings
#' @importFrom stringr str_detect
#' @importFrom glue glue
#' @importFrom DBI dbSendQuery
results_upload <- function(df, db, target_table){
    ## typesafety time
    ## cols present?
    req_cols <- c("state", "county", "precinct", "office", "district", "candidate", "party",
                  "votetype", "votes", "updatetime")
    pcols <- !req_cols %in% names(df)
    if (any(pcols)){
        stop(paste0("Schema columns `",
                    paste(req_cols[pcols], collapse = "`, `"),
                    "` not found in `df`"), call. = F)
    }

    sp_cols <- !names(df) %in% req_cols
    if (any(sp_cols)){
        stop(paste0("Non-schema columns `",
                    paste(names(df)[sp_cols], collapse = "`, `"),
                    "` found in `df`. Please remove."), call. = F)
    }

    ## character cols
    for (cn in c("state", "county", "precinct", "office", "candidate", "party")){
        if(!is.character(df[[cn]])){
            stop(paste0("The `", cn, "` column must be a character vector!"), call. = F)
        }
    }

    ## state == fips code?
    if (!all(nchar(df$state) == 2)) stop("The `state` column must be 2 characters long. Please
                                         apply left-padding.", call. = F)
    if (any(str_detect(df$state, "\\D"))) stop("Non-numeric characters detected in `state`. Be
                                               certain your `state` column is a valid FIPS code",
                                               call. = F)

    ## county == fips code?
    if (!all(nchar(df$county) == 3)) stop("The `county` column must be 3 characters long. Please
                                         apply left-padding.", call. = F)
    if (any(str_detect(df$county, "\\D"))) stop("Non-numeric characters detected in `county`. Be
                                               certain your `county` column is a valid FIPS code",
                                               call. = F)

    ## office vector supported?
    office_vals <- c("US Senate", "US House", "Governor", "Lieutenant Governor")
    ors <- !unique(df$office) %in% office_vals
    if(any(ors)){
        stop(paste0("Non-schema values '",
                    paste(unique(df$office)[ors], collapse = "', '"),
                    "' found in `df$office`. Please change to fit schema."), call. = F)
    }

    if(!dplyr::is.src())

    tbhsh_p <- stringi::stri_rand_strings(1, 30, pattern="[a-z]")
    itab <- db %>% dplyr::copy_to(df, name = tbhsh_p)
    tbvars <- paste(names(df), collapse = ", ")
    target_table <- "precincts_all"

    q <- "INSERT INTO {target_table}({tbvars}) SELECT {tbvars} FROM {tbhsh_p};"
    query <- as.character(glue::glue(q))
    dtw <- DBI::dbSendQuery(db$con, query)



}
