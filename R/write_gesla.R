##' @title Write a GESLA dataset
##'
##' @description Write a CSV or Parquet file. Given an object `x`, this
##' function will write a file in the appropriate format to store this
##' object in the hard drive, facilitating it's reading in any other
##' session.
##'
##' The only accepted classes of `x` are `ArrowObject` or `data.frame`.
##' If `x` is an `ArrowObject`, then the resulting file will have the
##' `.parquet` extension, in the [Apache
##' Parquet](https://parquet.apache.org) file format. If `x` is a
##' `data.frame`, the file will have a standard `.csv` extension.
##'
##' This function is usefull to save objects created by the
##' `query_gesla()` function, for example. However, it may be used in
##' any case where saving a (possible subset) of the GESLA dataset may
##' be needed.
##'
##' @details We highly recommend to always use the `ArrowObject` class,
##' as it will be much more efficient for dealing with it in R. Also,
##' the resulting file (with `.parquet` extension) from objects of this
##' type will be much smaller than CSV files created from `data.frame`
##' objects.
##'
##' @param x An object of class `ArrowObject` or `data.frame`
##' @param file_name The name of the file to be created. Must be
##' provided without extension, as this will be determined by the class
##' of `x`.
##' @param ... Other arguments from [arrow::write_csv_arrow()], and
##' [arrow::write_parquet()], from the
##' [arrow](https://arrow.apache.org/docs/r/) package.
##'
##' @return A file with extension `.csv`, if `x` is a `data.frame`, or a
##' file with extension `.parquet`, if `x` is an `ArrowObject`
##'
##' @author Fernando Mayer \email{fernando.mayer@mu.ie}
##'
##' @importFrom arrow write_csv_arrow write_parquet
##' @importFrom cli format_error
##'
##' @example inst/examples/write_gesla-ex.R
##'
##' @export
write_gesla <- function(x, file_name = "gesla-data", ...) {
    cls <- class(x)
    ok_cls <- c("ArrowObject", "data.frame")
    otype <- ok_cls[which(ok_cls %in% cls)]
    if(length(otype) == 0L) {
        stop(format_error(c("",
            "x" =
                "'x' must be an object of class {.code ArrowObject} or {.code data.frame}.")))
    }
    switch(
        otype,
        data.frame = write_csv_arrow(x = x,
            sink = paste0(file_name, ".csv"), ...),
        ArrowObject = write_parquet(x = x,
            sink = paste0(file_name, ".parquet"), ...)
    )
}
