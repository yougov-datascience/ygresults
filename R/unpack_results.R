#' @importFrom purrr flatten_int
#' @importFrom tibble tibble
flatten_cands <- function(cname, citems){
    tibble::tibble("candidate" = cname,
           party = citems[["party"]],
           votetype = names(citems[["votes"]]),
           votes = purrr::flatten_int(citems[["votes"]]))
}

#' @importFrom purrr pmap_dfr
flatten_offices <- function(oname,
                            oresults){
    flat_cands <- purrr::pmap_dfr(list(cname = names(oresults),
                                       citems = oresults),
                                  flatten_cands)

    flat_cands[["office"]] <- oname
    flat_cands
}


#' @importFrom purrr pmap_dfr
flatten_record <- function(result){
    resl <- result[["office"]]

    flat_votes <- purrr::pmap_dfr(list(oname = names(resl),
                                       oresults = resl),
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
