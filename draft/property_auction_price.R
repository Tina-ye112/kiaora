install.packages("rvest")
install.packages("dplyr")
install.packages("lubridate")
install.packages("tidyverse")

library(rvest)
library(dplyr)
library(lubridate)
library(tidyverse)

get_property_auction_price <- function(region,district,area,agency){
  table_new <- data.frame()
  df <- data.frame()
  i=1
  while (i<20) {
    property_url <- paste0("https://www.interest.co.nz/property/residential-auction-results?",
                           "region=",replace_space_with_20(region),
                           "&district=",replace_space_with_20(district),
                           "&area=",replace_space_with_20(area),
                           "&agency=",agency,
                           "&status=Sold&page=",i)
    page <- read_html(property_url)
    table_new <- data.frame(address = html_text(html_nodes(page,".address")),
                            dates = html_text(html_nodes(page,".padb-auction-details")),
                            price = html_text(html_nodes(page,".padb-property-value")),
                            stringsAsFactors = FALSE)
    df <- rbind(df,table_new)
    i=i+1
  }
  df$price <- sub(".*: ","",df$price)
  df$price <- sub(" .*","",df$price)
  df$price <- suppressWarnings(as.numeric(gsub('[$,]','',df$price)))
  df <- na.omit(df)
  df$dates <- sub(".*, ","",df$dates)
  df$dates <- gsub("'","",df$dates)
  df$dates <- dmy(df$dates)
  tibble::as_tibble(df)
}



