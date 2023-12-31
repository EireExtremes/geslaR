% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_gesla.R
\name{download_gesla}
\alias{download_gesla}
\title{Download the GESLA dataset}
\usage{
download_gesla(
  dest = "./gesla_dataset",
  ask = TRUE,
  messages = TRUE,
  overwrite = FALSE
)
}
\arguments{
\item{dest}{The directory to download the files to. If the directory
doesn't exist, it will be created. Defaults to a folder called
\code{gesla_dataset} in the current working directory.}

\item{ask}{Ask for confirmation before downloading? Defaults to
\code{TRUE}.}

\item{messages}{Show informative messages? Defaults to \code{TRUE}.}

\item{overwrite}{Overwrite the whole dataset (i.e. download again)?
Defaults to \code{FALSE}. Note that, if \code{TRUE}, it will only overwrite if
the function is called in the same directory where \code{dest} is.}
}
\value{
The whole GESLA dataset, consisting of 5119 files (with
\code{.parquet} extension). It should have approximately 7GB in size.
}
\description{
This function will download the entire GESLA dataset to
the specified folder. Note that the full dataset is about 7GB in
size, so the total download time may take a few minutes, as it will
depend on internet connection. If you don't need the whole dataset,
you can use the \code{\link[=query_gesla]{query_gesla()}} function, to directly import
a subset of it.
}
\details{
This function should only be usefull if you want to deal
with all the files from the GESLA dataset. If you need only a
subset, you can use the \code{\link[=query_gesla]{query_gesla()}} function, or the
GESLA Shiny app interface, from the \code{\link[=run_gesla_app]{run_gesla_app()}}
function.
}
\examples{
if(interactive()) {
    ## Create a temporary directory for downloaded files
    dest <- paste0(tempdir(), "/gesla_dataset")
    ## Download to 'gesla_dataset' folder in the temporary directory
    download_gesla(dest = dest)
    ## To overwrite (download again) on the same location
    download_gesla(dest = dest, overwrite = TRUE)
    ## Don't ask for confirmation before download
    download_gesla(dest = dest, overwrite = TRUE, ask = FALSE)
    ## Don't show informative messages
    download_gesla(dest = dest, overwrite = TRUE, messages = FALSE)
    ## Don't ask for confirmation neither show messages
    download_gesla(dest = dest, overwrite = TRUE,
        ask = FALSE, messages = FALSE)
    ## Remove temporary directory
    unlink(dest, recursive = TRUE)
}
}
\author{
Fernando Mayer \email{fernando.mayer@mu.ie}
}
