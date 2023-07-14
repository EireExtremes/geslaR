##' Query for a subset of the GESLA dataset.
##'
##' Make a query for the GESLA dataset, by selecting one or more
##' countries and one or more years.
##' @title Query the GESLA dataset
##' @param country A character vector specifying the selected countries,
##' using the three-letter [ISO 3166-1
##' alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) code.
##' @param year A numeric vector specifying the selected years.
##' @param as_data_frame Should the query return a data frame (tibble)?
##' Defaults to FALSE. By default it will return an object of the
##' `arrow_dplyr_query`.
##' @return An object of class `arrow_dplyr_query` or a data frame.
##' @author Fernando Mayer
##' @importFrom dplyr filter collect
##' @importFrom arrow arrow_with_s3 s3_bucket open_dataset
##' @importFrom cli format_error
##' @export
query_gesla <- function(country, year, as_data_frame = FALSE) {
    if(!arrow_with_s3()) {
        stop(format_error(c("",
            "x" =
                "The current installation of the 'arrow' package does not support an Amazon AWS (S3) connection.",
            "i" = "Please, check if {.fn arrow_with_s3} returns TRUE",
            "i" =
                "See https://arrow.apache.org/docs/3.0/r/index.html for further details."
        )))
    }
    aws_path <- s3_bucket("gesla-dataset/parquet_files",
                          region = "eu-west-1",
                          anonymous = TRUE)
    daws <- open_dataset(aws_path, format = "parquet")
    f_daws <- daws |>
        filter(country %in% !!country, year %in% !!year)
    if(as_data_frame) {
        f_daws <- f_daws |> collect()
    }
    return(f_daws)
}
