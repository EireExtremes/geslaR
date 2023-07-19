##' Run the Gesla Shiny app locally.
##'
##' Write details here.
##' @title Run the Gesla app
##' @return A shiny interface.
##' @author Fernando Mayer
##' @importFrom cli format_error cli_alert_info cli_progress_step cli_progress_message
##' @export
##' @param overwrite Overwrite?
run_gesla_app <- function(overwrite = FALSE) {
    missing_pkgs <- check_suggests()
    if(length(missing_pkgs != 0L)) {
        stop(format_error(c("",
            "x" =
                "The following packages are required to run the GESLA app: {missing_pkgs}",
            "i" =
                "Consider installing each one with {.code install.packages('name')}",
            "i" =
                "Or reinstall the {.pkg geslaR} package with {.code remotes::install_github('EireExtremes/geslaR', dependencies = TRUE)}. In this case you will need to restart your R session."))
        )
    }
    gd <- "inst/shiny/gesla_dataset"
    if(!dir.exists(gd) && overwrite) {
        stop(format_error(c("",
            "x" = "The GESLA dataset was not found locally",
            "i" =
                "The argument {.arg overwrite = TRUE} has no effect if the dataset is not available",
            "i" =
                "Use {.arg overwrite = FALSE} to download the dataset first"))
        )
    }
    if(!dir.exists(gd) && !overwrite) {
        cli_alert_info(
            "To use the app, the whole GESLA dataset must be downloaded locally",
            wrap = TRUE)
        cli_alert_info(
            "The total size of the dataset is about 7GB, and the download time will depend on your internet connection",
            wrap = TRUE)
        opt <- utils::menu(c("Yes", "No"), title = "Do you wish to continue?")
        if(opt == 1L) {
            cli_alert_info("Wait while the dataset is downloaded...")
            download_gesla(messages = FALSE, ask = FALSE, overwrite = FALSE)
        } else {
            stop(format_error(c("",
                "x" = "No data was downloaded",
                "i" =
                    "The app will only work with the dataset downloaded locally"))
            )
        }
    }
    if(dir.exists(gd) && overwrite) {
        cli_alert_info(
            "You chose {.arg overwrite = TRUE} to download the dataset again",
            wrap = TRUE)
        cli_alert_info(
            "The total size of the dataset is about 7GB, and the download time will depend on your internet connection",
            wrap = TRUE)
        opt <- utils::menu(c("Yes", "No"), title = "Do you wish to continue?")
        if(opt == 1L) {
            cli_alert_info("Wait while the dataset is downloaded...")
            download_gesla(messages = FALSE, ask = FALSE, overwrite = TRUE)
        } else {
            stop(format_error(c("",
                "x" = "No data was downloaded",
                "i" =
                    "If you don't want to download the dataset again, use {.arg overwrite = FALSE}"))
            )
        }
    }
    cli_alert_info("Running app...")
    shiny::runApp(system.file("shiny", package = "geslaR"), quiet = TRUE)
}
