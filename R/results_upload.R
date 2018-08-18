
#' Uploads results to API
#' @param df data.frame with schema columns (see vignette for details)
#'
#' @param election_code string election code denominator
#' @param is_primary deactivates party -- candidate checking for primaries
#'
#' @importFrom purrr map
#' @importFrom glue glue
#' @importFrom httr PUT
#' @export
results_upload <- function(df, election_code, is_primary=FAlse){
    df <- results_schema(df)
    api_key <- getOption("results_api_key", NA)
    if (is.na(api_key)){
        stop("API key not found. Please save it in options as `results_api_key`", call. = F)
    }

    api_base_url <- getOption("results_api_url", NA)
    if (is.na(api_base_url)){
        stop("API url not found. Please save it in options as `results_api_url`", call. = F)
    }

    put_base <- paste0(api_base_url, election_code, "/write")

    pct_ls <- split(df, paste0(df[['state']], df[['county']], df[['precinct']]))

    formatted_pcts <- unname(purrr::map(pct_ls, format_pct, is_primary=is_primary))

    ## splits into precinct chunks of size 100
    pchunks <- split(formatted_pcts, ceiling(seq_along(formatted_pcts)/50))

    purrr::map(pchunks, function(chk){
        httr::PUT(put_base,
                  httr::add_headers(`x-api-key` = api_key),
                  body = list("precincts" = chk), encode = "json")
    })
}
