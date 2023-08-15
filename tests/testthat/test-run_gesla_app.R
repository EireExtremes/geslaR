test_that("Required packages are available", {
    ## Expect all Suggests packages are available
    missing_pkgs <- check_suggests()
    expect_equal(length(missing_pkgs), 0L,
        info = paste("The following required packages are missing:",
            paste(missing_pkgs, collapse = ", ")))
})

## test_that("Dataset download prompt works as expected", {
##     ## Simulate the situation where the dataset is NOT available and the
##     ## user chooses to download it
##     app_dest <- tempfile()
##     ## Use mock for utils::menu to simulate user input
##     local_mocked_bindings(menu = function(...) 1L, .package = "utils")
##     expect_message(run_gesla_app(app_dest = app_dest, open = FALSE),
##         "Wait while the dataset is downloaded...")
## })

test_that("Dataset download prompt works as expected when user declines", {
    ## Simulate the situation where the dataset is NOT available and the
    ## user chooses NOT to download it
    app_dest <- tempfile()
    ## Use mock for utils::menu to simulate user input
    local_mocked_bindings(menu = function(...) 2L, .package = "utils")
    expect_error(run_gesla_app(app_dest = app_dest, open = FALSE),
        "No data was downloaded")
})

test_that("Use overwrite when no dataset is present", {
    ## Simulate the situation where the dataset is NOT available and the
    ## user chooses to overwrite it
    app_dest <- tempfile()
    expect_error(run_gesla_app(app_dest = app_dest, overwrite = TRUE,
        open = FALSE),
        "The GESLA dataset was not found locally")
})

## test_that("Dataset overwrite prompt works as expected", {
##     ## Simulate the situation where the dataset is available and the
##     ## user chooses to overwrite it
##     app_dest <- tempdir()
##     dir.create(paste0(app_dest, "/gesla_dataset"), showWarnings = FALSE)
##     ## Use mock for utils::menu to simulate user input
##     local_mocked_bindings(menu = function(...) 1L, .package = "utils")
##     expect_message(run_gesla_app(app_dest = app_dest, overwrite = TRUE,
##         open = FALSE),
##         "You chose `overwrite = TRUE` to download the dataset again")
## })

test_that("Dataset overwrite prompt works as expected when user declines", {
    ## Simulate the situation where the dataset is available, the user
    ## chooses to overwrite it, but declines
    app_dest <- tempdir()
    dir.create(paste0(app_dest, "/gesla_dataset"), showWarnings = FALSE)
    ## Use mock for utils::menu to simulate user input
    local_mocked_bindings(menu = function(...) 2L, .package = "utils")
    expect_error(run_gesla_app(app_dest = app_dest, overwrite = TRUE,
        open = FALSE),
        "No data was downloaded")
})

## test_that("Message will show when open = FALSE", {
##     ## Simulate the situation where the dataset is available and the
##     ## user chooses not to open the app
##     app_dest <- tempdir()
##     dir.create(paste0(app_dest, "/gesla_dataset"), showWarnings = FALSE)
##     ## Use mock for utils::menu to simulate user input
##     local_mocked_bindings(menu = function(...) 1L, .package = "utils")
##     expect_message(run_gesla_app(app_dest = app_dest, open = FALSE),
##         "To open the geslaR-app in your browser, you should run")
## })
