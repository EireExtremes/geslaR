##' Download GESLA dataset
##'
##' Details of download.
##' @title Download GESLA data
##' @return Parquet files
##' @author Fernando Mayer
##' @importFrom arrow copy_files s3_bucket
##' @importFrom cli cli_alert_info format_error
##' @export
##' @param messages Include informative messages?
##' @param ask Ask for confirmation
##' @param overwrite Overwrite (download again)?
download_gesla <- function(messages = TRUE, ask = TRUE, overwrite = FALSE) {
    gd <- "inst/shiny/gesla_dataset"
    if(!dir.exists(gd)) {
        dir.create(gd)
    } else {
        if(!overwrite) {
            stop(format_error(c("",
                "x" = "The GESLA dataset is already downloaded")))
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
            if(messages) {
                cli_alert_info("Wait while the dataset is downloaded...")
            }
            copy_files(
                from = s3_bucket("gesla-test/parquet_files",
                    region = "eu-west-1",
                    anonymous = TRUE),
                to = gd
            )
        } else {
            unlink(gd, recursive = TRUE)
            stop(format_error(c("",
                "x" = "No data was downloaded"))
            )
        }
    } else {
        if(messages) {
            cli_alert_info("Wait while the dataset is downloaded...")
        }
        copy_files(
            from = s3_bucket("gesla-test/parquet_files",
                region = "eu-west-1",
                anonymous = TRUE),
            to = gd
        )
    }
}
