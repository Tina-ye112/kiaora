# get_one_page function
get_one_page <- function(url) {
  auction_price <- auction_dates <- bedrooms <- bathrooms<-
  car_parking <- rating_value <- rating_dates <- NULL
  page <- read_html(url)
  enclosing_nodes <- html_nodes(page, ".padb-property-card")
  df <- map_dfr(enclosing_nodes, ~ list(
    region = get_html_text(.x, ".region-district"),
    district = get_html_text(.x, ".region-district"),
    property_address = get_html_text(.x, ".address"),
    auction_price = get_html_text(.x, ".padb-property-value"),
    auction_dates = get_html_text(.x, ".padb-auction-details"),
    bedrooms = replace_blank_with_na(.x, ".padb-beds"),
    bathrooms = replace_blank_with_na(.x, ".padb-baths"),
    car_parking = replace_blank_with_na(.x, ".padb-parking"),
    rating_value = replace_blank_with_na(.x, ".padb-property-rating-value , .padb-rating-date"),
    rating_dates = replace_blank_with_na(.x, ".padb-rating-date")
  ))
  df <- mutate(
    df,
    region = na_if(sub(",.*","",region),"-"),
    district = na_if(sub(".*, ","",district),"-"),
    auction_price = as.numeric(gsub("[^[:digit:]]", "", auction_price)),
    auction_dates = dmy(auction_dates),
    bedrooms = as.numeric(bedrooms),
    bathrooms = as.numeric(bathrooms),
    car_parking = as.numeric(car_parking),
    rating_value = as.numeric(gsub("[^[:digit:]]", "", map(rating_value, get_rating_value))),
    rating_dates = my(rating_dates)
  )
  df
}



# get_rating_value function
get_rating_value <- function(rating_value) {
  str_split(rating_value, " ")[[1]][3]
}

#' Get property auction price
#'
#' @description Query auction price and other information for NZ property
#'
#' @param region string e.g.,Auckland
#' @param district string e.g.,Auckland City
#' @param area string e.g.,One Tree Hill
#' @return A tibble
#' @export
#' @examples
#' get_property_auction_price(region = "Northland", district = , area = )
#' # get_property_auction_price function
get_property_auction_price <- function(region = NULL, district = NULL, area = NULL) {
  num <- 1:ceiling(get_number_of_results(region = region) / 25)
  urls <- paste0(
    "https://www.interest.co.nz/property/residential-auction-results?",
    "region=", replace_space_with_20(replace_null(region)),
    "&district=", replace_space_with_20(replace_null(district)),
    "&area=", replace_space_with_20(replace_null(area)),
    "&agency=-",
    "&status=Sold&page=", num
  )
  bind_rows(map(urls, get_one_page))
}

# replace null with "-" function
replace_null <- function(region = NULL) {
  if (is.null(region)) {
    return(region <- "-")
  }
  region
}

# get_number_of_results function
get_number_of_results <- function(region = NULL) {
  if (is.null(region)) {
    return(get_number(replace_null(region)))
  }
  get_number(replace_space_with_20(region))
}

# get_number function
get_number <- function(region) {
  num_url <- paste0(
    "https://www.interest.co.nz/property/residential-auction-results?region=",
    region, "&district=-&area=-&agency=-&status=Sold"
  )
  num_page <- read_html(num_url)
  results <- html_text(html_node(num_page, "#padb-query-message"))
  number <- as.numeric(gsub("[^[:digit:]]", "", results))
  return(number)
}


# get_html_text function
get_html_text <- function(x, y) {
  html_text(html_node(x, y), trim = TRUE)
}

# replace blank with na function
replace_blank_with_na <- function(x, y) {{ if (length(get_html_text(x, y)) == 0) NA else get_html_text(x, y) }}
