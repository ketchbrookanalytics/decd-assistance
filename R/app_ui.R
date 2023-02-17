#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(

      shiny::h1("DECD Assistance Analyzer"),
      shiny::br(),
      shiny::p("To updated the data displayed, select choices in the filters below, then click the \"Apply\" button"),

      shiny::fluidRow(
        shiny::column(
          width = 12,
          shiny::wellPanel(
            mod_filters_ui("filters_1")
          )
        )
      ),

      shiny::hr(),

      shiny::fluidRow(
        shiny::column(
          width = 12,
          mod_table_ui("table_1")
        )
      )

    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "decd-assistance"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
