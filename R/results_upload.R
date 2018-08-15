
#' @importFrom httr PUT
#' @importFrom purrr map
#' @importFrom glue glue
results_upload <- function(df, election_code){
    api_key <- getOption("results_api_key", NA)
    if (is.na(api_key)){
        stop("API key not found. Please save it in options as `results_api_key`", call. = F)
    }

    api_base_url <- getOption("results_api_url", NA)
    if (is.na(api_base_url)){
        stop("API url not found. Please save it in options as `results_api_url`", call. = F)
    }

    put_base <- paste0(api_base_url, "{election_code}/write")

    pct_ls <- split(df, paste0(df[['state']], df[['county']], df[['precinct']]))

    payload <- list(
        "precincts" = unname(purrr::map(pct_ls, format_pct))
    )

    httr::PUT(glue::glue(put_base), httr::add_headers(`x-api-key` = api_key),
              body = payload, encode = "json")
}
