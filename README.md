
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

The **geslaR** package was developed to deal with the
[GESLA](https://gesla787883612.wordpress.com) (Global Extreme Sea Level
Analysis) dataset.

The GESLA (Global Extreme Sea Level Analysis) project aims to provide a
global database of higher-frequency sea-level records for researchers to
study tides, storm surges, extreme sea levels, and related processes.
Three versions of the GESLA dataset are available for download,
including a zip file containing the entire dataset, a CSV file
containing metadata, and a KML file for plotting the location of all
station records in Google Earth. The **geslaR** R package developed here
aims to facilitate the access to the GESLA dataset by providing
functions to download it entirely, or query subsets of it directly into
R, without the need of downloading the full dataset. Also, it provides a
built-in web-application, so that users can apply basic filters to
select the data of interest, generating informative plots, and showing
the selected sites all over the world. Users can download the selected
subset of data in CSV or Parquet file formats, with the latter being
recommended due to its smaller size and the ability to handle it in many
programming languages through the Apache Arrow language for in-memory
analytics. The web interface was developed using the Shiny R package,
with the CSV files from the GESLA dataset converted to the Parquet
format and stored in an Amazon AWS bucket.

To get started with the package, please see the vignette [Dealing with
the GESLA dataset in
R](https://eireextremes.github.io/geslaR/articles/intro-to-geslaR.html),
where you will find a besic introduction to all the functions available
and how to use each one of them. To learn how to use the Apache Arrow
framework to deal with the dataset in R, see the vignette [Introduction
to Apache Arrow
framework](https://eireextremes.github.io/geslaR/articles/intro-to-arrow.html).

## Installation

You can install the latest version of geslaR from
[GitHub](https://github.com/EireExtremes/geslaR) with:

``` r
## install.packages("devtools")
devtools::install_github("EireExtremes/geslaR")
```

To be able to use the built-in web-application, all the package
dependencies should also be installed with:

``` r
devtools::install_github("EireExtremes/geslaR", dependencies = TRUE)
```

## Examples

``` r
library(geslaR)
```

To read files from the GESLA dataset, use the `read_gesla()` function.

``` r
##------------------------------------------------------------------
## Import an internal example Parquet file
tmp <- tempdir()
file.copy(system.file(
    "extdata", "ireland.parquet", package = "geslaR"), tmp)
da <- read_gesla(paste0(tmp, "/ireland.parquet"))
## Check size in memory
object.size(da)

##------------------------------------------------------------------
## Import an internal example CSV file
tmp <- tempdir()
file.copy(system.file(
    "extdata", "ireland.csv", package = "geslaR"), tmp)
da <- read_gesla(paste0(tmp, "/ireland.csv"))
## Check size in memory
object.size(da)

##------------------------------------------------------------------
## Import an internal example Parquet file as data.frame
tmp <- tempdir()
file.copy(system.file(
    "extdata", "ireland.parquet", package = "geslaR"), tmp)
da <- read_gesla(paste0(tmp, "/ireland.parquet"),
    as_data_frame = TRUE)
## Check size in memory
object.size(da)

##------------------------------------------------------------------
## Import an internal example CSV file as data.frame
tmp <- tempdir()
file.copy(system.file(
    "extdata", "ireland.csv", package = "geslaR"), tmp)
da <- read_gesla(paste0(tmp, "/ireland.csv"),
    as_data_frame = TRUE)
## Check size in memory
object.size(da)
```

To make a query to the GESLA dataset and load it directly into R, one
can use the `query_gesla()` function.

``` r
## Query a subset of the GESLA dataset, without the need of downloading
## all the dataset
de <- query_gesla(country = "IRL", year = 2020:2021, as_data_frame = FALSE)
class(de)
```

To download the full dataset locally, use the `download_gesla()`
function.

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

To open the built-in web-application, use the `run_gesla_app()` function
(note that this will need the installation of **geslaR** with all of its
dependencies).

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
