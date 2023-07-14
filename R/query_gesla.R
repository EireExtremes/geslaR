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
##' @importFrom cli format_error cli_progress_step cli_alert_info
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
    cli_alert_info("This process can take some time, as it depends on the size of the final dataset, and on internet connection.",
                   wrap = TRUE)
    cli_progress_step("Connecting to the data server...")
    aws_path <- s3_bucket("gesla-dataset/parquet_files",
                          region = "eu-west-1",
                          anonymous = TRUE)
    daws <- open_dataset(aws_path, format = "parquet")
    cli_progress_step("Filtering data...")
    f_daws <- daws |>
        filter(country %in% !!country, year %in% !!year)
    if(as_data_frame) {
        cli_progress_step("Converting to data frame...")
        cli_alert_info("Converting to data frame can take some time and may result in large size objects. Consider using {.arg as_data_frame = FALSE} first.",
                       wrap = TRUE)
        f_daws <- f_daws |> collect()
    }
    cli_progress_step("Query finished.")
    return(f_daws)
}
