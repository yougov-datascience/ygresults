# ygresults

[![Build Status](https://travis-ci.com/yougov-datascience/ygresults.svg?token=nrN8ZtNwgknk3Sx8oNap&branch=master)](https://travis-ci.com/yougov-datascience/ygresults)

## Functions to download precinct results from YG API

### Required options:
```{r}
options(results_api_key = <your api key>,
        results_api_url = <your api base url>)
```

### Usage:

```
df <- results_get("test_20180812", state = "04")
```

Returns a `?tibble::tibble`, in 'tidy' (read: long) format. 
