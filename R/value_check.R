#' @importFrom purrr flatten_chr
precinct_check <- function(df, ctycode){
    vp <- purrr::flatten_chr(precinct_values[[ctycode]])

    bad_pcts <- unique(df$precinct)[!unique(df$precinct) %in% vp]

    if (length(bad_pcts > 0)){
        warning(paste(paste(bad_pcts, collapse = ", "), "are not valid precinct names!"), call. = F)
    }
}

#' @importFrom purrr walk2
candidate_check <- function(df, ctycode){
    candidate_reference <- candidate_values[[ctycode]]

    cl <- split(df, df[["office"]])
    purrr::walk2(cl, names(cl), function(office_df, n){
        office_candidates <- candidate_reference[[n]]
        if(n == "US House"){
            office_ls <- split(office_df, office_df[["district"]])
            purrr::walk2(office_ls, names(office_ls), function(house_df, d){
                dist_candidates <- c(office_candidates[[d]], "Write-in")
                bad_cands <- unique(house_df$candidate)[!unique(house_df$candidate) %in% dist_candidates]
                if (length(bad_cands > 0)){
                    warning(paste(paste(bad_cands, collapse = ", "),
                                  "are not valid candidate names for",
                                  n, "District", d), call. = F)
                }
            })
        } else {
            office_candidates <- c(office_candidates, "Write-in")
            bad_cands <- unique(office_df$candidate)[!unique(office_df$candidate) %in% office_candidates]
            if (length(bad_cands > 0)){
                warning(paste(paste(bad_cands, collapse = ", "),
                              "are not valid candidate names for",
                              n), call. = F)
            }
        }
    })
    invisible(NULL)
}


#' @importFrom purrr flatten_chr
value_check <- function(df, ctycode){

    ## checks precincts
    precinct_check(df, ctycode)

    ## checks cands
    candidate_check(df, ctycode)

    invisible(NULL)
}
