
test_that("Dataset overwrite prompt works as expected", {
    ## Simulate the situation where the dataset is available and the
    ## user chooses NOT to overwrite it
    app_dest <- tempdir()
    dir.create(paste0(app_dest, "/gesla_dataset"), showWarnings = FALSE)
    ## Use mock for utils::menu to simulate user input
    local_mocked_bindings(menu = function(...) 1L, .package = "utils")
    expect_error(download_gesla(dest = app_dest, overwrite = FALSE),
        "The GESLA dataset is already downloaded")
})


## test_that("Dataset download prompt works as expected when user declines", {
##     ## Simulate the situation where the dataset is NOT available and the
##     ## user chooses NOT to download it
##     app_dest <- tempfile()
##     ## Use mock for utils::menu to simulate user input
##     local_mocked_bindings(menu = function(...) 2L, .package = "utils")
##     expect_error(run_gesla_app(app_dest = app_dest, open = FALSE),
##         "No data was downloaded")
## })



## # Define a test suite for the download_gesla function
## test_that("download_gesla function works correctly", {

##   # Define a temporary directory for testing
##   temp_dir <- tempfile()

##   # Test if the function creates the correct directory
##   test_dest <- file.path(temp_dir, "test_dataset")
##   download_gesla(dest = test_dest, ask = FALSE, messages = FALSE)
##   expect_true(dir.exists(test_dest))

##   # Test if the function asks for confirmation and proceeds accordingly
##   # (Here, we mock user input to choose "No" for the download)
##   local_mocked_bindings(menu = function(...) 2L, .package = "utils")
##   expect_error(download_gesla(dest = temp_dir, ask = TRUE, messages = FALSE))
##   expect_false(dir.exists(test_dest))

##   # Test if the function downloads the files correctly
##   # (Here, we mock the 'copy_files' function to return a successful download)
##   local_mocked_bindings(copy_files = function(...) TRUE,
##       .package = "arrow")
##   download_gesla(dest = temp_dir, ask = FALSE, messages = FALSE)
##   expect_true(dir.exists(test_dest))
##   # Check if the dataset files (5119 parquet files) are downloaded
##   expect_equal(
##       length(list.files(test_dest,
##           pattern = "\\.parquet$", full.names = TRUE)),
##       5119)
## })
