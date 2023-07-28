test_that("Use overwrite when no dataset is present", {
    app_dest <- tempfile()
    expect_error(download_gesla(dest = app_dest, overwrite = TRUE))
})

test_that("Use overwrite = FALSE whan the dataset is present", {
    app_dest <- tempdir()
    dir.create(paste0(app_dest, "/gesla_dataset"), showWarnings = FALSE)
    ## Use mock for utils::menu to simulate user input
    local_mocked_bindings(menu = function(...) 1L, .package = "utils")
    expect_error(download_gesla(dest = app_dest, overwrite = FALSE),
        "The GESLA dataset is already downloaded")
})

test_that("Dataset download prompt works as expected when user declines", {
    app_dest <- tempfile()
    ## Use mock for utils::menu to simulate user input
    local_mocked_bindings(menu = function(...) 2L, .package = "utils")
    expect_error(download_gesla(dest = app_dest),
        "No data was downloaded")
})
