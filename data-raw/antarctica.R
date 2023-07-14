## Select a small sample of Antarctica data, and create files to use in
## examples, vignettes and tests

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

arrow::write_csv_arrow(db, file = "../data/antarctica.csv")
arrow::write_parquet(db, sink = "../data/antarctica.parquet")

vroom::vroom_write(db, file = "../data/antarctica2.csv", delim = ",")
vroom::vroom_write(db, file = "../data/antarctica.txt")

a <- arrow::read_csv_arrow("../data/antarctica.csv")
b <- arrow::read_csv_arrow("../data/antarctica2.csv")
c <- vroom::vroom("../data/antarctica.csv")
d <- vroom::vroom("../data/antarctica2.csv")

h <- vroom::vroom("../data/antarctica.txt")

## Have to verify why they aren't equal
