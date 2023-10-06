##------------------------------------------------------------------
## Import an internal example Parquet file
## Reading file
tmp <- tempdir()
file.copy(system.file(
    "extdata", "ireland.parquet", package = "geslaR"), tmp)
da <- read_gesla(paste0(tmp, "/ireland.parquet"))
## Generates a subset by filtering
db <- da |>
    filter(day == 1) |>
    collect()
## Save filtered data as file
write_gesla(db, file_name = paste0(tmp, "/gesla-data"))

##------------------------------------------------------------------
## Querying some data
## Make the query
if(interactive()) {
    da <- query_gesla(country = "IRL", year = 2019,
        site_name = "Dublin_Port")
    ## Save the resulting query to file
    write_gesla(da, file_name = paste0(tmp, "/gesla-data"))
}

## Remove files from temporary directory
unlink(paste0(tmp, "/gesla-data.csv"))
unlink(paste0(tmp, "/gesla-data.parquet"))
unlink(paste0(tmp, "/ireland.parquet"))
