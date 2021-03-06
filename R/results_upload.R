
#' Uploads results to API
#' @param df data.frame with schema columns:
#' \enumerate{
#'     \item precinct -- character. L2 precinct name. Use \code{\link{schema_precincts}} to see valid values
#'     \item office -- character. One of "US Senate", "US House", "Governor", "Lieutenant Governor"
#'     \item district -- integer. Congressional district.
#'     \item candidate -- character. Last name only, unless a disambiguating first initial needed.
#'     \item party -- 3 character party abbreviation: (Rep, Dem, Grn, Lib, Ind, Oth)
#'     \item votetype -- character. One of "All" (for counties that do not differentiate) "Early", "Election", "Provisional
#'     \item votes -- integer
#' }
#'
#' @param election_code string election code
#' @param county_code string county code (5-digit FIPS)
#' @param is_primary deactivates party -- candidate checking for primaries
#'
#' @importFrom purrr map map_lgl
#' @importFrom glue glue
#' @importFrom httr PUT add_headers
#' @importFrom parallel detectCores mclapply
#' @importFrom uuid UUIDgenerate
#' @export
results_upload <- function(df, election_code, county_code, is_primary=FALSE){


    df <- results_schema(df, county_code = county_code, is_primary=is_primary)
    api_key <- getOption("results_api_key", NA)
    if (is.na(api_key)){
        stop("API key not found. Please save it in options as `results_api_key`", call. = F)
    }

    api_base_url <- getOption("results_api_url", NA)
    if (is.na(api_base_url)){
        stop("API url not found. Please save it in options as `results_api_url`", call. = F)
    }

    put_base <- "{api_base_url}{election_code}/clean/{county_code}/{uuid::UUIDgenerate()}.json"

    pct_ls <- split(df, paste0(df[['state']], df[['county']], df[['precinct']]))

    multi_district <- purrr::map_lgl(pct_ls, ~length(unique(na.omit(.x[['district']])))>1)

    if (getOption("parallel_packing", TRUE)){
        formatted_pcts <- unname(parallel::mclapply(pct_ls[!multi_district], format_pct,
                                                    is_primary=is_primary,
                                                    mc.cores = parallel::detectCores()))
    } else {
        formatted_pcts <- unname(purrr::map(pct_ls[!multi_district], format_pct, is_primary=is_primary))
    }

    if(sum(multi_district) >= 1){
        multi_little <- map(pct_ls[multi_district], function(d){
            d[d$district %in% min(d$district, na.rm = T) | is.na(d$district),]
        })

        multi_oth <- map(pct_ls[multi_district], function(d){
            ot <- d[d$district %in% min(d$district, na.rm = T),]
            # ot$precinct <- paste0(ot$precinct, " District ", unique(ot$district))
            ot
        })

        formatted_pcts <- c(
            formatted_pcts,
            unname(purrr::map(multi_little, format_pct, is_primary=is_primary)),
            unname(purrr::map(multi_oth, format_pct, is_primary=is_primary))
        )
    }



    httr::PUT(glue::glue(put_base),
              httr::add_headers(`x-api-key` = api_key),
              body = formatted_pcts, encode = "json")
}
