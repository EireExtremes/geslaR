if(interactive()) {
    ##------------------------------------------------------------------
    ## This will create a directory called `geslaR_app` on the current
    ## working directory and import the necessary files for the app.
    ## Also, it will create a subdirectory `gesla_app/gesla_dataset`,
    ## where the dataset will be downloaded.
    tmp <- paste0(tempdir(), "/gesla_app")
    run_gesla_app(app_dest = tmp)

    ##------------------------------------------------------------------
    ## This function call on the same directory where the app is hosted,
    ## will overwrite the whole dataset (i.e. it will be downloaded
    ## again). A prompt for confirmation will be issued.
    run_gesla_app(app_dest = tmp, overwrite = TRUE)

    ## Remove files from temporary directory
    unlink(tmp, recursive = TRUE)
}
