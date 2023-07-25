test_that("Reads Parquet file as Arrow Table", {
    da <- read_gesla(test_path("testdata", "antarctica.parquet"))
    expect_s3_class(da, "Table")
})

test_that("Reads Parquet file as tbl_df", {
    da <- read_gesla(
        test_path("testdata", "antarctica.parquet"),
        as_data_frame = TRUE
    )
    expect_s3_class(da, "tbl_df")
})

test_that("Reads CSV file as Arrow Table", {
    da <- read_gesla(test_path("testdata", "antarctica.csv"))
    expect_s3_class(da, "Table")
})

test_that("Reads CSV file as tbl_df", {
    da <- read_gesla(
        test_path("testdata", "antarctica.csv"),
        as_data_frame = TRUE
    )
    expect_s3_class(da, "tbl_df")
})

test_that("Reads CSV file as tbl_df", {
    da <- read_gesla(
        test_path("testdata", "antarctica.csv"),
        as_data_frame = TRUE
    )
    expect_s3_class(da, "tbl_df")
})

test_that("Fails to read other file formats", {
    expect_error({
        read_gesla(
            test_path("testdata", "antarctica.txt")
        )
    })
})
