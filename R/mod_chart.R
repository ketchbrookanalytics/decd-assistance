#' chart UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_chart_ui <- function(id){
  ns <- NS(id)
  tagList(

  )
}

#' chart Server Functions
#'
#' @noRd
mod_chart_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_chart_ui("chart_1")

## To be copied in the server
# mod_chart_server("chart_1")
