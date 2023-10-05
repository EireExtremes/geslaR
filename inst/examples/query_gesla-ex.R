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
