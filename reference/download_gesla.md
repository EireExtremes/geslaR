# Download the GESLA dataset

This function will download the entire GESLA dataset to the specified
folder. Note that the full dataset is about 7GB in size, so the total
download time may take a few minutes, as it will depend on internet
connection. If you don't need the whole dataset, you can use the
[`query_gesla()`](https://eireextremes.github.io/geslaR/reference/query_gesla.md)
function, to directly import a subset of it.

## Usage

``` r
download_gesla(
  dest = "./gesla_dataset",
  ask = TRUE,
  messages = TRUE,
  overwrite = FALSE
)
```

## Arguments

- dest:

  The directory to download the files to. If the directory doesn't
  exist, it will be created. Defaults to a folder called `gesla_dataset`
  in the current working directory.

- ask:

  Ask for confirmation before downloading? Defaults to `TRUE`.

- messages:

  Show informative messages? Defaults to `TRUE`.

- overwrite:

  Overwrite the whole dataset (i.e. download again)? Defaults to
  `FALSE`. Note that, if `TRUE`, it will only overwrite if the function
  is called in the same directory where `dest` is.

## Value

The whole GESLA dataset, consisting of 5119 files (with `.parquet`
extension). It should have approximately 7GB in size.

## Details

This function should only be usefull if you want to deal with all the
files from the GESLA dataset. If you need only a subset, you can use the
[`query_gesla()`](https://eireextremes.github.io/geslaR/reference/query_gesla.md)
function, or the GESLA Shiny app interface, from the
[`run_gesla_app()`](https://eireextremes.github.io/geslaR/reference/run_gesla_app.md)
function.

## Author

Fernando Mayer <fernando.mayer@ufpr.br>

## Examples

``` r
if(interactive()) {
    ## Create a temporary directory for downloaded files
    dest <- paste0(tempdir(), "/gesla_dataset")
    ## Download to 'gesla_dataset' folder in the temporary directory
    download_gesla(dest = dest)
    ## To overwrite (download again) on the same location
    download_gesla(dest = dest, overwrite = TRUE)
    ## Don't ask for confirmation before download
    download_gesla(dest = dest, overwrite = TRUE, ask = FALSE)
    ## Don't show informative messages
    download_gesla(dest = dest, overwrite = TRUE, messages = FALSE)
    ## Don't ask for confirmation neither show messages
    download_gesla(dest = dest, overwrite = TRUE,
        ask = FALSE, messages = FALSE)
    ## Remove temporary directory
    unlink(dest, recursive = TRUE)
}
```
