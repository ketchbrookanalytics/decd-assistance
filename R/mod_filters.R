#' filters UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_filters_ui <- function(id){
  ns <- NS(id)
  tagList(

    # Year range filter
    shiny::sliderInput(
      inputId = ns("filter_year"),
      label = "Select Fiscal Year",
      min = 0,   #NULL,
      max = 10,   #NULL,
      value = c(4 ,6),   #NULL,
      step = 1L,
      sep = "",
      width = NULL
    ),

    # City drop-down filter
    shinyWidgets::pickerInput(
      inputId = ns("filter_city"),
      label = "Select City",
      choices = NULL,
      selected = character(0),
      multiple = TRUE,
      options = list(
        `actions-box` = TRUE,
        `selected-text-format` = 'count > 1',
        `select-all-text` = "All"
      ),
      width = NULL
    ),

    # Funding Source drop-down filter
    shinyWidgets::pickerInput(
      inputId = ns("filter_funding_source"),
      label = "Select Funding Source",
      choices = c("Manufacturing Assistance Act", "Small Business Express Program"),
      selected = c("Manufacturing Assistance Act", "Small Business Express Program"),
      multiple = TRUE,
      options = list(
        `actions-box` = TRUE,
        `selected-text-format` = 'count > 1',
        `select-all-text` = "All"
      ),
      width = NULL
    ),

    # Industry drop-down filter
    shinyWidgets::pickerInput(
      inputId = ns("filter_industry"),
      label = "Select Industry",
      choices = NULL,
      selected = character(0),
      multiple = TRUE,
      options = shinyWidgets::pickerOptions(
        actionsBox = TRUE,
        selectedTextFormat = "count > 1",
        selectAllText = "All",
        virtualScroll = 200L
      ),
      width = NULL
    ),

    # Apply Filters button
    shiny::actionButton(
      class = "btn btn-primary",
      inputId = ns("apply"),
      label = "Apply",
      width = NULL
    )

  )
}

#' filters Server Functions
#'
#' @noRd
mod_filters_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    shiny::observe({

      shiny::req(data)

      min_year <- min(data$fiscal_year)
      max_year <- max(data$fiscal_year)

      shiny::updateSliderInput(
        session = session,
        inputId = "filter_year",
        value = c(min_year, max_year),
        min = min_year,
        max = max_year
      )

      cities <- unique(data$city) |> sort()

      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "filter_city",
        choices = cities,
        selected = cities
      )

      industries <- unique(data$industry) |> sort()

      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "filter_industry",
        choices = industries,
        selected = industries
      )

    })

    filtered_data <- shiny::reactive(
      data |>
        dplyr::filter(
          fiscal_year %in% input$filter_year[1]:input$filter_year[2],
          city %in% input$filter_city,
          funding_source %in% input$filter_funding_source,
          industry %in% input$filter_industry
        )
    ) |>
      shiny::bindEvent(input$apply, ignoreNULL = FALSE)

    return(filtered_data)

  })
}

## To be copied in the UI
# mod_filters_ui("filters_1")

## To be copied in the server
# mod_filters_server("filters_1")
