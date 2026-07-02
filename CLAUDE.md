# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## What this is

**geslaR** is an R package (CRAN) that provides access to the GESLA
(Global Extreme Sea Level Analysis) dataset — a ~7GB, 1.7-billion-row
sea-level records dataset hosted as Parquet files in a public,
anonymous-access Amazon S3 bucket (`gesla-dataset/parquet_files`,
region `eu-west-1`). The package never bundles the dataset itself; all
five exported functions revolve around getting the data (or a subset
of it) into R without loading it entirely into memory, using the
**arrow** package.

## Development commands

This is a standard R package developed with `devtools`/`roxygen2`. Run
these from an R console at the package root (or via `Rscript -e`).

- Run the full test suite: `devtools::test()`
- Run a single test file: `devtools::test_active_file("tests/testthat/test-read_gesla.R")`
  or `testthat::test_file("tests/testthat/test-read_gesla.R")`
- Regenerate `man/*.Rd` and `NAMESPACE` from roxygen comments:
  `devtools::document()` (do this after editing any `##'` roxygen
  block in `R/*.R`)
- Full package check (what CI runs, `R-CMD-check.yaml`):
  `devtools::check()` / `rcmdcheck::rcmdcheck()`
- Load all functions for interactive testing: `devtools::load_all()`
- Test coverage (what CI runs, `test-coverage.yaml`): `covr::codecov()`
  or `covr::package_coverage()` — note `R/utils.R` is excluded from
  coverage via `.covrignore`
- Build README: knit `README.Rmd` to `README.md` (README.md is
  generated, do not edit it directly)
- Rebuild vignettes from their `.Rmd.orig` sources: see
  `vignettes/Makefile` (the `.Rmd.orig` files are the source of truth;
  `vignettes/*.Rmd` are pre-knitted outputs, needed because vignettes
  require downloading data and cannot be built on CRAN)

Tests that need real network/S3 access (e.g. the commented-out
`arrow_with_s3()` check in `test-query_gesla.R`, and parts of
`test-download_gesla.R`/`test-run_gesla_app.R`) are largely
disabled/guarded since they would hit the live S3 bucket or download
the full ~7GB dataset. Prefer the small fixtures in
`tests/testthat/testdata/` (`antarctica.csv`, `antarctica.parquet`,
etc., mirrored in `inst/extdata/`) when adding tests instead of live
downloads.

## Architecture

Five exported functions in `R/`, each in its own file named after the
function, cover the three ways a user can get GESLA data into R
(documented in the `intro-to-geslaR` vignette):

1. **`download_gesla()`** (`R/download_gesla.R`) — copies the *entire*
   dataset from the S3 bucket to a local directory via
   `arrow::copy_files()`. Interactive confirmation gate (`ask =
   TRUE`/`utils::menu()`) before pulling ~7GB.
2. **`query_gesla()`** (`R/query_gesla.R`) — the main "no full
   download needed" path. Opens the S3 bucket as an `arrow::open_dataset()`,
   builds up a lazy `dplyr::filter()` chain (country/year/site_name/use_flag),
   and only pulls data with `compute()`/`collect()`. Returns an
   `arrow_dplyr_query`/`Table` by default; only materializes to a
   `tbl_df` if `as_data_frame = TRUE` is explicitly requested (default
   `FALSE` is intentional — the full dataset is larger than memory).
3. **`run_gesla_app()`** (`R/run_gesla_app.R`) — launches a bundled
   Shiny app (`inst/shiny/app.R`, ~465 lines) that lets users
   interactively filter/visualize/download subsets. It requires the
   full dataset locally (calls `download_gesla()` under the hood if
   missing) and requires a large set of `Suggests`-only packages,
   checked at runtime via `check_suggests()` in `R/utils.R` (this is
   the only function excluded from coverage, per `.covrignore`). The
   same app is also hosted online (see docstrings for the URL); the
   local version exists mainly for speed.
4. **`read_gesla()`** / **`write_gesla()`** (`R/read_gesla.R`,
   `R/write_gesla.R`) — round-trip helpers for files exported from the
   geslaR-app (CSV or Parquet), dispatching on file extension /
   object class (`ArrowObject` → Parquet, `data.frame` → CSV) to the
   matching `arrow::read_*`/`write_*` function.

Cross-cutting conventions:

- All user-facing errors/messages go through the **cli** package
  (`cli::format_error()`, `cli_alert_info()`, `cli_progress_step()`),
  not base `stop()`/`message()`.
- Code paths that only run when hitting the live S3 bucket or making
  real downloads are marked `# nocov start` / `# nocov end` since they
  can't be exercised in CI/coverage.
- Roxygen (`##'`) blocks are the source of truth for docs; each
  exported function has a matching runnable example file in
  `inst/examples/*-ex.R` referenced via `@example`.
- Example/test fixture data (`antarctica.*`, `ireland.*`) lives in
  both `inst/extdata/` (for package examples/vignettes) and
  `tests/testthat/testdata/` (for tests); `data-raw/*.R` scripts show
  how these were derived from the full dataset.
