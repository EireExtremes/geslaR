##' Read a csv or parquet file, as exported from the geslaR web
##' interface
##'
##' The read_gesla function will automatically identify the file type
##' (csv or parquet) and use the appropriate functions to read an
##' exported Gesla dataset.
##' @title Read a GESLA dataset
##' @param file The file name (must be csv or parquet only)
##' @param as_data_frame If FALSE (default), the data will be imported
##' as an Arrow Table format. Otherwise, the data will be in a
##' data.frame (tibble) format. See Details.
##' @param ... Other arguments from [arrow::read_csv_arrow()], and
##' [arrow::read_parquet()], from the arrow package.
##' @return An Arrow Table object, or a data.frame (tibble)
##' @author Fernando Mayer
##' @importFrom arrow read_csv_arrow read_parquet
##' @export
read_gesla <- function(file, as_data_frame = FALSE, ...) {
    ftype <- unlist(strsplit(file, split = "\\."))[2]
    if(!ftype %in% c("csv", "parquet")) {
        stop("'file' must be csv or parquet.")
    }
    switch(
        ftype,
        csv = read_csv_arrow(file = file,
                             as_data_frame = as_data_frame, ...),
        parquet = read_parquet(file = file,
                               as_data_frame = as_data_frame, ...)
    )
}
