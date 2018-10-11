#' Raw data to s3
#'
#' This uploads Raw data to S3, for uploading.
#'
#' @param data a data.frame, list, or file path. Data.frames will be uploaded as csvs,
#' lists will be uploaded as JSON, and files provided as paths will be uploaded as-is
#' @param election_code Election code
#' @param county_code County code. Typically 5-digit fips/
#'
#' @return Nothing
#' @export
#'
#' @importFrom readr write_csv
#' @importFrom jsonlite write_json
#' @importFrom uuid UUIDgenerate
#' @importFrom tools file_ext
#' @importFrom glue glue
#' @importFrom httr PUT add_headers upload_file content
raw_upload <- function(data, election_code, county_code){
    if (inherits(data, "data.frame")) {
        tf <- tempfile(fileext = ".csv")
        readr::write_csv(data, tf)
    } else if (inherits(data, "list")){
        tf <- tempfile(fileext = ".json")
        jsonlite::write_json(data, tf, auto_unbox=TRUE)
    } else if (inherits(data, "character") & length(data == 1)) {
        if (file.exists(data)) {
            tf <- data
        } else {
            stop("`data` argument must be a data.frame, list, or valid file path", call. = F)
        }
    } else {
        stop("`data` argument must be a data.frame, list, or valid file path", call. = F)
    }

    api_key <- getOption("results_api_key", NA)
    if (is.na(api_key)){
        stop("API key not found. Please save it in options as `results_api_key`", call. = F)
    }

    api_base_url <- getOption("results_api_url", NA)
    if (is.na(api_base_url)){
        stop("API url not found. Please save it in options as `results_api_url`", call. = F)
    }

    puturl <- "{api_base_url}{election_code}/raw/{county_code}/{uuid::UUIDgenerate()}.{tools::file_ext(tf)}"

    fd <- httr::upload_file(tf)
    res <- httr::PUT(url = glue::glue(puturl),
        httr::add_headers(`x-api-key` = api_key),
        body = fd)

    if (res$status_code != 200){
        emsg = as.character(glue::glue("HTTP Error {res$status_code}:\n {httr::content(res)}"))
        stop(emsg, call. = F)
    }
    invisible(NULL)
}
