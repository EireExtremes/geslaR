##======================================================================
## Testing environment for functions in the geslaR package
## NOT part of the package itself
## DO NOT rely on the code shown here
##======================================================================

##======================================================================
## Packages
library(dplyr)
library(arrow)

##======================================================================
## Importing CSV and Parquet files

##----------------------------------------------------------------------
## As data frames

dp <- arrow::read_parquet("antarctica.parquet")
str(dp)

dc <- arrow::read_csv_arrow("antarctica.csv")
str(dc)

identical(dp, dc)
all.equal(dp, dc)

attributes(dp$date_time)
attributes(dc$date_time)

## TODO missing tzone when imported from parquet

##----------------------------------------------------------------------
## As Arrow Table

dp2 <- arrow::read_parquet("antarctica.parquet", as_data_frame = FALSE)
str(dp2)
dp2

dc2 <- arrow::read_csv_arrow("antarctica.csv", as_data_frame = FALSE)
str(dc2)
dc2

identical(dp2, dc2)
all.equal(dp2, dc2)

dp2
dc2

dp2 |>
    select(date_time) |>
    collect() |>
    summarise(attr = attributes(date_time)) |>
    as.data.frame()

dc2 |>
    select(date_time) |>
    collect() |>
    summarise(attr = attributes(date_time)) |>
    as.data.frame()

## TODO parquet also misses tzone attribute


read_gesla <- function(file, as_data_frame = FALSE, ...) {
    ftype <- unlist(strsplit(file, split = "\\."))[2]
    if(!ftype %in% c("csv", "parquet")) {
        stop("'file' must be csv or parquet.")
    }
    switch(
        ftype,
        csv = read_csv_arrow(file = file,
                             as_data_frame = as_data_frame, ...),
        parquet = read_parquet(file = file,
                               as_data_frame = as_data_frame, ...)
    )
}

dg <- read_gesla("antarctica.parquet", as_data_frame = TRUE)
class(dg)
str(dg)

x <- c("antarctica.csv", "antarctica.parquet")

grep("csv$", x, value = TRUE)

(ft <- unlist(strsplit(x[1], split = "\\."))[2])

y <- c("csv", "parquet")

!ft %in% y
