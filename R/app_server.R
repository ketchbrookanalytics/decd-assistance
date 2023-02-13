#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  data <- readRDS("decd_data_clean.RDS")

  data_filtered <- mod_filters_server(
    id = "filters_1",
    data = data
  )

  mod_table_server(
    id = "table_1",
    data = data_filtered
  )

}
