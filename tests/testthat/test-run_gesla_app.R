test_that("Required packages are available", {
    ## Expect all Suggests packages are available
    missing_pkgs <- check_suggests()
    expect_equal(length(missing_pkgs), 0L,
        info = paste("The following required packages are missing:",
            paste(missing_pkgs, collapse = ", ")))
})

test_that("Dataset download prompt works as expected", {
    ## Simulate the situation where the dataset is not available and the
    ## user chooses to download it
    app_dest <- tempfile()
    ## Use mock for utils::menu to simulate user input
    local_mocked_bindings(menu = function(...) 1L, .package = "utils")
    expect_message(run_gesla_app(app_dest = app_dest, open = FALSE),
        "Wait while the dataset is downloaded...")
})

test_that("Dataset download prompt works as expected when user declines", {
    ## Simulate the situation where the dataset is not available and the
    ## user chooses not to download it
    app_dest <- tempfile()
    ## Use mock for utils::menu to simulate user input
    local_mocked_bindings(menu = function(...) 2L, .package = "utils")
    expect_error(run_gesla_app(app_dest = app_dest, open = FALSE),
        "No data was downloaded")
})

test_that("Dataset overwrite prompt works as expected", {
    ## Simulate the situation where the dataset is available and the
    ## user chooses to overwrite it
    app_dest <- tempfile()
    ## dir.create(paste0(app_dest, "/gesla_dataset"))
    ## Use mock for utils::menu to simulate user input
    ## local_mocked_bindings(menu = function(...) 1L, .package = "utils")
    expect_error(run_gesla_app(app_dest = app_dest, overwrite = TRUE,
        open = FALSE),
        "The GESLA dataset was not found locally")
})

test_that("Dataset overwrite prompt works as expected when user declines", {
    # Simulate the situation where the dataset is available
    # and the user chooses not to overwrite it.
    # Set app_dest and dest to a temporary directory
    app_dest <- tempdir()
    dir.create(paste0(app_dest, "/gesla_dataset"))
    # Use mock for utils::menu to simulate user input
    local_mocked_bindings(menu = function(...) 1L, .package = "utils")
    expect_message(run_gesla_app(app_dest = app_dest, overwrite = TRUE,
        open = FALSE),
        "You chose `overwrite = TRUE` to download the dataset again")
})

## test_that("Shiny app runs successfully", {
##   # Simulate the situation where the dataset is available
##   # and the user chooses not to overwrite it.
##   # Set app_dest and dest to a temporary directory
##   app_dest <- tempfile()
##   dest <- tempfile()
##   dir.create(dest)  # Create a mock dataset directory

##   # Use mock for runApp to check if it is called
##   app_was_run <- FALSE
##   with_mock(shiny::runApp = function(...) { app_was_run <<- TRUE }) {
##     run_gesla_app(app_dest = app_dest, dest = dest)
##   }

##   expect_true(app_was_run, info = "The Shiny app was not launched.")
## })
