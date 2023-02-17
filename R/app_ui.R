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
    bslib::page_navbar(
      id = "nav_bar",
      title = "DECD Assistance Analyzer",
      bg = "#1C81D7",
      theme = bslib::bs_theme(
        bootswatch = "united",
        bg = "#FFFFFF",
        fg = "#000000",
        primary = "#1C81D7",   # Ketchbrook blue
        base_font = bslib::font_google("Arimo")
      ),

      bslib::nav(
        title = "Home",

        shiny::fluidRow(
          shiny::column(
            width = 12,

            shiny::p("To updated the data displayed in the table & map, select choices in the filters below, then click the \"Apply\" button."),
            shiny::p("To revert the filters and display all data, click the \"Reset\" button."),

            shiny::wellPanel(
              mod_filters_ui("filters_1")
            )
          )
        ),

        shiny::hr(),

        shiny::tabsetPanel(
          id = "tabset1",
          type = "pills",

          shiny::tabPanel(
            title = "Table",
            value = "table_tab", icon = shiny::icon("table"),
            shiny::br(),
            shiny::fluidRow(
              shiny::column(
                width = 12,
                mod_table_ui("table_1")
              )
            )
          ),

          shiny::tabPanel(
            title = "Map",
            value = "map_tab",
            icon = shiny::icon("globe"),
            shiny::br(),
            shiny::fluidRow(
              shiny::column(
                width = 12,
                mod_map_ui("map_1")
              )
            )
          )

        )

      ),

      bslib::nav(
        title = "About",

        shiny::fluidRow(

          shiny::column(
            width = 12,

            shiny::div(
              class = "mt-4 p-5 bg-dark text-white rounded",
              shiny::h1("Enjoying This App?"),

              shiny::br(),

              shiny::p(
                "This app displays direct financial assistance given to businesses by the Department of Economic and Community Development in the State of Connecticut."
              ),

              shiny::span(
                "The source data can be found at:",
                shiny::a(
                  "https://data.ct.gov/Business/Department-of-Economic-and-Community-Development-D/xnw3-nytd",
                  href = "https://data.ct.gov/Business/Department-of-Economic-and-Community-Development-D/xnw3-nytd",
                  target = "_blank"
                ),
                "."
              ),

              shiny::br(),
              shiny::br(),
              shiny::br(),

              shiny::p(
                class = "lead",
                "Check out what else Ketchbrook Analytics can do for you."
              ),
              shiny::a(
                class = "btn btn-warning btn-lg",
                href = "https://www.ketchbrookanalytics.com/",
                target = "_blank",
                "Visit Us"
              )
            )
          )

        )

      ),

      bslib::nav_spacer(),

      bslib::nav_item(
        shiny::a(
          shiny::icon("paper-plane"),
          "Contact",
          href = "mailto:info@ketchbrookanalytics.com?subject=DECD Assistance Analyzer"
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
      app_title = "DECD Assistance Analyzer"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
