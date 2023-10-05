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
