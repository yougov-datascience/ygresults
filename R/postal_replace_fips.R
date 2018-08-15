#' @importFrom stringr str_detect str_sub str_pad
postal_replace_fips <- function(in_vec){
    statepart <- stringr::str_sub(in_vec, end = 2)
    nonstate <- stringr::str_sub(in_vec, start = 3)

    non_fips <- stringr::str_detect(statepart, "\\D")
    statepart[non_fips] <- stringr::str_pad(state_fips(statepart[non_fips]), 2, pad = "0")
    paste0(statepart, nonstate)
}
