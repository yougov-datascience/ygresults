#' Checks schema of a results dataframe. Good for creating scrapers
#'
#' @param df a dataframe, in schema format.
#' @param is_primary logical. is this a primary election?
#'
#' @export
#'
#' @importFrom stringr str_detect
#' @importFrom purrr map flatten_chr
results_schema <- function(df, is_primary){
    df <- schema_check(df, is_primary = is_primary)

    if(getOption("value_check", default = TRUE)){
        value_check(df)
    }

    df
}
