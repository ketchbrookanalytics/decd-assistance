

readRDS("decd_data_raw.RDS") |>
  # extract lat/lon coordinates into separate columns
  tidyr::hoist(
    geocoded_location.coordinates,
    latitude = list(2L),
    longitude = list(1L)
  ) |>
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
    )
  ) |>
  dplyr::select(
    fiscal_year,
    company_name,
    job_obligation_status,
    address = company_address,
    city = municipality,
    industry = business_industry,
    grant_amount:amount_leveraged,
    funding_source,
    latitude,
    longitude
  ) |>
  tidyr::drop_na() |>
  saveRDS(file = "decd_data_clean.RDS")

