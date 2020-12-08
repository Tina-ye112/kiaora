#' Get Auckland bus agency
#'
#' @description Query Auckland bus agency
#'
#' @param api_key A string that contains your API key.
#'
#' @return A tibble
#' @export
#'
get_akl_agency <- function(api_key = NULL) {
  if (is.null(api_key)) {
    stop("api_key is required")
  }
  base_url <- "https://api.at.govt.nz/"
  path <- "v2/gtfs/agency"
  my_raw_result <- GET(base_url,
    path = path,
    add_headers("Ocp-Apim-Subscription-Key" = api_key)
  )
  cnt <- content(my_raw_result, as = "text")
  res <- jsonlite::fromJSON(cnt)$response
  tibble::as_tibble(res)
}

#check if there is api_key function
stop_if_no_key <- function(api_key=NULL){
  if (is.null(api_key)){
    stop("api_key is required")
  }
}

# use diff path to get Calendar Dates, Calendars, Routes, Stops, Trips
get_akl <- function(api_key = NULL, path = NULL) {
  if (is.null(api_key)) {
    stop()
  }
  base_url <- "https://api.at.govt.nz/"
  path <- path
  my_raw_result <- GET(base_url,
    path = path,
    add_headers("Ocp-Apim-Subscription-Key" = api_key)
  )
  cnt <- content(my_raw_result, as = "text")
  res <- jsonlite::fromJSON(cnt)$response
  tibble::as_tibble(res)
}

# get calender by service
get_calender_by_service <- function(api_key = NULL, service_id = NULL) {
  stop_if_no_key(api_key=api_key)
  if (is.null(service_id)) {
    stop("service_id is required")
  }
    base_url <- "https://api.at.govt.nz/"
    path <- paste0("v2/gtfs/calendar/serviceId/", service_id)
    my_filter_result <- GET(base_url,
      path = path,
      add_headers("Ocp-Apim-Subscription-Key" = api_key)
    )
    cnt <- content(my_filter_result, as = "text")
    res <- jsonlite::fromJSON(cnt)$response
    tibble::as_tibble(res)
}

#get calender dates by service
get_calender_dates_by_service <- function(api_key = NULL, service_id = NULL) {
  stop_if_no_key(api_key=api_key)
  if (is.null(service_id)) {
    stop("service_id is required")
  }
  base_url <- "https://api.at.govt.nz/"
  path <- paste0("v2/gtfs/calendarDate/serviceId/", service_id)
  my_filter_result <- GET(base_url,
                          path = path,
                          add_headers("Ocp-Apim-Subscription-Key" = api_key)
  )
  cnt <- content(my_filter_result, as = "text")
  res <- jsonlite::fromJSON(cnt)$response
  tibble::as_tibble(res)
}
