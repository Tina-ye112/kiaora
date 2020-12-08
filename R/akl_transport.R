#' Get Auckland bus agency
#'
#' @description Query Auckland bus agency
#'
#' @param api_key A string that contains your API key.
#'
#' @return A tibble
#' @export
get_akl_agency <- function(api_key = NULL) {
  get_akl(api_key = api_key, path = "v2/gtfs/agency")
}

# use diff path to get Calendar Dates, Calendars, Routes, Stops, Trips
get_akl <- function(api_key = NULL, path = NULL) {
  stop_if_no_key(api_key)
  base_url <- "https://api.at.govt.nz/"
  connection <- GET(base_url,
    path = path,
    add_headers("Ocp-Apim-Subscription-Key" = api_key)
  )
  cnt <- content(connection, as = "text")
  res <- jsonlite::fromJSON(cnt)$response
  tibble::as_tibble(res)
}

# get calender by service
get_calender_by_service <- function(api_key = NULL, service_id = NULL) {
  if (is.null(service_id)) {
    stop("service_id is required")
  }
  path <- paste0("v2/gtfs/calendar/serviceId/", service_id)
  get_akl(api_key = api_key, path = path)
}

#get calender dates by service
get_calender_dates_by_service <- function(api_key = NULL, service_id = NULL) {
  if (is.null(service_id)) {
    stop("service_id is required")
  }
  path <- paste0("v2/gtfs/calendarDate/serviceId/", service_id)
  get_akl(api_key = api_key, path = path)
}
