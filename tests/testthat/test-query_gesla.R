test_that("S3 connection is available", {
    expect_no_error({
        query_gesla(country = "ATA", year = 2018)
    })
    expect_true(arrow_with_s3())
})

test_that("country and year are missing", {
    expect_error(query_gesla())
    expect_error(query_gesla(country = "ATA"))
    expect_error(query_gesla(year = 2018))
})

## test_that("S3 connection is available 2", {
##     local_mocked_bindings(arrow_with_s3 = function(...) FALSE,
##         .package = "arrow")
##     expect_error({
##         query_gesla(country = "ATA", year = 2018)
##     })
## })


## ## Helper function to check if two data frames are equal
## assert_data_frame_equal <- function(df1, df2) {
##   expect_equal(identical(df1, df2), TRUE)
## }

## test_that("query_gesla returns expected results", {
##     ## Test Case 1: Basic query with one country and one year
##     da <- query_gesla(country = "ATA", year = 2018)
##     expect_s3_class(da, "arrow_dplyr_query")

##     ## Test Case 2: Query with multiple countries and years
##     da <- query_gesla(country = c("ATA", "IRL"), year = c(2018, 2019))
##     expect_s3_class(da, "arrow_dplyr_query")

##     ## Test Case 3: Query with site_name specified
##     da <- query_gesla(country = "ATA", year = c(2018, 2019),
##         site_name = "Faraday")
##     expect_s3_class(da, "arrow_dplyr_query")

##     ## Test Case 4: Query with use_flag set to 0
##     da <- query_gesla(country = "ATA", year = 2018, use_flag = 0)
##     expect_s3_class(da, "arrow_dplyr_query")

##     ## Test Case 6: Query with use_flag as c(0, 1)
##     da <- query_gesla(country = "ATA", year = 2018, use_flag = c(0, 1))
##     expect_s3_class(da, "arrow_dplyr_query")

##   # Test Case 7: Query with invalid use_flag
##   expect_error(query_gesla(country = "ATA", year = 2019, use_flag = 2))
## })

## # Additional test to check the equality of the result when as_data_frame is TRUE
## test_that("query_gesla returns consistent results with as_data_frame = TRUE", {
##   da_df <- query_gesla(country = "ATA", year = 2019, as_data_frame = TRUE)
##   da_arrow <- query_gesla(country = "ATA", year = 2019, as_data_frame = FALSE) |> collect()

##   assert_data_frame_equal(da_df, da_arrow)
## })
