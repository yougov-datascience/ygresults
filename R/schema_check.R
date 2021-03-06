#' @importFrom purrr flatten_chr map
schema_check <- function(df, is_primary){
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

    ## party values
    party_vals <- c("Rep", "Dem", "Grn", "Lib", "Ind", "Oth")
    prs <- !unique(df$party) %in% party_vals
    if(any(prs)){
        stop(paste0("Non-schema values '",
                    paste(unique(df$party)[prs], collapse = "', '"),
                    "' found in `df$party`. Please change to fit schema."), call. = F)
    }

    ## votetype values
    votetype_vals <- c("Early", "All", "Election", "Provisional")
    vtf <- !unique(df$votetype) %in% votetype_vals
    if(any(prs)){
        stop(paste0("Non-schema values '",
                    paste(unique(df$votetype)[vtf], collapse = "', '"),
                    "' found in `df$party`. Please change to fit schema."), call. = F)
    }
    if (!(any(c("Election", "All") %in% unique(df$votetype)))){
        stop("Critical votetype entries missing. You must provide one of `Election` or `All`",
             call. = F)
    }

    ## office vector supported?
    office_vals <- c("US Senate", "US House", "Governor", "Lieutenant Governor", "Attorney General")
    if (is_primary){
        office_vals <- purrr::flatten_chr(purrr::map(party_vals, ~paste0(office_vals, " - ", .x)))
    }
    ors <- !unique(df$office) %in% office_vals
    if(any(ors)){
        stop(paste0("Non-schema values '",
                    paste(unique(df$office)[ors], collapse = "', '"),
                    "' found in `df$office`. Please change to fit schema."), call. = F)
    }
    df
}
