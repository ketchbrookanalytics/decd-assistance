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

    shiny::fluidRow(

      shiny::column(
        width = 2,

        # Year range filter
        shinyWidgets::pickerInput(
          inputId = ns("filter_year"),
          label = "Select Year",
          choices = NULL,
          selected = NULL,
          multiple = TRUE,
          options = list(
            `actions-box` = TRUE,
            `selected-text-format` = 'count > 2',
            `select-all-text` = "All"
          ),
          width = NULL
        )

      ),

      shiny::column(
        width = 3,

        # Industry drop-down filter
        shinyWidgets::pickerInput(
          inputId = ns("filter_industry"),
          label = "Select Industry",
          choices = NULL,
          selected = NULL,
          multiple = TRUE,
          options = shinyWidgets::pickerOptions(
            actionsBox = TRUE,
            selectedTextFormat = "count > 1",
            selectAllText = "All",
            virtualScroll = 200L
          ),
          width = NULL
        )

      ),

      shiny::column(
        width = 3,

        # City drop-down filter
        shinyWidgets::pickerInput(
          inputId = ns("filter_city"),
          label = "Select City",
          choices = NULL,
          selected = NULL,
          multiple = TRUE,
          options = list(
            `actions-box` = TRUE,
            `selected-text-format` = 'count > 1',
            `select-all-text` = "All"
          ),
          width = NULL
        )

      ),

      shiny::column(
        width = 3,

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
        )

      ),

      shiny::column(
        width = 1,

        # Apply Filters button
        shiny::actionButton(
          class = "btn btn-primary",
          inputId = ns("apply"),
          label = "Apply",
          width = NULL
        ),

        shiny::br(),
        shiny::br(),

        # Reset Filters button
        shiny::actionButton(
          class = "btn btn-warning",
          inputId = ns("reset"),
          label = "Reset",
          width = NULL
        )

      )

    )

  )
}

#' filters Server Functions
#'
#' @noRd
mod_filters_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # Create a reactive value object called `current_data`
    # Default is entire data set
    current_data <- reactiveVal(data)

    # Capture unique values from data for filter choices
    min_year <- min(data$fiscal_year)
    max_year <- max(data$fiscal_year)
    years <- unique(data$fiscal_year) |> sort()
    cities <- unique(data$city) |> sort()
    industries <- unique(data$industry) |> sort()

    # Populate Filters ----
    shiny::observe({

      # Populate "Year" filter
      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "filter_year",
        choices = years,
        selected = years
      )

      # Populate "Industry" filter
      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "filter_industry",
        choices = industries,
        selected = industries
      )

      # Populate "City" filter
      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "filter_city",
        choices = cities,
        selected = cities
      )

    })

    # Reset Filters ----
    # When the "Reset" button is clicked, update the selected items in the
    # filters and set the reactive value object to all of the data
    observe({

      # Reset the "Year" filter
      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "filter_year",
        selected = years
      )

      # Reset the "Industry" filter
      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "filter_industry",
        selected = industries
      )

      # Reset the "City" filter
      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "filter_city",
        selected = cities
      )

      # Reset the "Funding Source" filter
      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "filter_funding_source",
        selected = c("Manufacturing Assistance Act", "Small Business Express Program")
      )

      # Reset the reactive values object to the input dataset (all of the data)
      current_data(data)

    }) |>
      shiny::bindEvent(input$reset, ignoreInit = TRUE)

    # Apply Filters ----
    # When the "Apply" button is clicked, filter the data and update the
    # reactive value object
    observe({

      df <- data |>
        dplyr::filter(
          fiscal_year %in% input$filter_year,
          city %in% input$filter_city,
          funding_source %in% input$filter_funding_source,
          industry %in% input$filter_industry
        )

      # Update the`current_data` reactive val to be the filtered data
      current_data(df)

    }) |>
      shiny::bindEvent(input$apply)

    return(current_data)

  })
}

## To be copied in the UI
# mod_filters_ui("filters_1")

## To be copied in the server
# mod_filters_server("filters_1")
