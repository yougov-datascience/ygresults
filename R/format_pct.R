## formats precincts into list format for JSON munge+upload
#' @importFrom purrr map2
#' @importFrom stats na.omit
format_pct <- function(pct_df, is_primary=FALSE){

    osplit <- split(pct_df, pct_df$office)
    olist <- purrr::map(osplit, function(off_df){

        csplit <- split(off_df, off_df$candidate)
        clist <- purrr::map(csplit, function(cand_df){
            pty <- unique(cand_df$party)
            if (length(pty) > 1 & !is_primary){
                stop("multiple parties submitted for the same candidate", call. = F)
            }

            vsplit <- split(cand_df, cand_df$votetype)
            vlist <- purrr::map(vsplit, function(vt_df){
                if (nrow(vt_df) > 1){
                    stop("identical candidate or votetype submitted in precinct. please correct",
                         call. = F)
                }

                vt_df$votes
            })

            list("party" = pty,
                 "votes" = vlist)
        })

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

    out_list[['office']] <- olist

    out_list
}
