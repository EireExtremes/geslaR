# geslaR 1.0-3

* Declare a minimum R version dependency (`R >= 4.1.0`), fixing a CRAN
  check NOTE caused by the use of the native pipe `|>` in
  `query_gesla()`.
* Update maintainer email address.
* Remove references to the discontinued NUIM RStudio Connect server
  that hosted the online geslaR-app; only the locally-run app (via
  `run_gesla_app()`) is documented now.
* Fix various spelling typos in the documentation.

# geslaR 1.0-2

* Fix `read_gesla()` to correctly detect the file type when file names
  contain multiple dots (e.g. `db.gz.parquet`), by using the last
  extension instead of the second dot-separated part.

# geslaR 1.0-1

* Initial CRAN submission.
