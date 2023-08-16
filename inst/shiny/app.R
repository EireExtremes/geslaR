pkgs <- c("arrow", "tidyverse", "lubridate", "shiny", "shinyWidgets",
          "leaflet", "patchwork", "shinycssloaders", "shinyalert",
          "leafpop", "plotly", "bslib", "DT")
lapply(pkgs, library, character.only = TRUE, warn.conflicts = FALSE,
    verbose = FALSE, quietly = TRUE) |>
    suppressMessages()
theme_set(theme_bw())

## Create arrow dataset
## path <- s3_bucket("gesla-dataset/parquet_files", anonymous = TRUE)
path <- "gesla_dataset"
da <- open_dataset(path, format = "parquet")
names(da)

## Auxiliary objects needed from dataset
## See script-aux.R
countries <- readRDS("countries.rds")
years <- readRDS("years.rds")

##----------------------------------------------------------------------
## Create objects to use on country names (see script-data-countries.R)
cc <- vroom::vroom("countries.csv", show_col_types = FALSE,
                   col_select = c(country = "Country",
                                  code = "Alpha-3 code",
                                  flag = "emoji_flag"))

## Country names, country codes and flags
cc <- right_join(cc, tibble(code = countries), by = "code") |>
  arrange(country)

## This is necessary to use in multiInput()
cn <- lapply(seq_along(countries),
             FUN = function(i) {
               tagList(
                 cc$flag[i],
                 sprintf("%s (%s)", cc$country[i], cc$code[i])
               )
             })
names(cn) <- cc$code

## Link to ISO 3366-1 standards for the country codes
iso <- "https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3"

##======================================================================
ui <- navbarPage(
  "The GESLA dataset",
  id = "navbar",
  theme = bslib::bs_theme(bootswatch = "flatly"),

  ##------------------------------------------------------------------
  ## Select data page
  tabPanel(
    "Select data", value = 2,
    sidebarLayout(
      sidebarPanel(
        h4("Basic filters"), br(),
        helpText(
          "Country codes follow the",
          tags$a(href = iso, "ISO 3166-1 alpha-3"),
          "standards."),
        multiInput(
          inputId = "sel_country",
          label = "Select one or more countries",
          choices = NULL,
          choiceNames = cn,
          choiceValues = names(cn),
          options = list(enable_search = TRUE)
        ),
        pickerInput(
          "sel_year", "Select one or more years",
          choices = NULL,
          options = list(
            "actions-box" = TRUE,
            "live-search" = TRUE,
            "live-search-placeholder" = "Search...",
            "selected-text-format" = "count > 10",
            "virtual-scroll" = TRUE,
            "none-selected-text" =
              "Click to select or search"),
          multiple = TRUE),
        pickerInput(
          "sel_site", "Select one or more sites",
          choices = NULL,
          options = list(
            "actions-box" = TRUE,
            "live-search" = TRUE,
            "live-search-placeholder" = "Search...",
            "selected-text-format" = "count > 10",
            "virtual-scroll" = TRUE,
            "none-selected-text" =
              "Click to select or search"),
          multiple = TRUE),
        br(),
        actionButton("reset", "Reset filters",
                     icon = icon("redo")),
        br(), br(),
        h4("Data summary"),
        withSpinner(
          DT::dataTableOutput("table_summary")
        )
      ),
      mainPanel(tabsetPanel(
        tabPanel(
          "Data preview", br(),
          tags$h6("The table below is just a sample",
                  "(the first 1000 lines)",
                  "of the data"),
          br(),
          withSpinner(
            DT::dataTableOutput("table")),
          br(),
          downloadButton("download_csv",
                         label = "Download CSV"),
          downloadButton("download_parquet",
                         label = "Download PARQUET")
        ),
        tabPanel("Plots", tabsetPanel(
          tabPanel(
            "Counts",
            withSpinner(
              plotlyOutput("plt_counts",
                           width = "90%",
                           height = 800))
          ),
          tabPanel(
            "Lines",
            withSpinner(
              plotlyOutput("plt_lines",
                           width = "90%",
                           height = 800))
          ),
          tabPanel(
            "Histograms",
            withSpinner(
              plotlyOutput("plt_hist",
                           width = "90%",
                           height = 800))
          )
        )),

        tabPanel("Plots by site", tabsetPanel(
          tabPanel(
            "Counts",
            withSpinner(
              plotlyOutput("plt_counts_s",
                           width = "90%",
                           height = 800))
          ),
          tabPanel(
            "Lines",
            withSpinner(
              plotlyOutput("plt_lines_s",
                           width = "90%",
                           height = 800))
          ),
          tabPanel(
            "Histograms",
            withSpinner(
              plotlyOutput("plt_hist_s",
                           width = "90%",
                           height = 800))
          )
        )),

        tabPanel("Summary", withSpinner(
          DT::dataTableOutput("table_summary_full"))),
        tabPanel(
          "Map",
          withSpinner(
            leafletOutput("map",
                          width = "100%", height = 800)))
      ))
    )
  )
)

server <- function(input, output, session) {
  ##------------------------------------------------------------------
  ## Select data page
  sel_country_re <- reactive({
    req(input$sel_country)
    da |>
      filter(country %in% input$sel_country)
  })

  sel_year_re <- reactive({
    req(input$sel_year)
    sel_country_re() |>
      filter(year %in% input$sel_year)
  })

  observeEvent(sel_country_re(), {
    updatePickerInput(session, "sel_year",
                      choices = sel_country_re() |>
                        distinct(year) |>
                        collect() |>
                        pull() |>
                        sort(),
                      selected = character())
  })

  observeEvent(sel_year_re(), {
    updatePickerInput(session, "sel_site",
                      choices = sel_year_re() |>
                        distinct(site_name) |>
                        collect() |>
                        pull() |>
                        sort(),
                      selected = character())
  })

  observeEvent(input$reset, {
    updateMultiInput(session, "sel_country", selected = character())
    updatePickerInput(session, "sel_year", choices = years)
    updatePickerInput(session, "sel_site", choices = character(),
                      clearOptions = TRUE)
  })

  tab_sum_re <- reactive({
    req(input$sel_site)
    sel_year_re() |>
      filter(site_name %in% input$sel_site, use_flag == 1) |>
      summarise(
        "Number of countries" = n_distinct(country),
        "Number of years" = n_distinct(year),
        "First year" = min(year),
        "Last year" = max(year),
        "Number of sites" = n_distinct(site_name),
        "Total number of rows" = n()) |>
      collect()
  })

  output$table_summary <-
    DT::renderDataTable(
      tab_sum_re() |>
        ## This has to be done here, because it doesn't work on
        ## arrow, and it has to be done before transposing
        mutate(
          "Total number of rows" =
            formatC(tab_sum_re()$`Total number of rows`,
                    format = "f", big.mark = ",",
                    drop0trailing = TRUE)) |>
        t() |>
        DT::datatable(
          colnames = "",
          filter = "none",
          options = list(
            paging = FALSE,
            searching = FALSE,
            columnDefs = list(list(
              className = "dt-right", targets = 1))
          )
        )
    )

  tab_sum2_re <- reactive({
    ## Some problem here: it's not all (base, stats) functions that
    ## will work with arrow
    ## Warning: median() currently returns an approximate median in
    ## Arrow
    req(input$sel_site)
    sel_year_re() |>
      filter(site_name %in% input$sel_site, use_flag == 1) |>
      group_by(country, site_name) |>
      summarise(
        "Minimum" = min(sea_level, na.rm = TRUE),
        "Mean" = mean(sea_level, na.rm = TRUE),
        "Median" = median(sea_level, na.rm = TRUE),
        "Maximum" = max(sea_level, na.rm = TRUE),
        "SD" = sd(sea_level, na.rm = TRUE),
        "NAs" = sum(is.na(sea_level))) |>
      arrange(country, site_name) |>
      collect()
  })

  output$table_summary_full <-
    DT::renderDataTable(
      tab_sum2_re() |>
        DT::datatable(
          colnames = c("Country" = "country",
                       "Site" = "site_name"),
          filter = "none",
          options = list(
            paging = FALSE,
            searching = FALSE)
        ) |>
        DT::formatRound(columns = 3:7, digits = 3) |>
        DT::formatRound(columns = 8, digits = 0)
    )

  tab_re <- reactive({
    req(input$sel_site)
    sel_year_re() |>
      filter(site_name %in% input$sel_site, use_flag == 1) |>
      arrange(country, date_time, site_name) |>
      select(-qc_flag, -use_flag, -file_name)
    ## Due to a bug in the recent version of arrow, the
    ## write_parquet() function, used below to create the parquet
    ## file for download was giving a segfault, so the solution was
    ## to keep as 'arrow' here and use collect() in all other places
    ## where tab_re() is used. See
    ## https://github.com/apache/arrow/issues/34211
    ## collect()
  })

  output$table <-
    DT::renderDataTable(
      tab_re() |>
        slice_head(n = 1000) |>
        arrange(country, year, site_name, lat, lon) |>
        select(country, year, site_name, lat, lon, sea_level) |>
        collect()
    )

  output$download_csv <- downloadHandler(
    filename = function() {
      paste0("geslaR_",
             format(Sys.time(), format = "%Y-%m-%d_%H:%M:%S"),
             ".csv")
    },
    content = function(file) {
      vroom::vroom_write(tab_re() |> collect(), file, delim = ",")
      ## write.csv(tab_re(), file, row.names = FALSE)
    }
  )

  output$download_parquet <- downloadHandler(
    filename = function() {
      paste0("geslaR_",
             format(Sys.time(), format = "%Y-%m-%d_%H:%M:%S"),
             ".parquet")
    },
    content = function(file) {
      write_parquet(tab_re(), file)
    }
  )

  ##------------------------------------------------------------------
  ## Plots
  output$plt_counts <- renderPlotly({
    p_counts <- tab_re() |>
      collect() |>
      count(year, country) |>
      ggplot(aes(x = year, y = n)) +
      geom_bar(stat = "identity") +
      labs(title = "Observations by year") +
      xlab("Year") + ylab("Counts") +
      facet_wrap(~ country, scales = "free", dir = "v")
    p_counts <- ggplotly(p_counts)
    p_counts
  })

  output$plt_lines <- renderPlotly({
    p_lines <- tab_re() |>
      group_by(year, country) |>
      collect() |>
      summarise(max = max(sea_level, na.rm = TRUE),
                min = min(sea_level, na.rm = TRUE),
                mean = mean(sea_level, na.rm = TRUE)) |>
      ## collect() |>
      pivot_longer(cols = c(max, mean, min)) |>
      ggplot(aes(x = year, y = value, colour = name)) +
      geom_line() +
      theme(legend.position = "top") +
      labs(colour = "",
           title = "Maximum, mean and minimum sea level by year") +
      xlab("Year") + ylab("Sea level") +
      facet_wrap(~ country, scales = "free", dir = "v")
    p_lines <- ggplotly(p_lines)
    p_lines |>
      layout(legend = list(orientation = "h", x = 0.25))
  })

  output$plt_hist <- renderPlotly({
    p_hist <- tab_re() |>
      group_by(year, country) |>
      collect() |>
      ggplot(aes(x = sea_level)) +
      geom_histogram() +
      labs(title = "Histogram of sea level") +
      xlab("Sea level") + ylab("Counts") +
      facet_wrap(~ country, scales = "free", dir = "v")
    p_hist <- ggplotly(p_hist)
    p_hist
  })

  ##------------------------------------------------------------------
  ## Plots by site

    output$plt_counts_s <- renderPlotly({
      p_counts_s <- tab_re() |>
        collect() |>
        count(year, country, site_name) |>
        ggplot(aes(x = year, y = n)) +
        geom_bar(stat = "identity") +
        labs(title = "Observations by year") +
        xlab("Year") + ylab("Counts") +
        facet_wrap(~ site_name, scales = "free", dir = "v")
      p_counts_s <- ggplotly(p_counts_s)
      p_counts_s
    })

  output$plt_lines_s <- renderPlotly({
    p_lines_s <- tab_re() |>
      group_by(year, country, site_name) |>
      collect() |>
      summarise(max = max(sea_level, na.rm = TRUE),
                min = min(sea_level, na.rm = TRUE),
                mean = mean(sea_level, na.rm = TRUE)) |>
      ## collect() |>
      pivot_longer(cols = c(max, mean, min)) |>
      ggplot(aes(x = year, y = value, colour = name)) +
      geom_line() +
      theme(legend.position = "top") +
      labs(colour = "",
           title = "Maximum, mean and minimum sea level by year") +
      xlab("Year") + ylab("Sea level") +
      facet_wrap(~ site_name, scales = "free", dir = "v")
    p_lines_s <- ggplotly(p_lines_s) |>
      layout(legend = list(orientation = "h", x = 0.25))
  })

  output$plt_hist_s <- renderPlotly({
    p_hist_s <- tab_re() |>
      group_by(year, country, site_name) |>
      collect() |>
      ggplot(aes(x = sea_level)) +
      geom_histogram() +
      labs(title = "Histogram of sea level") +
      xlab("Sea level") + ylab("Counts") +
      facet_wrap(~ site_name, scales = "free", dir = "v")
    p_hist_s <- ggplotly(p_hist_s)
    if(length(input$sel_site) > 12) {
      shinyalert(
        "Note",
        "Try selecting less sites for a better visualisation",
        type = "warning"
      )
      p_hist_s
    } else {
      p_hist_s
    }
  })

  map_re <- reactive({
    tab_re() |>
      group_by(site_name, lat, lon) |>
      collect() |>
      summarise(
        n_years = n_distinct(year),
        year_range = sprintf("%s-%s", min(year), max(year)),
        n_total = n())
  })

  output$map <- renderLeaflet({
    leaflet() |>
      addTiles() |>
      addMarkers(lng = map_re()$lon, lat = map_re()$lat,
                 popup = popupTable(map_re()),
                 data = map_re())
  })

}

shinyApp(ui, server)
