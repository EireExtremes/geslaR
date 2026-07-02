# Write a GESLA dataset

Write a CSV or Parquet file. Given an object `x`, this function will
write a file in the appropriate format to store this object in the hard
drive, facilitating it's reading in any other session.

The only accepted classes of `x` are `ArrowObject` or `data.frame`. If
`x` is an `ArrowObject`, then the resulting file will have the
`.parquet` extension, in the [Apache
Parquet](https://parquet.apache.org) file format. If `x` is a
`data.frame`, the file will have a standard `.csv` extension.

This function is usefull to save objects created by the
[`query_gesla()`](https://eireextremes.github.io/geslaR/reference/query_gesla.md)
function, for example. However, it may be used in any case where saving
a (possible subset) of the GESLA dataset may be needed.

## Usage

``` r
write_gesla(x, file_name = "gesla-data", ...)
```

## Arguments

- x:

  An object of class `ArrowObject` or `data.frame`

- file_name:

  The name of the file to be created. Must be provided without
  extension, as this will be determined by the class of `x`.

- ...:

  Other arguments from
  [`arrow::write_csv_arrow()`](https://arrow.apache.org/docs/r/reference/write_csv_arrow.html),
  and
  [`arrow::write_parquet()`](https://arrow.apache.org/docs/r/reference/write_parquet.html),
  from the [arrow](https://arrow.apache.org/docs/r/) package.

## Value

A file with extension `.csv`, if `x` is a `data.frame`, or a file with
extension `.parquet`, if `x` is an `ArrowObject`

## Details

We highly recommend to always use the `ArrowObject` class, as it will be
much more efficient for dealing with it in R. Also, the resulting file
(with `.parquet` extension) from objects of this type will be much
smaller than CSV files created from `data.frame` objects.

## Author

Fernando Mayer <fernando.mayer@mu.ie>

## Examples

``` r
##------------------------------------------------------------------
## Import an internal example Parquet file
## Reading file
tmp <- tempdir()
file.copy(system.file(
    "extdata", "ireland.parquet", package = "geslaR"), tmp)
#> [1] TRUE
da <- read_gesla(paste0(tmp, "/ireland.parquet"))
## Generates a subset by filtering
db <- da |>
    filter(day == 1) |>
    collect()
## Save filtered data as file
write_gesla(db, file_name = paste0(tmp, "/gesla-data"))

##------------------------------------------------------------------
## Querying some data
## Make the query
if(interactive()) {
    da <- query_gesla(country = "IRL", year = 2019,
        site_name = "Dublin_Port")
    ## Save the resulting query to file
    write_gesla(da, file_name = paste0(tmp, "/gesla-data"))
}

## Remove files from temporary directory
unlink(paste0(tmp, "/gesla-data.csv"))
unlink(paste0(tmp, "/gesla-data.parquet"))
unlink(paste0(tmp, "/ireland.parquet"))
```
