#' @importFrom purrr map_dfr map_int map_chr
#' @importFrom tibble tibble
flatten_cands <- function(citem){
    tibble::tibble(
        candidate = citem[['name']],
        party = citem[["party"]],
        votetype = purrr::map_chr(citem[["votes"]], "votetype"),
        votes = purrr::map_int(citem[["votes"]], function(v){
            if (is.integer(v$count)){
                return(v$count)
            } else {
                return(NA_integer_)
            }
        })
    )
}

#' @importFrom purrr map_dfr
flatten_offices <- function(oresults){
    candl <- oresults[['candidates']]
    flat_cands <- purrr::map_dfr(candl,
                                 flatten_cands)

    flat_cands[["office"]] <- oresults[['office']]
    flat_cands
}


#' @importFrom purrr map_dfr
flatten_record <- function(result){
    resl <- result[["contests"]]

    flat_votes <- purrr::map_dfr(resl,
                                  flatten_offices)

    for (i in c("cd", "county", "name", "state", "updatetime")){
        flat_votes[[ifelse(i == "name", "precinct", i)]] <- result[[i]]
    }
    flat_votes
}


# changes results from JSON schema to df for the R types
# also drops duplicates
#' @importFrom purrr map_dfr map_chr
unpack_results <- function(res_list){
    id_ls <- purrr::map_chr(res_list, "id")

    ## drops all dupes
    res_list <- res_list[!duplicated(id_ls)]

    purrr::map_dfr(res_list, flatten_record)
}
