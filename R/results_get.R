#' Retrieves election information from external API
#'
#' @param elec_code Election code, as a string
#'
#' @param state State as either a zero-padded fips code ("04") or a postal code ("AZ")
#' @param county County as full 5-digit fips code ("01001")
#' @param cd CD as either fips + district number ("0408") or postal code + district number ("AZ08")
#'
#' @importFrom glue glue
#' @importFrom purrr pmap map flatten map_dfr map_lgl
#' @importFrom stringr str_sub
#' @importFrom crul HttpRequest HttpClient AsyncVaried
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content add_headers
#' @export
results_get <- function(elec_code,
                        state = NULL,
                        county = NULL,
                        cd = NULL){

    api_key <- getOption("results_api_key", NA)
    if (is.na(api_key)){
        stop("API key not found. Please save it in options as `results_api_key`", call. = F)
    }

    api_base_url <- getOption("results_api_url", NA)
    if (is.na(api_base_url)){
        stop("API url not found. Please save it in options as `results_api_url`", call. = F)
    }

    if (all(is.null(c(state, county, cd)))){
        stop("One of `state`, `county` or `cd` must be non-null")
    }


    if (!is.null(state)){
        if (!is.character(state)) stop("`state` must be a character vector", call. = F)
        if(any(nchar(state) != 2)) stop("`state` must be 2-character string, please zero-pad if needed",
                                        call. = F)
        state <- postal_replace_fips(state)
    }

    if (!is.null(county)){
        if (!is.character(county)) stop("`county` must be a character vector", call. = F)
        if(any(nchar(county) != 5)) stop("`county` must be 5-character string, please zero-pad if needed",
                                         call. = F)
    }

    if (!is.null(cd)){
        if (!is.character(cd)) stop("`cd` must be a character vector", call. = F)
        if(any(nchar(cd) != 4)) stop("`cd` must be 4-character string, please zero-pad if needed",
                                     call. = F)
        cd <- postal_replace_fips(cd)
    }

    qlist <- list(state = state,
                  county = county,
                  cd = cd)

    qlist <- qlist[!purrr::map_lgl(qlist, is.null)]

    ## throws warning if duplicated state + cd or state+county calls exist
    if ('state' %in% names(qlist) & any(c('county', 'cd') %in% names(qlist))){
        cd_cty_states <- c()
        if ('county' %in% names(qlist)){
            cd_cty_states <- c(cd_cty_states, stringr::str_sub(qlist[['county']], end=2))
        }
        if ('cd' %in% names(qlist)){
            cd_cty_states <- c(cd_cty_states, stringr::str_sub(qlist[['cd']], end=2))
        }

        if (any(qlist[['state']] %in% cd_cty_states)){
            warning("You have submitted arguments to `cd` and `county` that overlap with your selection in `state`. This is unnecessary and will substantially reduce performance.",
                    call. = F)
        }
    }

    ql <- purrr::flatten(
        purrr::pmap(
            list(x = qlist,
                 n = names(qlist)),
            function(x, n){
                purrr::map(x, function(y) list(qtype = n, qitem = y))
            }
        )
    )

    if (getOption("parallel_download", TRUE)){
        reql <- purrr::map(ql, function(rp){
            crul::HttpRequest$new(
                url = glue::glue("{api_base_url}{elec_code}/{rp$qtype}/{rp$qitem}"),
                headers = list('x-api-key' = api_key)
            )$get()
        })

        out <- crul::AsyncVaried$new(.list = reql)
        out$request()
        resp_list <- purrr::map(out$parse(), jsonlite::fromJSON,
                                simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
    } else {
        resp_list <- purrr::map(ql, function(rp){
            resp <- httr::GET(glue::glue("{api_base_url}{elec_code}/{rp$qtype}/{rp$qitem}"),
                              httr::add_headers(`x-api-key` = api_key))
            if (resp$status_code != 200){
                stop(paste0("HTTP error ", resp$status_code), call. = F)
            } else {
                httr::content(resp)
            }
        })
    }

    purrr::map_dfr(resp_list, unpack_results)
}
