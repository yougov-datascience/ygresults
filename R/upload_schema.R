#' Checks schema of a results dataframe. Good for creating scrapers
#'
#' @param df a dataframe, in schema format.
#'
#' @export
#'
#' @importFrom stringr str_detect
upload_schema <- function(df){
    ## typesafety time
    ## cols present?
    req_cols <- c("state", "county", "precinct", "office", "district", "candidate", "party",
                  "votetype", "votes")
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

    ## numeric cols
    for (cn in c("state", "county", "district", "votes")){
        if(!is.numeric(df[[cn]])){
            stop(paste0("The `", cn, "` column must be a numeric vector!"), call. = F)
        }
    }

    ## character cols
    for (cn in c("precinct", "office", "candidate", "party", "votetype")){
        if(!is.character(df[[cn]])){
            stop(paste0("The `", cn, "` column must be a character vector!"), call. = F)
        }
    }

    ## office vector supported?
    office_vals <- c("US Senate", "US House", "Governor", "Lieutenant Governor")
    ors <- !unique(df$office) %in% office_vals
    if(any(ors)){
        stop(paste0("Non-schema values '",
                    paste(unique(df$office)[ors], collapse = "', '"),
                    "' found in `df$office`. Please change to fit schema."), call. = F)
    }
    df
}
