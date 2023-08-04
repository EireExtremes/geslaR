
<!-- README.md is generated from README.Rmd. Please edit that file -->

# geslaR

Get And Manipulate the GESLA Dataset

<!-- badges: start -->
<!-- [![R-CMD-check](https://github.com/EireExtremes/geslaR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/EireExtremes/geslaR/actions/workflows/R-CMD-check.yaml) -->
<!-- Main branch -->
<!-- [![R-CMD-check](https://github.com/EireExtremes/geslaR/actions/workflows/R-CMD-check.yaml/badge.svg?branch=dev)](https://github.com/EireExtremes/geslaR/actions/workflows/R-CMD-check.yaml) -->
<!-- Development branch -->
<!-- [![test-coverage](https://github.com/EireExtremes/geslaR/actions/workflows/test-coverage.yaml/badge.svg?branch=main)](https://github.com/EireExtremes/geslaR/actions/workflows/test-coverage.yaml) Main branch -->
<!-- [![test-coverage](https://github.com/EireExtremes/geslaR/actions/workflows/test-coverage.yaml/badge.svg?branch=dev)](https://github.com/EireExtremes/geslaR/actions/workflows/test-coverage.yaml) Development branch -->
<!-- [![Codecov test coverage](https://codecov.io/gh/EireExtremes/geslaR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/EireExtremes/geslaR?branch=main) -->
<!-- badges: end -->

| **Action** | `R-CMD-check`                                                                                                                                                                    | `test-coverage`                                                                                                                                                                                    | `pkgdown`                                                                                                                                                                        | `codecov`                                                                                                                                                    |
|:----------:|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Status** | [![R-CMD-check](https://github.com/EireExtremes/geslaR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/EireExtremes/geslaR/actions/workflows/R-CMD-check.yaml) | [![test-coverage](https://github.com/EireExtremes/geslaR/actions/workflows/test-coverage.yaml/badge.svg?branch=main)](https://github.com/EireExtremes/geslaR/actions/workflows/test-coverage.yaml) | [![pkgdown](https://github.com/EireExtremes/geslaR/actions/workflows/pkgdown.yaml/badge.svg?branch=main)](https://github.com/EireExtremes/geslaR/actions/workflows/pkgdown.yaml) | [![Codecov test coverage](https://codecov.io/gh/EireExtremes/geslaR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/EireExtremes/geslaR?branch=main) |

The geslaR package was developed to deal with the
[GESLA](https://gesla787883612.wordpress.com) (Global Extreme Sea Level
Analysis) dataset.

## Installation

You can install the development version of geslaR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("EireExtremes/geslaR")
```

## Examples

``` r
library(geslaR)
#> Loading required package: arrow
#> 
#> Attaching package: 'arrow'
#> The following object is masked from 'package:utils':
#> 
#>     timestamp
#> Loading required package: dplyr
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

##------------------------------------------------------------------
## Import an internal example Parquet file
tmp <- tempdir()
file.copy(system.file(
    "extdata", "antarctica.parquet", package = "geslaR"), tmp)
#> [1] TRUE
da <- read_gesla(paste0(tmp, "/antarctica.parquet"))
## Check size in memory
object.size(da)
#> 488 bytes

##------------------------------------------------------------------
## Import an internal example CSV file
tmp <- tempdir()
file.copy(system.file(
    "extdata", "antarctica.csv", package = "geslaR"), tmp)
#> [1] TRUE
da <- read_gesla(paste0(tmp, "/antarctica.csv"))
## Check size in memory
object.size(da)
#> 488 bytes

##------------------------------------------------------------------
## Import an internal example Parquet file as data.frame
tmp <- tempdir()
file.copy(system.file(
    "extdata", "antarctica.parquet", package = "geslaR"), tmp)
#> [1] FALSE
da <- read_gesla(paste0(tmp, "/antarctica.parquet"),
    as_data_frame = TRUE)
## Check size in memory
object.size(da)
#> 62664 bytes

##------------------------------------------------------------------
## Import an internal example CSV file as data.frame
tmp <- tempdir()
file.copy(system.file(
    "extdata", "antarctica.csv", package = "geslaR"), tmp)
#> [1] FALSE
da <- read_gesla(paste0(tmp, "/antarctica.csv"),
    as_data_frame = TRUE)
## Check size in memory
object.size(da)
#> 62656 bytes
```

``` r
## Query a subset of the GESLA dataset, without the need of downloading
## all the dataset
de <- query_gesla(country = "IRL", year = 2020:2021, as_data_frame = FALSE)
#> ℹ This process can take some time, as it depends on the size of the final
#> dataset, and on internet connection.
#> ℹ Connecting to the data server...
#> ✔ Connecting to the data server... [3.1s]
#> 
#> ℹ Filtering data...
#> ✔ Filtering data... [30ms]
#> 
#> ℹ Query finished.
#> ✔ Query finished. [30ms]
#> 
class(de)
#> [1] "arrow_dplyr_query"
```

``` r
## Download the whole dataset (parquet files) into a specific location
download_gesla(dest = "./gesla_dataset")
## ℹ The total size of the dataset is about 7GB, and the download time will depend on
## your internet connection
## Do you want to download the whole dataset?

## 1: Yes
## 2: No

## Selection: 1
## ℹ Wait while the dataset is downloaded...
```

``` r
## This function will download the whole dataset (if not yet done), and
## open the geslar-app web interface locally on your browser
run_gesla_app()
```

# Acknowledgements

This work has emanated from research conducted with the financial
support of Science Foundation Ireland and co-funded by GSI under Grant
number 20/FFP-P/8610.

<img src="man/figures/logos2.png" width="100%" />
