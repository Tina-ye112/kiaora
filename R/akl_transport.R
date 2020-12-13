# use diff path to get data
get_akl <- function(api_key = NULL, path = NULL, query = list()) {
  stop_if_no_key(api_key)
  base_url <- "https://api.at.govt.nz/"
  connection <- GET(base_url,
                    path = path,
                    add_headers("Ocp-Apim-Subscription-Key" = api_key),
                    query = query
  )
  stop_for_status(connection,"get the data")
  cnt <- content(connection, as = "text")
  jsonlite::fromJSON(cnt)$response
}

# real time
get_real_time <- function(api_key = NULL, path = NULL) {
  res <- get_akl(api_key, path)
  tibble::as_tibble(res$entity)
}

#' Get Auckland bus agency
#'
#' @description Query Auckland bus agency
#'
#' @param api_key A string that contains your API key.
#'
#' @return A tibble
#' @export
get_akl_agency <- function(api_key = NULL) {
  # TODO: convert list from get_akl() to tibble
  get_akl(api_key = api_key, path = "v2/gtfs/agency")
}

get_akl_calendar_dates <- function(api_key = NULL) {
  get_akl(api_key = api_key, path = "v2/gtfs/calendarDate")
}

get_akl_calendars <- function(api_key = NULL) {
  get_akl(api_key = api_key, path = "v2/gtfs/calendar")
}

get_akl_routes <- function(api_key = NULL) {
  get_akl(api_key = api_key, path = "v2/gtfs/routes")
}

get_akl_stops <- function(api_key = NULL) {
  get_akl(api_key = api_key, path = "v2/gtfs/stops")
}

get_akl_trips <- function(api_key = NULL) {
  get_akl(api_key = api_key, path = "v2/gtfs/trips")
}

#BTF Timetable by short_name,route_ids and stop_code???
get_timetable_by_route_ids_stop_code_and_short_name <- function(api_key = NULL,
                                                                route_ids = NULL,
                                                                stop_code =NULL,
                                                                route_short_name =NULL) {
  if (all(is.null(route_ids), is.null(stop_code), is.null(route_short_name))) {
    stop("route_ids, stop_code and route_short_name are required")
  }
  path <-"v2/gtfs/btf/timetable"
  route_ids <- paste0(route_ids, collapse = ",")
  query <- list(route_ids = route_ids,
                stop_code = stop_code,
                route_short_name = route_short_name)
  res <- get_akl(api_key, path, query = query)
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

# get calender dates by service
get_calender_dates_by_service <- function(api_key = NULL, service_id = NULL) {
  if (is.null(service_id)) {
    stop("service_id is required")
  }
  path <- paste0("v2/gtfs/calendarDate/serviceId/", service_id)
  get_akl(api_key = api_key, path = path)
}

#get routes by search_string and route_types
get_routes_by_search_string_and_route_types <- function(api_key = NULL,
                                                       search_string = NULL,
                                                       route_types =NULL) {
  if (is.null(search_string)||is.null(route_types)) {
    stop("search_string and route_types are required")
  }
  path <-"v2/gtfs/btf/routes"
  query <- list(search_string=search_string,
                route_types = paste0(route_types, collapse = ","))
  res <- get_akl(api_key, path = path, query = query)
  tibble::as_tibble(res)
}

#get routes by location
get_routes_by_location <- function(api_key = NULL,
                                   lat = NULL,
                                   lng = NULL,
                                   distance = NULL) {
  if (is.null(lat)||is.null(lng)||is.null(distance)) {
    stop("lat, lng and distance are required")
  }
  path <-"v2/gtfs/routes/geosearch"
  query <- list(lat=lat, lng = lng, distance=distance)
  res <- get_akl(api_key, path = path, query = query)
  tibble::as_tibble(res)
}

#get routes by long name
get_routes_by_long_name <- function(api_key = NULL, route_long_name = NULL) {
  if (is.null(route_long_name)) {
    stop("route_long_name is required")
  }
  path <- paste0("v2/gtfs/routes/routeLongName/", route_long_name)
  get_akl_by_string(api_key = api_key, path = path)
}

#get routes by short name
get_routes_by_short_name <- function(api_key = NULL, route_short_name = NULL) {
  if (is.null(route_short_name)) {
    stop("route_short_name is required")
  }
  path <- paste0("v2/gtfs/routes/routeShortName/", route_short_name)
  get_akl(api_key = api_key, path = path)
}

#get routes by stop
get_routes_by_stop <- function(api_key = NULL, stop_id = NULL) {
  if (is.null(stop_id)) {
    stop("stop_id is required")
  }
  path <- paste0("v2/gtfs/routes/stopid/", stop_id)
  get_akl(api_key = api_key, path = path)
}

#get routes by route_id
get_routes_by_route_id <- function(api_key = NULL, route_id = NULL) {
  if (is.null(route_id)) {
    stop("route_id is required")
  }
  path <- paste0("v2/gtfs/routes/routeId/", route_id)
  get_akl(api_key = api_key, path = path)
}

#get routes by search_text
get_routes_by_search_text <- function(api_key = NULL, search_text = NULL) {
  if (is.null(search_text)) {
    stop("search_text is required")
  }
  path <- paste0("v2/gtfs/routes/search/", search_text)
  get_akl(api_key = api_key, path = path)
}

#get shape geometry by shape_id
get_shape_geometry_by_shape_id <- function(api_key = NULL, shape_id = NULL) {
  if (is.null(shape_id)) {
    stop("shape_id is required")
  }
  path <- paste0("v2/gtfs/shapes/geometry/", shape_id)
  get_akl(api_key = api_key, path = path)
}

#get shapes by shape_id
get_shapes_by_shape_id <- function(api_key = NULL, shape_id = NULL) {
  if (is.null(shape_id)) {
    stop("shape_id is required")
  }
  path <- paste0("v2/gtfs/shapes/shapeId/", shape_id)
  get_akl(api_key = api_key, path = path)
}

#get shapes by trip_id
get_shapes_by_trip_id <- function(api_key = NULL, trip_id = NULL) {
  if (is.null(trip_id)) {
    stop("trip_id is required")
  }
  path <- paste0("v2/gtfs/shapes/tripId/", trip_id)
  get_akl(api_key = api_key, path = path)
}

#get stop by stop_code
get_stop_by_stop_code <- function(api_key = NULL, stop_code = NULL) {
  if (is.null(stop_code)) {
    stop("stop_code is required")
  }
  path <- paste0("v2/gtfs/stops/stopCode/", stop_code)
  get_akl(api_key = api_key, path = path)
}

#get stop by stop_id
get_stop_by_stop_id <- function(api_key = NULL, stop_id = NULL) {
  if (is.null(stop_id)) {
    stop("stop_id is required")
  }
  path <- paste0("v2/gtfs/stops/stopId/", stop_id)
  get_akl(api_key = api_key, path = path)
}

#get stop by trip_id
get_stop_by_trip_id <- function(api_key = NULL, trip_id = NULL) {
  if (is.null(trip_id)) {
    stop("trip_id is required")
  }
  path <- paste0("v2/gtfs/stops/tripId/", trip_id)
  get_akl(api_key = api_key, path = path)
}

#get stop by trip from stop
get_stop_by_trip_from_stop <- function(api_key = NULL, trip_id = NULL,stop_id =NULL) {
  if (is.null(trip_id)||is.null(stop_id)) {
    stop("trip_id and stop_id are required")
  }
  path <- paste0("v2/gtfs/stops/tripId/", trip_id,"/from/",stop_id)
  get_akl(api_key = api_key, path = path)
}

#get info by stop_code
get_info_by_stop_code <- function(api_key = NULL, stop_code = NULL) {
  if (is.null(stop_code)) {
    stop("stop_code is required")
  }
  path <- paste0("v2/gtfs/stops/stopinfo/", stop_code)
  get_akl(api_key = api_key, path = path)
}

#get stop times by stop_id
get_stop_times_by_stop_id <- function(api_key = NULL, stop_id = NULL) {
  if (is.null(stop_id)) {
    stop("stop_id is required")
  }
  path <- paste0("v2/gtfs/stopTimes/stopId/", stop_id)
  get_akl(api_key = api_key, path = path)
}

#get stop times by trip_id
get_stop_times_by_trip_id <- function(api_key = NULL, trip_id = NULL) {
  if (is.null(trip_id)) {
    stop("trip_id is required")
  }
  path <- paste0("v2/gtfs/stopTimes/tripId/", trip_id)
  get_akl(api_key = api_key, path = path)
}

#get stop times by trip and sequence
get_stop_times_by_trip_and_sequence <- function(api_key = NULL, trip_id = NULL,stop_sequence =NULL) {
  if (is.null(trip_id)||is.null(stop_sequence)) {
    stop("trip_id and stop_sequence are required")
  }
  path <- paste0("v2/gtfs/stopTimes/tripId/", trip_id,"/stopSequence/",stop_sequence)
  get_akl(api_key = api_key, path = path)
}
#get stops through BTF search(route_ids)
get_stops_by_route_ids <- function(api_key = NULL, route_ids = NULL) {
  if (is.null(route_ids)) {
    stop("route_ids are required")
  }
  path <-"v2/gtfs/btf/stops"
  query <- list(route_ids = paste0(route_ids, collapse = ","))
  res <- get_akl(api_key, path = path, query = query)
  extract_stops <- res$stops
  tibble::tibble(isline = res$isline,extract_stops)
}

#get stops by location
get_stops_by_location <- function(api_key = NULL,
                                   lat = NULL,
                                   lng = NULL,
                                   distance = NULL) {
  if (is.null(lat)||is.null(lng)||is.null(distance)) {
    stop("lat, lng and distance are required")
  }
  path <-"v2/gtfs/stops/geosearch"
  query <- list(lat=lat, lng = lng, distance=distance)
  res <- get_akl(api_key, path = path, query = query)
  tibble::as_tibble(res)
}
#get stops by search_text
get_stops_by_search_text <- function(api_key = NULL, search_text = NULL) {
  if (is.null(search_text)) {
    stop("search_text is required")
  }
  path <- paste0("v2/gtfs/stops/search/", search_text)
  get_akl_by_string(api_key = api_key, path = path)
}
#get trips by trip_id
get_trips_by_trip_id <- function(api_key = NULL, trip_id = NULL) {
  if (is.null(trip_id)) {
    stop("trip_id is required")
  }
  path <- paste0("v2/gtfs/trips/tripId/", trip_id)
  get_akl(api_key = api_key, path = path)
}

#get trips by route
get_trips_by_route <- function(api_key = NULL, route_id = NULL) {
  if (is.null(route_id)) {
    stop("route_id is required")
  }
  path <- paste0("v2/gtfs/trips/routeid/", route_id)
  get_akl(api_key = api_key, path = path)
}

##### Realtime Transit Feed (GTFS)#####
#get combined feed??
get_combined_feed <- function(api_key = NULL) {
  get_real_time(api_key = api_key, path = "v2/public/realtime")
}

#get ferry positions
get_ferry_positions <- function(api_key = NULL) {
  get_akl(api_key = api_key, path = "v2/public/realtime/ferrypositions")
}



