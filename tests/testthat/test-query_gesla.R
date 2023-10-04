## test_that("S3 connection is available", {
##     expect_true(arrow_with_s3())
## })

test_that("country missing", {
    expect_error(query_gesla())
    expect_error(query_gesla(year = 2018))
})

test_that("use_flag is correct", {
    expect_error(query_gesla(country = "ATA", year = 2018,
        use_flag = 2))
    expect_error(query_gesla(country = "ATA", year = 2018,
        use_flag = c(0, 1, 2)))
})

## This may take a long time
## test_that("as_data_frame throws message", {
##     expect_message(query_gesla(country = "ATA", year = 2018,
##         as_data_frame = TRUE),
##         "Converting to data frame")
## })
