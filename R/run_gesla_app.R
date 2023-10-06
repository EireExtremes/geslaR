##' @title Run the GESLA Shiny app
##'
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
##' The same application is hosted in an online [server](https://rstudio.maths.nuim.ie:3939/content/3258adf1-efbb-4996-9a8a-08a474639e8b/),
##' with the exact same capabilities. The advantage of using the
##' interface locally is primarily because of its speed. If you don't
##' need the whole GESLA dataset and/or will only use a subset of it, we
##' recommend to use the online interface to filter the desired subset.
##' After that, you can use the [geslaR::read_gesla()] function to
##' import it.
##'
##' @details The geslaR-app Shiny interface relies on a set of packages,
##' defined in the Suggests fiels of the package `DESCRIPTION` file.
##' When called for the first time, the function will check if all the
##' packages are available. If one or more are not installed, a message
##' will show which one of them should be installed. Alternatively, you
##' can install all of them at once by reinstalling the `geslaR` package
##' with `devtools::install_github("EireExtremes/geslaR", dependencies =
##' TRUE)`. In this case, you will need to restart your R session.
##'
##' When downloading the GESLA dataset for the first time, it may take a
##' few minutes, since it depends on your internet connection and on the
##' traffic on an Amazon AWS server. Don't stop the process before it
##' ends completely. Note that this will be needed only the first time.
##' Once the dataset is downloaded, the other time this function is
##' called on the same directory, the interface should open in your
##' browser instantly.
##'
##' @param app_dest The destination directory that will host the app and
##' the database. It will be created if it doesn't exist. By default, it
##' will create a directory called `gesla_app` in the current working
##' directory.
##' @param dest The destination directory that will host the GESLA
##' dataset files. By default, it will create a subdirectory under the
##' directory defined in `app_dest`. It's not recommended to change this
##' argument. If needed, change only the `app_dest` argument.
##' @param overwrite Overwrite the current dataset? If `TRUE` and called
##' on the same directory as the app, it will overwrite (i.e. download
##' again) the whole dataset. This is usually not necessary, unless the
##' dataset has really changed.
##' @param open Should the app open in the default browser? Defaults to
##' `TRUE`.
##'
##' @return The geslaR-app Shiny interface will open in your default
##' browser.
##'
##' @author Fernando Mayer \email{fernando.mayer@mu.ie}
##'
##' @example inst/examples/run_gesla_app-ex.R
##'
##' @importFrom cli format_error cli_alert_info cli_progress_step
##' cli_progress_message
##'
##' @export
run_gesla_app <- function(app_dest = "./gesla_app",
                          dest = paste0(app_dest, "/gesla_dataset"),
                          overwrite = FALSE,
                          open = TRUE) {
    missing_pkgs <- check_suggests()
    if(length(missing_pkgs != 0L)) { # nocov start
        stop(format_error(c("",
            "x" =
                "The following packages are required to run the GESLA app: {missing_pkgs}",
            "i" =
                "Consider installing each one with {.code install.packages('name')}",
            "i" =
                "Or reinstall the {.pkg geslaR} package with {.code remotes::install_github('EireExtremes/geslaR', dependencies = TRUE)}. In this case you will need to restart your R session."))
        ) # nocov end
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
        if(opt == 1L) { # nocov start
            cli_alert_info("Wait while the dataset is downloaded...")
            download_gesla(dest = dest, ask = FALSE,
                messages = FALSE, overwrite = FALSE)
        } else { # nocov end
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
        if(opt == 1L) { # nocov start
            cli_alert_info("Wait while the dataset is downloaded...")
            download_gesla(dest = dest, ask = FALSE,
                messages = FALSE, overwrite = TRUE)
        } else { # nocov end
            stop(format_error(c("",
                "x" = "No data was downloaded",
                "i" =
                    "If you don't want to download the dataset again, use {.arg overwrite = FALSE}"))
            )
        }
    } # nocov start
    fls <- list.files(system.file("shiny", package = "geslaR"))
    for(app_files in fls) {
        if(!file.exists(paste0(app_dest, "/", app_files))) {
            file.copy(system.file("shiny", app_files, package = "geslaR"),
                to = app_dest)
        }
    }
    if(open) {
        cli_alert_info("Running the geslaR-app...") # nocov
        suppressMessages(shiny::runApp(app_dest, quiet = TRUE)) # nocov
    } else {
        cli_alert_info("To open the geslaR-app in your browser, you should run")
        cli_alert_info("{.code shiny::runApp()} in the {.arg app_dest} directory")
    } # nocov end
}
