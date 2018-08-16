#' @importFrom stringr str_subset str_pad
#' @importFrom jsonlite fromJSON
#' @importFrom purrr map
#' @importFrom crul Async set_headers
get_state_data <- function(election_code, state, api_base_url){

    refdf <- readRDS(system.file("county_fips.rds", package = "ygresults", mustWork = TRUE))
    ctys <- stringr::str_subset(stringr::str_pad(refdf[['fips']], 5, pad="0"), paste0("^", state))

    cty_base_url <- paste0(api_base_url, "{election_code}/county/{ctys}")

    api_key <- getOption("results_api_key", NA)

    crul::set_headers(`x-api-key` = api_key)

    cc <- crul::Async$new(
        urls = glue::glue(cty_base_url)
    )

    results <- cc$get()

    purrr::map(results, function(resi){
        cont <- resi$content
        jsonlite::fromJSON(rawToChar(cont), simplifyDataFrame = F)
    })
}
