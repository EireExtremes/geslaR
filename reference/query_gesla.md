# Query the GESLA dataset

This function will make a query to fetch a subset of the GESLA dataset.
At least a country code and one year must be specified. Site names can
also be specified, but are optional. By default, the resulting subset
will contain only data that were revised and recommended for analysis,
by the GESLA group of researchers.

## Usage

``` r
query_gesla(
  country,
  year = NULL,
  site_name = NULL,
  use_flag = 1,
  as_data_frame = FALSE
)
```

## Arguments

- country:

  A character vector specifying the selected countries, using the
  three-letter [ISO 3166-1
  alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) code. See
  Details.

- year:

  A numeric vector specifying the selected years. If `NULL` (the
  default), all available years will be selected.

- site_name:

  Optional character vector of site names.

- use_flag:

  The default is `1`, which means to use only the data that was revised
  and usefull for analysis. Can be `0`, to fetch only revised and not
  recommend for analysis, or `c(0, 1)` to fetch all the data. See
  Details.

- as_data_frame:

  If `FALSE` (default), the data will be imported as an
  `arrow_dplyr_query` object. Otherwise, the data will be in a `tbl_df`
  (`data.frame`) format. See Details.

## Value

An object of class `arrow_dplyr_query` or a `tbl_df` (`data.frame`).

## Details

The country codes must follow the three-letter [ISO 3166-1
alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) code.
However, note that not all countries are available at the GESLA dataset.
If in doubt, please check the GESLA Shiny app interface (geslaR-app)
online in this
[server](https://rstudio.maths.nuim.ie:3939/content/3258adf1-efbb-4996-9a8a-08a474639e8b/),
or use the
[`run_gesla_app()`](https://eireextremes.github.io/geslaR/reference/run_gesla_app.md)
function to open the interface locally.

The `use_flag` argument must be `1` or `0`, or `c(0, 1)`. The `use_flag`
is a column at the GESLA dataset thet indicates wehter the data should
be used for analysis or not. The `1` (default) indicates it should, and
`0` the otherwise. In a data analysis scenario, the user must only be
interested in using the recommended data, so this argument shouldn't be
changed. However, in same cases, one must be interested in the
non-recommended data, therefore this option is available. Also, you can
specify `c(0, 1)` to fetch all the data (usable and not usable). In any
case, the `use_flag` column will always be present, and it can be used
for any post-processing. Please, see the [GESLA
format](https://gesla787883612.wordpress.com/format/) documentation for
more details.

The default argument `as_data_frame = FALSE` will result in an object of
the `arrow_dplyr_query` class. The advantage is that, regardless of the
size of the resulting dataset, the object will be small in (memory)
size. Also, as it happens with the Arrow `Table` class, it can be
manipulated with `dplyr` verbs. Please, see the documentation at the
[Arrow
website](https://arrow.apache.org/docs/r/articles/data_wrangling.html).

Note that, if the `as_data_frame` argument is set to `TRUE`, the
imported R object will vary in size, according to the size of the
subset. In many situations, this can take a long time an may even be
infeasible, since the object can result in a "larger-than-memory" size,
and possibly will make R operations slow or even a session crash.
Therefore, we always recommend to start with `as_data_frame = FALSE`,
and work with the dataset from there.

Please, see
[`vignette("intro-to-geslaR")`](https://eireextremes.github.io/geslaR/articles/intro-to-geslaR.md)
for a detailed example.

## Author

Fernando Mayer <fernando.mayer@mu.ie>

## Examples

``` r
if(interactive()) {
    ## Simple query
    da <- query_gesla(country = "IRL")

    ## Select one specific year
    da <- query_gesla(country = "IRL", year = 2015)

    ## Multiple years
    da <- query_gesla(country = "IRL", year = c(2015, 2017))
    da <- query_gesla(country = "IRL", year = 2010:2017)
    da <- query_gesla(country = "IRL", year = c(2010, 2012, 2015))
    da |>
        count(year) |>
        collect()

    ## Multiple countries
    da <- query_gesla(country = c("IRL", "ATA"), year = 2015)
    da <- query_gesla(country = c("IRL", "ATA"), year = 2010:2017)
    da |>
        count(country, year) |>
        collect()

    ## Specifying a site name
    da <- query_gesla(country = "IRL", year = c(2015, 2017),
        site_name = "Dublin_Port")
    da |>
        count(year) |>
        collect()
}
```
