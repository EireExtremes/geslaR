## Select a small sample of Ireland data, and create files to use in
## examples, vignettes and tests

library(dplyr)

da <- query_gesla(country = "IRL", year = 2019)
da
class(da)

da |>
    count(month) |>
    collect()

## Select only the first month, to keep file sizes small
set.seed(1)
db <- da |>
    slice_sample(n = 100) |>
    collect()

str(db)

##----------------------------------------------------------------------
## Slightly "bigger" files go to inst/extdata to be used in examples and
## vignettes
arrow::write_csv_arrow(db, file = "inst/extdata/ireland.csv")
arrow::write_parquet(db, sink = "inst/extdata/ireland.parquet")
vroom::vroom_write(db, file = "inst/extdata/ireland2.csv", delim = ",")
vroom::vroom_write(db, file = "inst/extdata/ireland.txt")

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
    file = "tests/testthat/testdata/ireland.csv")
arrow::write_parquet(dc,
    sink = "tests/testthat/testdata/ireland.parquet")
vroom::vroom_write(dc,
    file = "tests/testthat/testdata/ireland2.csv", delim = ",")
vroom::vroom_write(dc,
    file = "tests/testthat/testdata/ireland.txt")


##======================================================================
## TODO
a <- arrow::read_csv_arrow("../data/ireland.csv")
b <- arrow::read_csv_arrow("../data/ireland2.csv")
c <- vroom::vroom("../data/ireland.csv")
d <- vroom::vroom("../data/ireland2.csv")

h <- vroom::vroom("../data/ireland.txt")

## Have to verify why they aren't equal
##======================================================================
