#' map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_map_ui <- function(id){
  ns <- NS(id)
  tagList(

    leaflet::leafletOutput(
      outputId = ns("map"),
      height = 600
    ),

    shiny::br(),

    shiny::p("Note: Circle color is scaled by amount of total assistance.")



  )
}

#' map Server Functions
#'
#' @noRd
mod_map_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    map_data <- shiny::reactive({

      shiny::req(data())

      pal <- leaflet::colorNumeric(
        # palette = "Greens",
        palette = colorRamp(
          c("lightgreen", "darkgreen"),
          interpolate = "spline"
        ),
        domain = log(data()$total_project_cost)
      )

      shiny::validate(
        shiny::need(
          nrow(data()) >= 1L, "No data to display"
        )
      )

      data() |>
        dplyr::select(
          company_name,
          job_obligation_status,
          total_assistance,
          total_project_cost,
          amount_leveraged,
          funding_source,
          latitude,
          longitude
        ) |>
        dplyr::mutate(
          tooltip = paste0(
            "<strong>", company_name, "</strong>",
            "<br/>Status: <em>", job_obligation_status, "</em>",
            "<br/>Total Assistance: <em>$", format(total_assistance, big.mark = ","), "</em>",
            "<br/>Total Project Cost: <em>$", format(total_project_cost, big.mark = ","), "</em>",
            "<br/>Amount Leveraged: <em>$", format(amount_leveraged, big.mark = ","), "</em>",
            "<br/>Funding Source: <em>", funding_source, "</em>"
          ) |> as.list() |> lapply(shiny::HTML),
          color = pal(log(total_project_cost))
        )

    })

    # Render the map
    output$map <- leaflet::renderLeaflet(
      map_data() |>
        leaflet::leaflet() |>
        leaflet::addProviderTiles(provider = leaflet::providers$Esri) |>
        leaflet::addCircleMarkers(
          lng = ~longitude,
          lat = ~latitude,
          # weight = 6,
          # radius = 4,
          color = ~color,
          opacity = 0.8,
          fillOpacity = 0.6,
          label = ~tooltip,
          labelOptions = leaflet::labelOptions(noHide = F, textsize = "15px")
        )
    )

  })
}

## To be copied in the UI
# mod_map_ui("map_1")

## To be copied in the server
# mod_map_server("map_1")
