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
        stop(cli::format_error(c("",
                                 "x" = "'file' must be csv or parquet.")))
    }
    switch(
        ftype,
        csv = read_csv_arrow(file = file,
                             as_data_frame = as_data_frame, ...),
        parquet = read_parquet(file = file,
                               as_data_frame = as_data_frame, ...)
    )
}

dg <- read_gesla("antarctica.txt", as_data_frame = TRUE)
class(dg)
str(dg)

x <- c("antarctica.csv", "antarctica.parquet")

grep("csv$", x, value = TRUE)

(ft <- unlist(strsplit(x[1], split = "\\."))[2])

y <- c("csv", "parquet")

!ft %in% y

##======================================================================
## Importing GESLA data from the Amazon S3 bucket

if(!dir.exists("parquet_files")) {
    copy_files(
        from = s3_bucket("gesla-dataset",
                         anonymous = TRUE),
        to = "."
    )
}

path <- "parquet_files/"
da <- open_dataset(path, format = "parquet")

da <- open_dataset(s3_bucket("gesla-dataset", anonymous = TRUE))


aws_path <- s3_bucket("gesla-dataset/parquet_files",
                      region = "eu-west-1",
                      anonymous = TRUE)
daws <- open_dataset(aws_path, format = "parquet")
daws

ff <- daws |>
    filter(country %in% "IRL", year %in% 2020)
names(ff)

class(ff)

ff |>
    summarise(m = mean(sea_level)) |>
    collect()

ff2 <- ff |>
    collect()
str(ff2)

query_gesla <- function(country, year, as_data_frame = FALSE) {
    if(!arrow_with_s3()) {
        stop("The current installation of the 'arrow' package does not support an Amazon AWS (S3) connection. Please, see https://arrow.apache.org/docs/3.0/r/index.html for further details.")
    }
    aws_path <- s3_bucket("gesla-dataset/parquet_files",
                          region = "eu-west-1",
                          anonymous = TRUE)
    daws <- open_dataset(aws_path, format = "parquet")
    f_daws <- daws |>
        filter(country %in% !!country, year %in% !!year)
    if(as_data_frame) {
        f_daws <- f_daws |> collect()
    }
    return(f_daws)
}

dq <- query_gesla(country = "IRL", year = 2020)
dq
dq |> dim()


##======================================================================
## Testing query_gesla

da <- query_gesla(country = "ATA", year = 2019, as_data_frame = TRUE)
str(da)
names(da)
da |> dim()
da |>
    count(use_flag)

da <- query_gesla(country = "ATA", year = c(2018, 2019),
    site_name = "Faraday")

da |>
    count(site_name) |>
    collect()

my_mean <- function(data, var) {
    with(data, mean({{ var }}))
}

my_mean(mtcars, cyl)

mm <- function(carb, am = 1, cyl = NULL) {
    da <- mtcars
    db <- da |>
        filter(
            .data$carb %in% .env$carb,
            .data$am == .env$am,
            .data$cyl %in% .env$cyl
        )
    return(db)
}

table(mtcars$carb)
table(mtcars$am)
table(mtcars$cyl)
mm(carb = c(1, 8))
mm(carb = c(1, 8), am = 1)
mm(carb = c(1, 8), am = 0)

xx <- function(carb = NULL, cyl = NULL) {
    da <- mtcars
    ## is.null({{ carb }})
    da |>
        filter(case_when(
            !is.null({{ carb }}) ~ carb %in% {{ carb }},
            !is.null({{ cyl }}) ~ cyl %in% {{ cyl }}
        ))
}

xx <- function(carb = NULL, cyl = NULL) {
    da <- mtcars
    ## is.null({{ carb }})
    da |>
        filter(
            case_when(!is.null({{ carb }}) ~ carb %in% {{ carb }}),
            case_when(!is.null({{ cyl }}) ~ cyl %in% {{ cyl }})
        )
}

xx()
xx(carb = 1)
xx(carb = c(1, 8))
xx(carb = c(1, 8), cyl = 4)


mm <- function(carb, am = 1, cyl = NULL) {
    da <- mtcars
    db <- da |>
        filter(
            .data$carb %in% .env$carb,
            .data$am == .env$am,
            case_when(!is.null({{ cyl }}) ~ .data$cyl %in% .env$cyl)
        )
    return(db)
}

mm(carb = c(1, 8))
mm(carb = c(1, 8), am = 1)
mm(carb = c(1, 8), am = 0)
mm(carb = c(1, 8), am = 0, cyl = 4)

mm <- function(carb, am = 1, cyl = NULL) {
    da <- mtcars
    db <- da |>
        filter(.data$carb %in% .env$carb,
            .data$am == .env$am)
    if(!is.null(cyl)) {
        db <- db |>
            filter(.data$cyl %in% .env$cyl)
    }
    return(db)
}

mm(carb = c(1, 8))
mm(carb = c(1, 8), am = 1)
mm(carb = c(1, 8), am = 0)
mm(carb = c(1, 8), am = 0, cyl = 4)