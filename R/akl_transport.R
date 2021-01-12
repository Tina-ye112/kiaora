# use diff path to get data
get_akl <- function(path = NULL, query = list()) {
  api_key <- Sys.getenv("AKL_TRANS_API")
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
get_real_time <- function(path = NULL) {
  res <- get_akl(path)
  tibble::as_tibble(res$entity)
}

#' Get Auckland bus agency
#'
#' @description Query Auckland bus agency
#'
#' @return A tibble
#' @export
#' @examples
#' get_akl_agency()
get_akl_agency <- function() {
  res <- get_akl( path = "v2/gtfs/agency")
  tibble::as_tibble(res)
}

#' Get calendar dates
#'
#' @description Query calendar dates
#'
#' @return A tibble
#' @export
#' @examples
#' get_akl_calendar_dates()
get_akl_calendar_dates <- function() {
  res <- get_akl(path = "v2/gtfs/calendarDate")
  tibble::as_tibble(res)
}

#' Get calendars
#'
#' @description Query calendars
#'
#' @return A tibble
#' @export
#' @examples
#' get_akl_calendars()
get_akl_calendars <- function() {
  res <- get_akl(path = "v2/gtfs/calendar")
  tibble::as_tibble(res)
}

#' Get Auckland routes
#'
#' @description Query Auckland routes
#'
#' @return A tibble
#' @export
#' @examples
#' get_akl_routes()
get_akl_routes <- function() {
  res <- get_akl(path = "v2/gtfs/routes")
  tibble::as_tibble(res)
}

#' Get Auckland stops
#'
#' @description Query Auckland stops
#'
#' @return A tibble
#' @export
#' @examples
#' get_akl_stops()
get_akl_stops <- function() {
  res <- get_akl(path = "v2/gtfs/stops")
  tibble::as_tibble(res)
}

#' Get Auckland trips
#'
#' @description Query Auckland trips
#'
#' @return A tibble
#' @export
#' @examples
#' get_akl_trips()
get_akl_trips <- function() {
  res <- get_akl(path = "v2/gtfs/trips")
  tibble::as_tibble(res)
}

#' Get timetable by short_name,route_ids and stop_code
#'
#' @description Query timetable
#' @param route_ids string comma separated route ids
#' @param stop_code string stop code
#' @param route_short_name string route short name like (STH, 923)
#' @return A tibble
#' @export
#' @examples
#' get_timetable_by_route_ids_stop_code_and_short_name(route_ids = c("90111-20201205123725_v95.82,05363-20201205123725_v95.82"),
#'                                                                   stop_code = "3637",
#'                                                                   route_short_name = "901")
get_timetable_by_route_ids_stop_code_and_short_name <- function(route_ids = NULL,
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
  res <- get_akl(path, query = query)
  tibble::as_tibble(res)
}

#' Get calendar by service id
#'
#' @description Query calendar by service id
#' @param service_id string service id
#' @return A tibble
#' @export
#' @examples
#' get_calender_by_service(service_id = "467236433-20201222141234_v95.107")
# get calender by service
get_calender_by_service <- function(service_id = NULL) {
  if (is.null(service_id)) {
    stop("service_id is required")
  }
  path <- paste0("v2/gtfs/calendar/serviceId/", service_id)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get calendar dates by service id
#'
#' @description Query calendar dates by service id
#' @param service_id string service id
#' @return A tibble
#' @export
#' @examples
#' get_calender_dates_by_service(service_id = "467236433-20201222141234_v95.107")
# get calender dates by service
get_calender_dates_by_service <- function(service_id = NULL) {
  if (is.null(service_id)) {
    stop("service_id is required")
  }
  path <- paste0("v2/gtfs/calendarDate/serviceId/", service_id)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get routes by search_string and route_types
#'
#' @description Query routes by search_string and route_types
#' @param search_string string
#' @param route_types string
#' @return A tibble
#' @export
#' @examples
#' get_routes_by_search_string_and_route_types(search_string = "Albany Station",
#'                                             route_types = c("3","2"))
#get routes by search_string and route_types
get_routes_by_search_string_and_route_types <- function(search_string = NULL,
                                                        route_types =NULL) {
  if (is.null(search_string)||is.null(route_types)) {
    stop("search_string and route_types are required")
  }
  path <-"v2/gtfs/btf/routes"
  query <- list(search_string=search_string,
                route_types = paste0(route_types, collapse = ","))
  res <- get_akl(path = path, query = query)
  tibble::as_tibble(res)
}

#' Get routes by location
#'
#' @description Query routes by latitude of the position,
#'              longitude of the position,and search radius
#' @param lat string latitude of the position
#' @param lng string longitude of the position
#' @param distance string search radius
#' @return A tibble
#' @export
#' @examples
#' get_routes_by_location(lat = "-37.06429",
#'                        lng = "174.94611",
#'                        distance = "10")
#get routes by location
get_routes_by_location <- function(lat = NULL,
                                   lng = NULL,
                                   distance = NULL) {
  if (is.null(lat)||is.null(lng)||is.null(distance)) {
    stop("lat, lng and distance are required")
  }
  path <-"v2/gtfs/routes/geosearch"
  query <- list(lat=lat, lng = lng, distance=distance)
  res <- get_akl(path = path, query = query)
  tibble::as_tibble(res)
}

#' Get routes by long name
#'
#' @description Query routes by long name
#' @param route_long_name string name of the rout
#' @return A tibble
#' @export
#' @examples
#' get_routes_by_long_name(route_long_name = "Mangere Town Centre To Otahuhu Station Via Tidal Road")
#get routes by long name
get_routes_by_long_name <- function(route_long_name = NULL) {
  if (is.null(route_long_name)) {
    stop("route_long_name is required")
  }
  route_long_name <- replace_space_with_20(route_long_name)
  path <- paste0("v2/gtfs/routes/routeLongName/", route_long_name)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get routes by short name
#'
#' @description Query routes by short name
#' @param route_short_name string name of the route
#' @return A tibble
#' @export
#' @examples
#' get_routes_by_short_name(route_short_name = "326")
#get routes by short name
get_routes_by_short_name <- function(route_short_name = NULL) {
  if (is.null(route_short_name)) {
    stop("route_short_name is required")
  }
  path <- paste0("v2/gtfs/routes/routeShortName/", route_short_name)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get routes by stop
#'
#' @description Query routes by stop id
#' @param stop_id string stop to search
#' @return A tibble
#' @export
#' @examples
#' get_routes_by_stop(stop_id ="1369-20201221160823_v95.106" )
#get routes by stop
get_routes_by_stop <- function(stop_id = NULL) {
  if (is.null(stop_id)) {
    stop("stop_id is required")
  }
  path <- paste0("v2/gtfs/routes/stopid/", stop_id)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get routes by routes id
#'
#' @description Query routes by routes id
#' @param route_id string identifier of the route
#' @return A tibble
#' @export
#' @examples
#' get_routes_by_route_id(route_id = "84303-20201221160823_v95.106")
#get routes by route_id
get_routes_by_route_id <- function(route_id = NULL) {
  if (is.null(route_id)) {
    stop("route_id is required")
  }
  path <- paste0("v2/gtfs/routes/routeId/", route_id)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}


#' Get routes by search text
#'
#' @description Query routes by search text
#' @param search_text string text to search
#' @return A tibble
#' @export
#' @examples
#' get_routes_by_search_text(search_text = "Albany")
#get routes by search_text
get_routes_by_search_text <- function(search_text = NULL) {
  if (is.null(search_text)) {
    stop("search_text is required")
  }
  path <- paste0("v2/gtfs/routes/search/", search_text)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get shape geometry by shape id
#'
#' @description Query shape geometry by shape id
#' @param shape_id string identifier of the shape
#' @return A tibble
#' @export
#' @examples
#' get_shape_geometry_by_shape_id(shape_id = "1192-20201221160823_v95.106")
#get shape geometry by shape_id
get_shape_geometry_by_shape_id <- function(shape_id = NULL) {
  if (is.null(shape_id)) {
    stop("shape_id is required")
  }
  path <- paste0("v2/gtfs/shapes/geometry/", shape_id)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get shapes by shape id
#'
#' @description Query shapes by shape id
#' @param shape_id string identifier of the shape
#' @return A tibble
#' @export
#' @examples
#' get_shapes_by_shape_id(shape_id = "1192-20201221160823_v95.106")
#get shapes by shape_id
get_shapes_by_shape_id <- function(shape_id = NULL) {
  if (is.null(shape_id)) {
    stop("shape_id is required")
  }
  path <- paste0("v2/gtfs/shapes/shapeId/", shape_id)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get shapes by trip id
#'
#' @description Query shapes by trip id
#' @param trip_id string identifier of the trip
#' @return A tibble
#' @export
#' @examples
#' get_shapes_by_trip_id(trip_id = "51100221657-20201221160823_v95.106")
#get shapes by trip_id
get_shapes_by_trip_id <- function(trip_id = NULL) {
  if (is.null(trip_id)) {
    stop("trip_id is required")
  }
  path <- paste0("v2/gtfs/shapes/tripId/", trip_id)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get stop by stop code
#'
#' @description Query stop by stop code
#' @param stop_code string code of the stop
#' @return A tibble
#' @export
#' @examples
#' get_stop_by_stop_code(stop_code ="97")
#get stop by stop_code
get_stop_by_stop_code <- function(stop_code = NULL) {
  if (is.null(stop_code)) {
    stop("stop_code is required")
  }
  path <- paste0("v2/gtfs/stops/stopCode/", stop_code)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get stop by stop id
#'
#' @description Query stop by stop id
#' @param stop_id string identifier of the stop
#' @return A tibble
#' @export
#' @examples
#' get_stop_by_stop_id(stop_id = "1369-20201221160823_v95.106")
#get stop by stop_id
get_stop_by_stop_id <- function(stop_id = NULL) {
  if (is.null(stop_id)) {
    stop("stop_id is required")
  }
  path <- paste0("v2/gtfs/stops/stopId/", stop_id)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get stop by trip id
#'
#' @description Query stop by trip id
#' @param trip_id string trip unique identifier
#' @return A tibble
#' @export
#' @examples
#' get_stop_by_trip_id(trip_id = "51100221657-20201221160823_v95.106")
#get stop by trip_id
get_stop_by_trip_id <- function(trip_id = NULL) {
  if (is.null(trip_id)) {
    stop("trip_id is required")
  }
  path <- paste0("v2/gtfs/stops/tripId/", trip_id)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get stop by Trip from stop
#'
#' @description Query stop by Trip from stop
#' @param trip_id string trip unique identifier
#' @param stop_id string stop unique identifier
#' @return A tibble
#' @export
#' @examples
#' get_stop_by_trip_from_stop(trip_id = "51100221657-20201221160823_v95.106",
#'                            stop_id = "0140-20201221160823_v95.106")
#get stop by trip from stop
get_stop_by_trip_from_stop <- function(trip_id = NULL,stop_id =NULL) {
  if (is.null(trip_id)||is.null(stop_id)) {
    stop("trip_id and stop_id are required")
  }
  path <- paste0("v2/gtfs/stops/tripId/", trip_id,"/from/",stop_id)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get stop info by stop code
#'
#' @description Query stop info by stop code
#' @param stop_code string code of the stop
#' @return A tibble
#' @export
#' @examples
#' get_info_by_stop_code(stop_code = "1371")
#get info by stop_code
get_info_by_stop_code <- function(stop_code = NULL) {
  if (is.null(stop_code)) {
    stop("stop_code is required")
  }
  path <- paste0("v2/gtfs/stops/stopinfo/", stop_code)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get stop times by stop id
#'
#' @description Query stop times by stop id
#' @param stop_id string stop id
#' @return A tibble
#' @export
#' @examples
#' get_stop_times_by_stop_id(stop_id = "1369-20201221160823_v95.106")
#get stop times by stop_id
get_stop_times_by_stop_id <- function(stop_id = NULL) {
  if (is.null(stop_id)) {
    stop("stop_id is required")
  }
  path <- paste0("v2/gtfs/stopTimes/stopId/", stop_id)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get stop times by trip id
#'
#' @description Query stop times by trip id
#' @param trip_id string trip id
#' @return A tibble
#' @export
#' @examples
#' get_stop_times_by_trip_id(trip_id = "465203730-20201221160823_v95.106")
#get stop times by trip_id
get_stop_times_by_trip_id <- function(trip_id = NULL) {
  if (is.null(trip_id)) {
    stop("trip_id is required")
  }
  path <- paste0("v2/gtfs/stopTimes/tripId/", trip_id)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get stop times by trip and sequence
#'
#' @description Query stop times by trip id and sequence
#' @param trip_id string trip id
#' @param stop_sequence integer Format - int64. stop sequence
#' @return A tibble
#' @export
#' @examples
#' get_stop_times_by_trip_and_sequence(trip_id = "465203730-20201221160823_v95.106",
#'                                     stop_sequence = "1")
#get stop times by trip and sequence
get_stop_times_by_trip_and_sequence <- function(trip_id = NULL,stop_sequence =NULL) {
  if (is.null(trip_id)||is.null(stop_sequence)) {
    stop("trip_id and stop_sequence are required")
  }
  path <- paste0("v2/gtfs/stopTimes/tripId/", trip_id,"/stopSequence/",stop_sequence)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get stops by route ids
#'
#' @description Query stops by route ids
#' @param route_ids string comma separated list of route ids
#' @return A tibble
#' @export
#' @examples
#' get_stops_by_route_ids(route_ids = c("06259-20201126121446_v95.73,32601-20201205123725_v95.82"))
#get stops through BTF search(route_ids)
get_stops_by_route_ids <- function(route_ids = NULL) {
  if (is.null(route_ids)) {
    stop("route_ids are required")
  }
  path <-"v2/gtfs/btf/stops"
  query <- list(route_ids = paste0(route_ids, collapse = ","))
  res <- get_akl(path = path, query = query)
  extract_stops <- res$stops
  tibble::tibble(isline = res$isline,extract_stops)
}

#' Get stops by location
#'
#' @description Query stops by location
#' @param lat string latitude of the position
#' @param lng string longitude of the position
#' @param distance string search radiu
#' @return A tibble
#' @export
#' @examples
#' get_stops_by_location(lat = "-37.06429",
#'                       lng = "174.94611",
#'                       distance = "10")
#get stops by location
get_stops_by_location <- function(lat = NULL,
                                  lng = NULL,
                                  distance = NULL) {
  if (is.null(lat)||is.null(lng)||is.null(distance)) {
    stop("lat, lng and distance are required")
  }
  path <-"v2/gtfs/stops/geosearch"
  query <- list(lat=lat, lng = lng, distance=distance)
  res <- get_akl(path = path, query = query)
  tibble::as_tibble(res)
}

#' Get stops by search text
#'
#' @description Query stops by search text
#' @param search_text string search text to find stops
#' @return A tibble
#' @export
#' @examples
#' get_stops_by_search_text(search_text = "Hinemoa St")
#get stops by search_text
get_stops_by_search_text <- function(search_text = NULL) {
  if (is.null(search_text)) {
    stop("search_text is required")
  }
  search_text <- replace_space_with_20(search_text)
  path <- paste0("v2/gtfs/stops/search/", search_text)
  tibble::as_tibble(get_akl(path = path))
}

#' Get trips by trip
#'
#' @description Query trips by trip id
#' @param trip_id string trip id
#' @return A tibble
#' @export
#' @examples
#' get_trips_by_trip_id(trip_id = "465203730-20201221160823_v95.106")
#get trips by trip_id
get_trips_by_trip_id <- function(trip_id = NULL) {
  if (is.null(trip_id)) {
    stop("trip_id is required")
  }
  path <- paste0("v2/gtfs/trips/tripId/", trip_id)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

#' Get trips by route
#'
#' @description Query trips by route id
#' @param route_id string route id
#' @return A tibble
#' @export
#' @examples
#' get_trips_by_route(route_id = "840007-20201221160823_v95.106")
#get trips by route
get_trips_by_route <- function(route_id = NULL) {
  if (is.null(route_id)) {
    stop("route_id is required")
  }
  path <- paste0("v2/gtfs/trips/routeid/", route_id)
  res <- get_akl(path = path)
  tibble::as_tibble(res)
}

##### Realtime Transit Feed (GTFS)#####
#get combined feed??
get_combined_feed <- function() {
  get_real_time(path = "v2/public/realtime")
}

#get ferry positions
get_ferry_positions <- function(api_key = NULL) {
  get_akl(api_key = api_key, path = "v2/public/realtime/ferrypositions")
}

#####stats open data######
base_url <- "https://api.stats.govt.nz"
path <- "odata/v1/Covid-19Indicators"
connection <- GET(base_url,
                  path = path,
                  add_headers("Ocp-Apim-Subscription-Key" = "")

)
stop_for_status(connection,"get the data")
cnt <- content(connection, as = "text")
jsonlite::fromJSON(cnt)$value

####https://data.mfe.govt.nz/####
base_url <-"https://data.mfe.govt.nz"
path <- "services/query/v1/vector.json"
query <- list(key="",
              layer="51845",
              x="121.1875777343931",
              y="25.25763028477236",
              max_results="3",
              geometry="true",
              with_field_names="true",
              radius="10000")
connection <- GET(base_url,
                  path=path,
                  query=query)
stop_for_status(connection,"get the data")
cnt <- content(connection, as = "text")
jsonlite::fromJSON(cnt)
