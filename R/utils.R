check_suggests <- function() {
    ## Check if and which suggested packages are installed
    ## The list of pkgs here are exclusively for the app
    pkgs <- c("tidyverse", "lubridate", "shiny", "shinyWidgets",
        "leaflet", "patchwork", "shinycssloaders", "shinyalert",
        "leafpop", "plotly", "bslib", "DT")
    is_installed <- sapply(pkgs, requireNamespace, quietly = TRUE)
    installed_pkgs <- names(which(is_installed))
    not_installed <- setdiff(pkgs, installed_pkgs)
    return(not_installed)
}
