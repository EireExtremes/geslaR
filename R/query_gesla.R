##' @title Query the GESLA dataset
##'
##' @description This function will make a query to fetch a subset of
##' the GESLA dataset. At least a country code and one year must be
##' specified. Site names can also be specified, but are optional. By
##' default, the resulting subset will contain only data that were
##' revised and recommended for analysis, by the GESLA group of
##' researchers.
##'
##' @details The country codes must follow the three-letter [ISO 3166-1
##' alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) code.
##' However, note that not all countries are available at the GESLA
##' dataset. If in doubt, please check the GESLA Shiny app interface
##' (geslaR-app) online at <https://bit.ly/geslar-app>, or use the
##' [geslaR::run_gesla_app()] function to open the interface locally.
##'
##' The `use_flag` argument must be `1` or `0`, or `c(0, 1)`. The
##' `use_flag` is a column at the GESLA dataset thet indicates wehter
##' the data should be used for analysis or not. The `1` (default)
##' indicates it should, and `0` the otherwise. In a data analysis
##' scenario, the user must only be interested in using the recommended
##' data, so this argument shouldn't be changed. However, in same cases,
##' one must be interested in the non-recommended data, therefore this
##' option is available. Also, you can specify `c(0, 1)` to fetch all
##' the data (usable and not usable). In any case, the `use_flag` column
##' will always be present, and it can be used for any post-processing.
##' Please, see the [GESLA
##' format](https://gesla787883612.wordpress.com/format/) documentation
##' for more details.
##'
##' The default argument `as_data_frame = FALSE` will result in an
##' object of the `arrow_dplyr_query` class. The advantage is that,
##' regardless of the size of the resulting dataset, the object will be
##' small in (memory) size. Also, as it happens with the Arrow `Table`
##' class, it can be manipulated with `dplyr` verbs. Please, see the
##' documentation at the [Arrow
##' website](https://arrow.apache.org/docs/r/articles/data_wrangling.html).
##'
##' Note that, if the `as_data_frame` argument is set to `TRUE`, the
##' imported R object will vary in size, according to the size of the
##' subset. In many situations, this can take a long time an may even be
##' infeasible, since the object can result in a "larger-than-memory"
##' size, and possibly will make R operations slow or even a session
##' crash. Therefore, we always recommend to start with `as_data_frame =
##' FALSE`, and work with the dataset from there.
##'
##' @param country A character vector specifying the selected countries,
##' using the three-letter [ISO 3166-1
##' alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) code. See
##' Details.
##' @param year A numeric vector specifying the selected years.
##' @param site_name Optional character vector of site names.
##' @param use_flag The default is `1`, which means to use only the data
##' that was revised and usefull for analysis. Can be `0`, to fetch only
##' revised and not recommend for analysis, or `c(0, 1)` to fetch all
##' the data. See Details.
##' @param as_data_frame If `FALSE` (default), the data will be imported
##' as an `arrow_dplyr_query` object. Otherwise, the data will be in a
##' `tbl_df` (`data.frame`) format. See Details.
##'
##' @return An object of class `arrow_dplyr_query` or a `tbl_df`
##' (`data.frame`).
##'
##' @author Fernando Mayer
##'
##' @examples
##' \dontrun{
##' ## Simple query
##' da <- query_gesla(country = "ATA", year = 2018)
##'
##' ## Multiple years
##' da <- query_gesla(country = "ATA", year = c(2018, 2019))
##' da <- query_gesla(country = "ATA", year = 2010:2019)
##' da <- query_gesla(country = "ATA", year = c(2010, 2012, 2014))
##' da |>
##'     count(year) |>
##'     collect()
##'
##' ## Multiple countries
##' da <- query_gesla(country = c("IRL", "ATA", "BRA"), year = 2018)
##' da <- query_gesla(country = c("IRL", "ATA", "BRA"), year = 2010:2019)
##' da |>
##'     count(country, year) |>
##'     collect()
##'
##' ## Specifying a site name. Note that in this particular case,
##' ## "Faraday" data is only available for 2018, so no 2019 data will
##' ## be available
##' da <- query_gesla(country = "ATA", year = c(2018, 2019),
##'     site_name = "Faraday")
##' da |>
##'     count(year) |>
##'     collect()
##' }
##'
##' @importFrom dplyr filter collect
##' @importFrom arrow arrow_with_s3 s3_bucket open_dataset
##' @importFrom cli format_error cli_progress_step cli_alert_info
##'
##' @export
query_gesla <- function(country, year, site_name = NULL, use_flag = 1,
                        as_data_frame = FALSE) {
    if(!arrow_with_s3()) {
        stop(format_error(c("",
            "x" =
                "The current installation of the {.pkg arrow} package does not support an Amazon AWS (S3) connection.",
            "i" = "Please, check if {.fn arrow_with_s3} returns TRUE",
            "i" =
                "See https://arrow.apache.org/docs/3.0/r/index.html for further details."
        )))
    }
    if(missing(country) || missing(year)) {
        stop(format_error(c("",
            "x" = "At least one country and one year must be selected."
        )))
    }
    if(!length(use_flag) %in% c(1, 2) || !any(use_flag %in% c(0, 1))) {
        stop(format_error(c("",
            "x" =
                "{.arg use_flag} must be only 0 or 1, or {.code c(0, 1)}."
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
    ## See https://rlang.r-lib.org/reference/injection-operator.html
    f_daws <- daws |>
        filter(country %in% {{ country }},
            year %in% {{ year }},
            use_flag %in% {{ use_flag }})
    if(!is.null(site_name)) { # nocov start
        f_daws <- f_daws |>
            filter(site_name %in% {{ site_name }})
    } # nocov end
    ## NOTE have to see if this is worthwile, because it will change the
    ## class to the standard Table. However, it taks some time.
    ## f_daws <- f_daws |> compute()
    if(as_data_frame) { # nocov start
        cli_progress_step("Converting to data frame...")
        cli_alert_info("Converting to data frame can take some time and may result in large size objects. Consider using {.arg as_data_frame = FALSE} first.",
                       wrap = TRUE)
        f_daws <- f_daws |> collect()
    } # nocov end
    cli_progress_step("Query finished.")
    return(f_daws)
}
