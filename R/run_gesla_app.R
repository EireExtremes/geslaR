##' Run the Gesla Shiny app locally.
##'
##' Write details here.
##' @title Run the Gesla app
##' @return A shiny interface.
##' @author Fernando Mayer
##' @importFrom cli format_error cli_alert_info cli_progress_step
##' cli_progress_bar cli_progress_update cli_progress_done
##' @param overwrite Overwrite the current dataset?
##' @export
run_gesla_app <- function(overwrite = FALSE) {
  if(!requireNamespace("shiny", quietly = TRUE)) {
    stop(format_error(c("",
      "x" = "This function requires the {.pkg shiny} package",
      "i" = "Consider installing it with {.code install.packages('shiny')}")))
  }
  sf <- system.file("shiny", "gesla_dataset", package = "geslaR")
  if(!dir.exists(sf)) {
    dir.create(sf)
  }
  if(overwrite) {
    unlink(sf, recursive = TRUE)
  }
  cli_alert_info(
    "To use the app, the whole GESLA dataset must be downloaded locally",
    wrap = TRUE)
  cli_alert_info(
    "The total size of the dataset is about 7GB, and the download time will depend on your internet connection",
    wrap = TRUE)
  opt <- utils::menu(c("Yes", "No"), title = "Do you wish to continue?")
  if(opt == 1L) {
    cli_progress_bar("Wait while the dataset is downloaded...",
      total = 6)
    cli_progress_update()
    shiny::runApp(system.file("shiny", package = "geslaR"))
    cli_progress_done()
  } else {
    cli_alert_info("No data downloaded.")
  }
}
