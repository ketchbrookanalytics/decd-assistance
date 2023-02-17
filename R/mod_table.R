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
        reactable::reactable()

    })

  })
}

## To be copied in the UI
# mod_table_ui("table_1")

## To be copied in the server
# mod_table_server("table_1")
