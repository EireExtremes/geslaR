##' @title Run the GESLA Shiny app.
##' @description Run the GESLA Shiny app (geslaR-app) locally. The first
##' time this function is called, it will check if the GESLA dataset is
##' present. If not, it will prompt to download it or not. Please note
##' that the entire GESLA dataset is about 7GB in size, so make sure
##' there is enough space for it. The Shiny app will only work with the
##' entire dataset downloaded locally.
##'
##' Note, however, that the dataset needs to be downloaded only once, so
##' the next time this function is called, the app will open instantly.
##'
##' The same application is hosted online at <https://bit.ly/gesla-app>,
##' with the exact same capabilities. The advantage of using the
##' interface locally is primarily because of its speed. If you don't
##' need the whole GESLA dataset and/or will only use a subset of it, we
##' recommend to use the online interface to filter the desired subset.
##' After that, you can use the [geslaR::read_gesla()] function to
##' import it.
##' @details Write details here.
##' @param app_dest The app folder
##' @param dest The dataset folder
##' @param overwrite Overwrite?
##' @return A shiny interface.
##' @author Fernando Mayer
##' @examples
##' \dontrun{
##' ## This will create a directory called `gesla_app` on the current
##' working directory and import the necessary files for the app. Also,
##' it will create a subdirectory `gesla_app/gesla_dataset`, where the
##' dataset will be downloaded.
##' run_gesla_app()
##'
##' ## This will do the same, but everything will be in the specified path
##' run_gesla_app(app_dest = "~/my_gesla_app")
##'
##' ## This function call on the same directory where the app is hosted,
##' will overwrite the whole dataset (i.e. it will be downloaded again).
##' A prompt for confirmation will be issued.
##' run_gesla_app(overwrite = TRUE)
##' }
##' @importFrom cli format_error cli_alert_info cli_progress_step
##' cli_progress_message
##' @export
run_gesla_app <- function(app_dest = "./gesla_app",
                          dest = paste0(app_dest, "/gesla_dataset"),
                          overwrite = FALSE) {
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
    if(!dir.exists(dest) && overwrite) {
        stop(format_error(c("",
            "x" = "The GESLA dataset was not found locally",
            "i" =
                "The argument {.arg overwrite = TRUE} has no effect if the dataset is not available",
            "i" =
                "Use {.arg overwrite = FALSE} to download the dataset first"))
        )
    }
    if(!dir.exists(dest) && !overwrite) {
        cli_alert_info(
            "To use the app, the whole GESLA dataset must be downloaded locally",
            wrap = TRUE)
        cli_alert_info(
            "The total size of the dataset is about 7GB, and the download time will depend on your internet connection",
            wrap = TRUE)
        opt <- utils::menu(c("Yes", "No"), title = "Do you wish to continue?")
        if(opt == 1L) {
            cli_alert_info("Wait while the dataset is downloaded...")
            download_gesla(dest = dest, ask = FALSE,
                messages = FALSE, overwrite = FALSE)
        } else {
            stop(format_error(c("",
                "x" = "No data was downloaded",
                "i" =
                    "The app will only work with the dataset downloaded locally"))
            )
        }
    }
    if(dir.exists(dest) && overwrite) {
        cli_alert_info(
            "You chose {.arg overwrite = TRUE} to download the dataset again",
            wrap = TRUE)
        cli_alert_info(
            "The total size of the dataset is about 7GB, and the download time will depend on your internet connection",
            wrap = TRUE)
        opt <- utils::menu(c("Yes", "No"), title = "Do you wish to continue?")
        if(opt == 1L) {
            cli_alert_info("Wait while the dataset is downloaded...")
            download_gesla(dest = dest, ask = FALSE,
                messages = FALSE, overwrite = TRUE)
        } else {
            stop(format_error(c("",
                "x" = "No data was downloaded",
                "i" =
                    "If you don't want to download the dataset again, use {.arg overwrite = FALSE}"))
            )
        }
    }
    cli_alert_info("Running app...")
    fls <- list.files(system.file("shiny", package = "geslaR"))
    for(app_files in fls) {
        if(!file.exists(paste0(app_dest, "/", app_files))) {
            file.copy(system.file("shiny", app_files, package = "geslaR"),
                to = app_dest)
        }
    }
    shiny::runApp(app_dest, quiet = TRUE)
}
