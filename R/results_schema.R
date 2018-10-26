#' Checks schema of a results dataframe. Good for creating scrapers
#'
#'
#'
#' @param df a dataframe, in schema format.
#' @param county_code character. 5-digit county FIPS
#' @param is_primary logical. is this a primary election?
#'
#' @export
#'
#' @importFrom stringr str_detect str_sub
#' @importFrom purrr map flatten_chr
results_schema <- function(df, county_code, is_primary = FALSE){
    if (nchar(county_code) != 5) stop("county-code must be a 5-digit fips. please zero-pad if necessary",
                                      call. = F)

    df$state <- as.integer(str_sub(county_code, end=2))
    df$county <- as.integer(str_sub(county_code, start=3))

    df <- schema_check(df, is_primary = is_primary)

    if(getOption("value_check", default = TRUE)){
        value_check(df, ctycode = county_code)
    }

    df
}
