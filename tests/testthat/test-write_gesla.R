test_that("write_gesla writes data.frame to CSV", {
    ## Create a sample data.frame
    df <- tibble(
        Name = c("Alice", "Bob", "Charlie"),
        Age = c(25L, 30L, 35L)
    )

    ## Write the data.frame to a CSV file
    write_gesla(df, "test_csv")

    ## Check if the CSV file was created
    file_path <- "test_csv.csv"
    expect_true(file.exists(file_path))

    ## Read the CSV file and check its content
    read_df <- read_gesla(file_path, as_data_frame = TRUE)
    expect_identical(df, read_df)

    ## Clean up: Delete the created CSV file
    file.remove(file_path)
})

test_that("write_gesla writes ArrowObject to Parquet", {
    library(arrow)

    ## Create a sample ArrowObject
    arrow_df <- arrow_table(
        Name = c("Alice", "Bob", "Charlie"),
        Age = c(25, 30, 35)
    )

    ## Write the ArrowObject to a Parquet file
    write_gesla(arrow_df, "test_parquet")

    ## Check if the Parquet file was created
    file_path <- "test_parquet.parquet"
    expect_true(file.exists(file_path))

    ## Read the Parquet file and check its content
    ## read_df <- read_gesla(file_path)
    ## expect_equal(arrow_df, read_df)

    ## Clean up: Delete the created Parquet file
    file.remove(file_path)
})

## Test for an invalid input (not data.frame or ArrowObject)
test_that("write_gesla handles invalid input", {
    invalid_input <- c(1, 2, 3)

    ## Expect an error to be thrown when writing the invalid input
    expect_error(write_gesla(invalid_input, "invalid_file"))
})
