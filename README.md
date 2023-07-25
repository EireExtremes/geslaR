
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

##----------------------------------------------------------------------
## Read files downloaded from the Shiny interface

## Read a CSV file as Table
da <- read_gesla(
    file = system.file("extdata", "antarctica.csv", package = "geslaR"),
    as_data_frame = FALSE
)
class(da)
#> [1] "Table"        "ArrowTabular" "ArrowObject"  "R6"

## Read a CSV file as data frame
db <- read_gesla(
    file = system.file("extdata", "antarctica.csv", package = "geslaR"),
    as_data_frame = TRUE
)
class(db)
#> [1] "tbl_df"     "tbl"        "data.frame"

## Read a Parquet file as Table
dc <- read_gesla(
    file = system.file("extdata", "antarctica.parquet", package = "geslaR"),
    as_data_frame = FALSE
)
class(dc)
#> [1] "Table"        "ArrowTabular" "ArrowObject"  "R6"

## Read a Parquet file as data frame
dd <- read_gesla(
    file = system.file("extdata", "antarctica.parquet", package = "geslaR"),
    as_data_frame = TRUE
)
class(dd)
#> [1] "tbl_df"     "tbl"        "data.frame"
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
#> ✔ Filtering data... [24ms]
#> 
#> ℹ Query finished.
#> ✔ Query finished. [18ms]
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
