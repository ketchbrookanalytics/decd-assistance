#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  # Build the query
  base_url <- "https://data.ct.gov/resource/xnw3-nytd.json?"
  columns <- c(
    "fiscal_year",
    "company_name",
    "job_obligation_status",
    "company_address AS address",
    "municipality AS city",
    "business_industry AS industry",
    "grant_amount",
    "loan_amount",
    "total_assistance",
    "total_project_cost",
    "amount_leveraged",
    "funding_source",
    "geocoded_location"
  )

  app_token <- Sys.getenv("APP_TOKEN")

  params <- paste0(
    "$select=",
    paste(columns, collapse = ", "),
    "&$$app_token=", app_token
  ) |>
    URLencode()

  # Retrieve the data from the API
  data <- jsonlite::fromJSON(
    paste0(base_url, params)
  ) |>
    tidyr::drop_na() |>
    dplyr::mutate(
      dplyr::across(
        .cols = c(fiscal_year, grant_amount:amount_leveraged),
        .fns = function(x) as.integer(x)
      ),
      job_obligation_status = tools::toTitleCase(trimws(job_obligation_status)),
      job_obligation_status = dplyr::case_when(
        job_obligation_status %in% c("Met", "Met Goal") ~ "Met",
        job_obligation_status == "Not Met" ~ "Not Met",
        job_obligation_status == "Pending" ~ "Pending",
        is.na(job_obligation_status) ~ "Unknown",
        TRUE ~ "Other"
      ),
      funding_source = dplyr::case_when(
        stringr::str_detect(
          string = funding_source,
          pattern = "Manufacturing Assistance Act"
        ) ~ "Manufacturing Assistance Act",
        trimws(funding_source) == "Small Business Express Program" ~ "Small Business Express Program"
      ),
      latitude = as.numeric(geocoded_location$latitude),
      longitude = as.numeric(geocoded_location$longitude),
    ) |>
    dplyr::select(
      fiscal_year,
      company_name,
      job_obligation_status,
      address,
      city,
      industry,
      grant_amount:amount_leveraged,
      funding_source,
      latitude,
      longitude
    )

  data_filtered <- mod_filters_server(
    id = "filters_1",
    data = data
  )

  mod_table_server(
    id = "table_1",
    data = data_filtered
  )

  mod_map_server(
    id = "map_1",
    data = data_filtered
  )

}
