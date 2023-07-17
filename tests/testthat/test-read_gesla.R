test_that("Other file formats", {
    expect_error({
        read_gesla(system.file("extdata", "antarctica.txt", package="geslaR"))
    })
})
