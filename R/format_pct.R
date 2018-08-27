## formats precincts into list format for JSON munge+upload
#' @importFrom purrr map2 map
#' @importFrom stats na.omit
format_pct <- function(pct_df, is_primary=FALSE){

    osplit <- split(pct_df, pct_df$office)
    olist <- purrr::map2(unname(osplit), names(osplit), function(off_df, off_nm){

        csplit <- split(off_df, off_df$candidate)
        clist <- purrr::map2(unname(csplit), names(csplit), function(cand_df, cand_nm){
            pty <- unique(cand_df$party)
            if (length(pty) > 1 & !is_primary){
                stop("multiple parties submitted for the same candidate", call. = F)
            }

            vsplit <- split(cand_df, cand_df$votetype)
            vlist <- purrr::map2(unname(vsplit), names(vsplit), function(vt_df, vt_nm){
                if (nrow(vt_df) > 1){
                    stop("identical candidate or votetype submitted in precinct. please correct",
                         call. = F)
                }

                list("count" = vt_df$votes,
                     "votetype" = vt_nm)
            })

            list("party" = pty,
                 "name" = cand_nm,
                 "votes" = vlist)
        })


        list(office = off_nm,
             candidates = clist)
    })

    out_list <- list()

    for (i in c("state", "county", "district", "precinct")){
        if (i == "district"){
            on <- "cd"
            ov <- unique(na.omit(pct_df[[i]]))
        } else if (i == "precinct") {
            on <- "name"
            ov <- unique(pct_df[[i]])
        } else {
            on <- i
            ov <- unique(pct_df[[i]])
        }

        if (length(ov) > 1) stop(paste0("non-unique values proviced to ", i), call. = F)

        out_list[[on]] <- ov
    }

    out_list[['contests']] <- olist

    out_list
}
