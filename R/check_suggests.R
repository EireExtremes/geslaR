##' Check for suggests packages
##'
##' Details here.
##' @title Check for suggests
##' @return A character vector
##' @author Fernando Mayer
check_suggests <- function() {
    pkgs <- c("tidyverse", "lubridate", "shiny", "shinyWidgets",
        "leaflet", "patchwork", "shinycssloaders", "shinyalert",
        "leafpop", "plotly", "bslib")
    is_installed <- sapply(pkgs, requireNamespace, quietly = TRUE)
    installed_pkgs <- names(which(is_installed))
    not_installed <- setdiff(pkgs, installed_pkgs)
    return(not_installed)
}
