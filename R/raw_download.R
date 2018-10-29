#' Download Raw data from S3
#'
#' For accessing files placed using \code{\link{raw_upload}}
#'
#' @param election_code Election code
#' @param county_code County code. Typically 5-digit fips
#'
#' @return a data.frame if the uploaded raw data is csv, a list if the data is JSON,
#' and an xml2::xml_document if xml
#'
#' @export
#' @importFrom glue glue
#' @importFrom httr GET add_headers content
raw_download <- function(election_code, county_code){
    api_key <- getOption("results_api_key", NA)
    if (is.na(api_key)){
        stop("API key not found. Please save it in options as `results_api_key`", call. = F)
    }

    api_base_url <- getOption("results_api_url", NA)
    if (is.na(api_base_url)){
        stop("API url not found. Please save it in options as `results_api_url`", call. = F)
    }

    geturl <- "{api_base_url}{election_code}/raw/{county_code}"

    res <- httr::GET(url = glue::glue(geturl),
                     httr::add_headers(`x-api-key` = api_key))

    if(res$status_code >= 400){
        stop(paste0("HTTP Error ", res$status_code), call. = F)
    }

    out <- httr::content(res)

    if (inherits(out, 'raw')){
        tf <- tempfile()
        writeBin(out, tf)
        rc <- paste(readLines(tf), collapse = "\n")
        out <- try({
            readr::read_csv(rc)
        })
        if (inherits(out, "try-error")){
            out <- try({
                jsonlite::fromJSON(rc)
            })
            if (inherits(out, "try-error")){
                warning("could not auto-decompress raw file. You must decompress in your own code",
                        call. = F)
                out <- rc
            }
        }
    }
    out
}
