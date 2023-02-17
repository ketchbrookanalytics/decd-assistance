#' table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_table_ui <- function(id){
  ns <- NS(id)
  tagList(

    reactable::reactableOutput(
      outputId = ns("table"),
      height = 600
    )

  )
}

#' table Server Functions
#'
#' @noRd
mod_table_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    tbl_data <- shiny::reactive({

      req(data())

      data() |>
        dplyr::select(
          -c(latitude, longitude)
        )

    })

    format_currency <- reactable::JS("
      function(cellInfo) {
        return '$' + (cellInfo.value).toLocaleString()
      }
    ")

    output$table <- reactable::renderReactable({

      tbl_data() |>
        reactable::reactable(
          columns = list(
            fiscal_year = reactable::colDef(
              name = "Year",
              filterable = TRUE
            ),
            company_name = reactable::colDef(
              name = "Company",
              filterable = TRUE
            ),
            address = reactable::colDef(show = FALSE),
            city = reactable::colDef(
              name = "City",
              filterable = TRUE
            ),
            industry = reactable::colDef(
              name = "Industry",
              filterable = TRUE
            ),
            job_obligation_status = reactable::colDef(
              name = "Job Obligation Status",
              filterable = TRUE
            ),
            grant_amount = reactable::colDef(
              name = "Grant Amount",
              cell = format_currency
            ),
            loan_amount = reactable::colDef(
              name = "Loan Amount",
              cell = format_currency
            ),
            total_assistance = reactable::colDef(
              name = "Total Assistance",
              cell = format_currency
            ),
            total_project_cost = reactable::colDef(
              name = "Total Project Cost",
              cell = format_currency
            ),
            amount_leveraged = reactable::colDef(
              name = "Amount Leveraged",
              cell = format_currency
            ),
            funding_source = reactable::colDef(
              name = "Funding Source",
              filterable = TRUE
            )
          )
        )

    })

  })
}

## To be copied in the UI
# mod_table_ui("table_1")

## To be copied in the server
# mod_table_server("table_1")
