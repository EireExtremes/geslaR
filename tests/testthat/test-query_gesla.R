test_that("S3 connection is available", {
    expect_no_error({
        query_gesla(country = "IRL", year = 2020, as_data_frame = FALSE)
    })
    expect_true(arrow_with_s3())
})
