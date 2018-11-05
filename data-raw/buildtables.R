library(tidyverse)
library(jsonlite)


precinct_values <- read_json("../precinct_data_api/precinct_data_api/precinct_ingest/values/pct_dict.json",
                             simplifyVector = T)

candidate_values <- read_json("../precinct_data_api/precinct_data_api/precinct_ingest/values/cand_dict.json") %>%
    map(function(c){
        map(c, function(of){
            if (!is.null(names(of))){
                map(of, function(cd){
                    purrr::flatten_chr(cd)
                })
            } else {
                purrr::flatten_chr(of)
            }
        })
    })

devtools::use_data(precinct_values, candidate_values,
                   internal = TRUE, overwrite = TRUE)
