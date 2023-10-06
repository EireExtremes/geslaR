##' @title Read a GESLA dataset
##'
##' @description Read a CSV or Parquet file, as exported from the GESLA
##' Shiny app interface (geslaR-app). A "GESLA dataset file" is a subset
##' of the GESLA dataset, fetched from the geslaR-app. When using that
##' app, you can choose to download the selected subset in CSV or
##' Parquet file formats. Whichever option is chosen this function will
##' automatically identify the file type and use the appropriate
##' functions to import the dataset to R.
##'
##' This function can be used for exported files from the online
##' interface (hosted in this
##' [server](https://rstudio.maths.nuim.ie:3939/content/3258adf1-efbb-4996-9a8a-08a474639e8b/))
##' or from a local interface, as when using the
##' [geslaR::run_gesla_app()] function.
##'
##' @details We highly recommend to export subsets of the GESLA dataset
##' from the geslaR-app in the Parquet file format. This format has a
##' much smaller file size when comparred to the CSV format.
##'
##' In any case, the only difference between CSV and Parquet files will
##' be the file size. However, when importing these data to R, both
##' file types have the option to be imported as an Arrow `Table`
##' format, which is the default (argument `as_data_frame = FALSE`).
##' This way, the object created in R will have a very small size,
##' independent of how big the file size is. To deal with this type of
##' object, you can use `dplyr` verbs, in the same way as a normal
##' `data.frame` (or `tbl_df`). Some examples can be found in the [Arrow
##' documentation](https://arrow.apache.org/docs/r/articles/data_wrangling.html).
##'
##' If the `as_data_frame` argument is set to `TRUE`, the imported R
##' object will vary in size, according to the size of the dataset, and
##' regardless of the file type. In many situations, this can be
##' infeasible, since the object can result in a "larger-than-memory"
##' size, and possibly will make R operations slow or even a session
##' crash. Therefore, we always recommend to start with `as_data_frame =
##' FALSE`, and work with the dataset from there.
##'
##' See **Examples** below.
##'
##' @param file The file name (must end in `.csv` or `.parquet` only)
##' @param as_data_frame If `FALSE` (default), the data will be imported
##' as an Arrow `Table` format. Otherwise, the data will be in a
##' `tbl_df` (`data.frame`) format. See Details.
##' @param ... Other arguments from [arrow::read_csv_arrow()], and
##' [arrow::read_parquet()], from the
##' [arrow](https://arrow.apache.org/docs/r/) package.
##'
##' @return An Arrow `Table` object, or a `tbl_df` (`data.frame`)
##'
##' @author Fernando Mayer \email{fernando.mayer@mu.ie}
##'
##' @example inst/examples/read_gesla-ex.R
##'
##' @importFrom arrow read_csv_arrow read_parquet
##' @importFrom cli format_error
##'
##' @export
read_gesla <- function(file, as_data_frame = FALSE, ...) {
    ftype <- unlist(strsplit(file, split = "\\."))[2]
    if(!ftype %in% c("csv", "parquet")) {
        stop(format_error(c("",
            "x" = "'file' must be csv or parquet.")))
    }
    switch(
        ftype,
        csv = read_csv_arrow(file = file,
            as_data_frame = as_data_frame, ...),
        parquet = read_parquet(file = file,
            as_data_frame = as_data_frame, ...)
    )
}
