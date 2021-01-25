install.packages("rvest")
install.packages("dplyr")
install.packages("lubridate")
install.packages("tidyverse")
install.packages("purrr")

library(rvest)
library(dplyr)
library(lubridate)
library(tidyverse)
library(purrr)

#get_one_page function
get_one_page <- function(url){
  page <- read_html(url)
  enclosing_nodes <-  html_nodes(page,'.padb-property-card')
  df <- map_dfr(enclosing_nodes,~list(
    property_address=html_text(html_node(.x,".address")),
    auction_price=html_text(html_node(.x, '.padb-property-value')),
    auction_dates=html_text(html_node(.x,".padb-auction-details"),trim = TRUE),
    bedrooms={if(length(html_text(html_node(.x,".padb-beds"))) == 0) NA else html_text(html_node(.x,".padb-beds"))},
    bathrooms={if(length(html_text(html_node(.x,".padb-baths"))) == 0) NA else html_text(html_node(.x,".padb-baths"))},
    car_parking={if(length(html_text(html_node(.x,".padb-parking"))) == 0) NA else html_text(html_node(.x,".padb-parking"))},
    rating_value={if(length(html_text(html_node(.x,".padb-property-rating-value , .padb-rating-date"))) == 0) NA else html_text(html_node(.x,".padb-property-rating-value , .padb-rating-date"),trim=TRUE)},
    rating_dates={if(length(html_text(html_node(.x,".padb-rating-date"))) == 0) NA else html_text(html_node(.x,".padb-rating-date"))})
  )
  df$auction_price <- as.numeric(gsub("[^[:digit:]]", "", df$auction_price))
  df$auction_dates <- dmy(df$auction_dates)
  df$rating_value <- lapply(df$rating_value, get_rating_value)
  df$rating_value <- as.numeric(gsub("[^[:digit:]]", "", df$rating_value))
  df$rating_dates <- my(df$rating_dates)
  df
}

#replace null with "-" function
replace_null <- function(region=NULL){
  if (is.null(region)){
    region="-"
  }
  region
}

#get_rating_value function
get_rating_value <- function(rating_value){
  str_split(rating_value," ")[[1]][3]
}

#get_property_auction_price function
get_property_auction_price <- function(region=NULL,district=NULL,area=NULL){
  num <- 1:625
  urls <- paste0("https://www.interest.co.nz/property/residential-auction-results?",
                 "region=",replace_space_with_20(replace_null(region)),
                 "&district=",replace_space_with_20(replace_null(district)),
                 "&area=",replace_space_with_20(replace_null(area)),
                 "&agency=-",
                 "&status=Sold&page=",num)
  bind_rows(lapply(urls, get_one_page))
}

get_property_auction_price(region ="Bay of Plenty" ,district = ,area = )

