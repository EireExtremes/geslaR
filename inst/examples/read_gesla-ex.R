##------------------------------------------------------------------
## Import an internal example Parquet file
tmp <- tempdir()
file.copy(system.file(
    "extdata", "ireland.parquet", package = "geslaR"), tmp)
da <- read_gesla(paste0(tmp, "/ireland.parquet"))
## Check size in memory
object.size(da)

##------------------------------------------------------------------
## Import an internal example CSV file
tmp <- tempdir()
file.copy(system.file(
    "extdata", "ireland.csv", package = "geslaR"), tmp)
da <- read_gesla(paste0(tmp, "/ireland.csv"))
## Check size in memory
object.size(da)

##------------------------------------------------------------------
## Import an internal example Parquet file as data.frame
tmp <- tempdir()
file.copy(system.file(
    "extdata", "ireland.parquet", package = "geslaR"), tmp)
da <- read_gesla(paste0(tmp, "/ireland.parquet"),
    as_data_frame = TRUE)
## Check size in memory
object.size(da)

##------------------------------------------------------------------
## Import an internal example CSV file as data.frame
tmp <- tempdir()
file.copy(system.file(
    "extdata", "ireland.csv", package = "geslaR"), tmp)
da <- read_gesla(paste0(tmp, "/ireland.csv"),
    as_data_frame = TRUE)
## Check size in memory
object.size(da)

## Remove files from temporary directory
unlink(paste0(tmp, "/ireland.parquet"))
unlink(paste0(tmp, "/ireland.csv"))
