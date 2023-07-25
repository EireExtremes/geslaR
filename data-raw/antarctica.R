## Select a small sample of Antarctica data, and create files to use in
## examples, vignettes and tests

library(dplyr)

da <- query_gesla(country = "ATA", year = 2019)
da
class(da)

da |>
    count(month) |>
    collect()

## Select only the first month, to keep file sizes small
db <- da |>
    filter(month == 1) |>
    collect()

str(db)

##----------------------------------------------------------------------
## Slightly "bigger" files go to inst/extdata to be used in examples and
## vignettes
arrow::write_csv_arrow(db, file = "inst/extdata/antarctica.csv")
arrow::write_parquet(db, sink = "inst/extdata/antarctica.parquet")
vroom::vroom_write(db, file = "inst/extdata/antarctica2.csv", delim = ",")
vroom::vroom_write(db, file = "inst/extdata/antarctica.txt")

##----------------------------------------------------------------------
## This files are the same, but smaller. This was needed in order to
## make tests under tests/testthat to work properly, since calling
## system.file(...) in test files doesn't work, as the tests are run in
## different (clean) environments.

## Select only the first few lines, to keep file sizes even smaller
dc <- db |>
    slice_head(n = 5) |>
    collect()

str(dc)

## These goes to tests/testthat/testdata
arrow::write_csv_arrow(dc,
    file = "tests/testthat/testdata/antarctica.csv")
arrow::write_parquet(dc,
    sink = "tests/testthat/testdata/antarctica.parquet")
vroom::vroom_write(dc,
    file = "tests/testthat/testdata/antarctica2.csv", delim = ",")
vroom::vroom_write(dc,
    file = "tests/testthat/testdata/antarctica.txt")


##======================================================================
## TODO
a <- arrow::read_csv_arrow("../data/antarctica.csv")
b <- arrow::read_csv_arrow("../data/antarctica2.csv")
c <- vroom::vroom("../data/antarctica.csv")
d <- vroom::vroom("../data/antarctica2.csv")

h <- vroom::vroom("../data/antarctica.txt")

## Have to verify why they aren't equal
##======================================================================
