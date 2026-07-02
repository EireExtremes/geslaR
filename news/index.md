# Changelog

## geslaR 1.0-3

- Declare a minimum R version dependency (`R >= 4.1.0`), fixing a CRAN
  check NOTE caused by the use of the native pipe `|>` in
  [`query_gesla()`](https://eireextremes.github.io/geslaR/reference/query_gesla.md).
- Update maintainer email address.

## geslaR 1.0-2

- Fix
  [`read_gesla()`](https://eireextremes.github.io/geslaR/reference/read_gesla.md)
  to correctly detect the file type when file names contain multiple
  dots (e.g. `db.gz.parquet`), by using the last extension instead of
  the second dot-separated part.

## geslaR 1.0-1

CRAN release: 2023-10-09

- Initial CRAN submission.
