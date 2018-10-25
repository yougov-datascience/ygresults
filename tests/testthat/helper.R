options(results_api_key = "122345",
        results_api_url = "fakeaws.cc/dev/results/",
        parallel_unpacking = FALSE,
        parallel_packing = FALSE,
        parallel_download = FALSE,
        value_check = FALSE)


# reads in json fixture in format expected by httptest
get_fixture <- function(file){
    paste0({
        gsub(": ", ":", trimws(readLines(file)), fixed = TRUE)
    }, collapse = "")
}
