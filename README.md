# ygresults

[![Build Status](https://travis-ci.com/yougov-datascience/ygresults.svg?token=nrN8ZtNwgknk3Sx8oNap&branch=master)](https://travis-ci.com/yougov-datascience/ygresults)
[![Build status](https://ci.appveyor.com/api/projects/status/8g0kl75hl07s3lpk?svg=true)](https://ci.appveyor.com/project/npelikan/ygresults-db86a)
 [![Coverage status](https://codecov.io/gh/yougov-datascience/ygresults/branch/master/graph/badge.svg)](https://codecov.io/github/yougov-datascience/ygresults?branch=master)

## Functions to download precinct results from YG API

### Installation
```{r}
devtools::install_github('yougov-datascience/ygresults')
```


### Required options:
```{r}
options(results_api_key = <your api key>,
        results_api_url = <your api base url>)
```

### Optional Parameters:
All listed as their defaults

```{r}
options(parallel_unpacking = TRUE, # controls whether unpacking is completed in parallel (windows machines may have issues with this)
        parallel_packing = TRUE, # controls whether packing for upload is done in parallel
        parallel_download = TRUE # controls whether requests for multiple counties are executed simultaneously or serially
        )
```

### Usage:

```
df <- results_get("test_20180828", county = "04019")
```

Returns a `?tibble::tibble`, in 'tidy' (read: long) format. 
