#' @importFrom stringr str_pad
left_pad <- function(x, n, pad='0'){
    stringr::str_pad(x, n, 'left', pad=pad)
}

#' Correctly capitalizes most last names.
#'
#' @param x  A character vector of names
#'
#' @return A character vector of correctly capitalized names
#'
#' @importFrom tools toTitleCase
#' @importFrom stringr str_sub str_replace
#' @export
capitalize_names <- function(x) {
    stringr::str_replace(tools::toTitleCase(tolower(x)),
                "\\b(Mc|O'|Mac)[a-z]{1}", ## detects secondary caps needed
                function(st){ ## capitalizes the next char
                    paste0(stringr::str_sub(st, end = nchar(st)-1),
                           toupper(stringr::str_sub(st, start=nchar(st))))
                })
}


#' Returns a character vector of expected precinct names
#'
#' @param county_code 5-digit FIPS county code
#'
#' @return A character vector of expected precinct names
#' @export
#' @importFrom purrr flatten_chr
schema_precincts <- function(county_code){
    purrr::flatten_chr(precinct_values[[county_code]])
}
