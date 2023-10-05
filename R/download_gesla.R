##' @title Download the GESLA dataset
##'
##' @description This function will download the entire GESLA dataset to
##' the specified folder. Note that the full dataset is about 7GB in
##' size, so the total download time may take a few minutes, as it will
##' depend on internet connection. If you don't need the whole dataset,
##' you can use the [geslaR::query_gesla()] function, to directly import
##' a subset of it.
##'
##' @details This function should only be usefull if you want to deal
##' with all the files from the GESLA dataset. If you need only a
##' subset, you can use the [geslaR::query_gesla()] function, or the
##' GESLA Shiny app interface, from the [geslaR::run_gesla_app()]
##' function.
##'
##' @param dest The directory to download the files to. If the directory
##' doesn't exist, it will be created. Defaults to a folder called
##' `gesla_dataset` in the current working directory.
##' @param ask Ask for confirmation before downloading? Defaults to
##' `TRUE`.
##' @param messages Show informative messages? Defaults to `TRUE`.
##' @param overwrite Overwrite the whole dataset (i.e. download again)?
##' Defaults to `FALSE`. Note that, if `TRUE`, it will only overwrite if
##' the function is called in the same directory where `dest` is.
##'
##' @return The whole GESLA dataset, consisting of 5119 files (with
##' `.parquet` extension). It should have approximately 7GB in size.
##'
##' @author Fernando Mayer \email{fernando.mayer@mu.ie}
##'
##' @example inst/examples/download_gesla-ex.R
##'
##' @importFrom arrow copy_files s3_bucket
##' @importFrom cli cli_alert_info format_error
##'
##' @export
download_gesla <- function(dest = "./gesla_dataset", ask = TRUE,
                           messages = TRUE, overwrite = FALSE) {
    if(!dir.exists(dest) && overwrite) {
        stop(format_error(c("",
            "x" = "No dataset found in {.path {dest}} to overwrite",
            "i" =
                "Use {.code overwrite = FALSE} to download the dataset first")))
    }
    if(!dir.exists(dest)) {
        dir.create(dest, recursive = TRUE)
    } else {
        if(!overwrite) {
            stop(format_error(c("",
                "x" = "The GESLA dataset is already downloaded",
                "i" = "Use {.code overwrite = TRUE} to download it again")))
        }
    }
    if(ask) {
        if(messages) {
            cli_alert_info(
                "The total size of the dataset is about 7GB, and the download time will depend on your internet connection",
                wrap = TRUE)
        }
        opt <- utils::menu(c("Yes", "No"),
            title = "Do you want to download the whole dataset?")
        if(opt == 1L) {
            if(messages) { # nocov start
                cli_alert_info("Wait while the dataset is downloaded...") # nocov
            }
            copy_files(
                from = s3_bucket("gesla-dataset/parquet_files",
                    region = "eu-west-1",
                    anonymous = TRUE),
                to = dest
            )
            if(messages) {
                cli_alert_info("Dataset downloaded to {.path {dest}}") # nocov
            } # nocov end
        } else {
            unlink(dest, recursive = TRUE)
            stop(format_error(c("",
                "x" = "No data was downloaded"))
            )
        }
    } else { # nocov start
        if(messages) {
            cli_alert_info("Wait while the dataset is downloaded...") # nocov
        }
        copy_files(
            from = s3_bucket("gesla-dataset/parquet_files",
                region = "eu-west-1",
                anonymous = TRUE),
            to = dest
        )
        if(messages) {
            cli_alert_info("Dataset downloaded to {.path {dest}}") # nocov
        }
    } # nocov end
}
