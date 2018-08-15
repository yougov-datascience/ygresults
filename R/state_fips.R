state.postal.codes <- c("AL", "AK", NA, "AZ", "AR", "CA", NA, "CO", "CT", "DE", #10
                        "DC", "FL", "GA", NA, "HI", "ID", "IL", "IN", "IA", "KS", #20
                        "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", #30
                        "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", #40
                        "OR", "PA", NA, "RI", "SC", "SD", "TN", "TX", "UT", "VT", #50
                        "VA", NA, "WA", "WV", "WI", "WY", NA, NA, NA, "AS", #60
                        NA, NA, NA, "FM", NA, "GU", NA, "MH", "MP", "PW", #70
                        NA, "PR", NA, "UM", NA, NA, NA, "VI", NA, NA, #80
                        "AB", "BC", "MB", "NB", "NL", "NT", "NS", "NU", "ON", "PE", #90
                        "QC", "SK", "YT") #93

#' Conversion to/from FIPS codes.
#'
#' Converts US states, US territories and Canadian provinces from numeric FIPS code to 2-letter postal code, and vise versa.
#'
#' @param index a numeric vector (for conversion from FIPS to postal code) or a character vector (for conversion from postal code to FIPS)
#'
#' @return a numeric or character vector
#' @export
#' @importFrom stats na.omit
state_fips <- function (index) {
    if(!is.numeric(index) & !is.character(index)) stop("Index is not numeric or character. Please supply a numeric or character vector", call. = FALSE)
    if (is.numeric(index)) {
        state.postal.codes[index]
    } else if (is.character(index)) {
        ids <- seq_along(state.postal.codes)[!is.na(state.postal.codes)]
        st <- na.omit(state.postal.codes)
        ids[match(index, st)]
    }
}
