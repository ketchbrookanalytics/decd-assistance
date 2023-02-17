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
      outputId = ns("table")
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

    output$table <- reactable::renderReactable({

      tbl_data() |>
        reactable::reactable(
          columns = list(
            fiscal_year = reactable::colDef(name = "Year"),
            company_name = reactable::colDef(name = "Company"),
            address = reactable::colDef(show = FALSE),
            city = reactable::colDef(name = "City"),
            industry = reactable::colDef(name = "Industry"),
            job_obligation_status = reactable::colDef(name = "Job Obligation Status"),
            grant_amount = reactable::colDef(
              name = "Grant Amount",
              format = reactable::colFormat(currency = "USD", digits = 0, separators = TRUE)
            ),
            loan_amount = reactable::colDef(
              name = "Loan Amount",
              format = reactable::colFormat(currency = "USD", digits = 0, separators = TRUE)
            ),
            total_assistance = reactable::colDef(
              name = "Total Assistance",
              format = reactable::colFormat(currency = "USD", digits = 0, separators = TRUE)
            ),
            total_project_cost = reactable::colDef(
              name = "Total Project Cost",
              format = reactable::colFormat(currency = "USD", digits = 0, separators = TRUE)
            ),
            amount_leveraged = reactable::colDef(
              name = "Amount Leveraged",
              format = reactable::colFormat(currency = "USD", digits = 0, separators = TRUE)
            ),
            funding_source = reactable::colDef(name = "Funding Source")
          )
        )

    })

  })
}

## To be copied in the UI
# mod_table_ui("table_1")

## To be copied in the server
# mod_table_server("table_1")
