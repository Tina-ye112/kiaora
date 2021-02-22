## code to prepare `DATASET` dataset goes here
library(tidyverse)
nzhousingprice <- get_property_auction_price(region = , district = , area = )

nzhousingprice <- filter(nzhousingprice, year(auction_dates) > 2017, bedrooms <= 13 | is.na(bedrooms), bathrooms <= 10 | is.na(bathrooms)) %>%
  mutate(
    region = replace(region, property_address == "Woolston, 46 Mackenzie Avenue ST7730", "Canterbury"),
    region = replace(region, property_address == "Fendalton, 39B Kotare Street PI65339", "Canterbury"),
    region = replace(region, property_address == "4 Glenbush Place, Birkenhead", "Auckland"),
    region = replace(region, property_address == "Sunnynook, 27 Lyford Crescent GL42583", "Auckland"),
    region = replace(region, property_address == "Papatoetoe, 23 Clendon Avenue HO3828", "Auckland"),
    district = replace(district, property_address == "17 Glasgow Crescent, Kaiti", "Gisborne"),
    district = replace(district, property_address == "Beach Haven, 3/2 McGlashen Place MJ45829", "North Shore City"),
    district = replace(district, property_address == "30 Arthur Street, Ellerslie", "Auckland City"),
    district = replace(district, property_address == "163 Bellevue Road", "Tauranga"),
    district = replace(district, property_address == "4 Glenbush Place, Birkenhead", "North Shore City"),
    district = replace(district, property_address == "13 Franklin Road, Freemans Bay", "Auckland City"),
    district = replace(district, property_address == "Sunnynook, 27 Lyford Crescent GL42583", "North Shore City"),
    district = replace(district, property_address == "Papatoetoe, 23 Clendon Avenue HO3828", "Manukau City"),
    district = replace(district, property_address == "38 Waimarie Street, St Heliers", "Auckland City"),
    auction_price = replace(auction_price, auction_price == 12017200001202, 720000),
    auction_price = replace(auction_price, auction_price == 240000270000, 255000),
    auction_price = replace(auction_price, auction_price == 2957, NA),
    auction_price = replace(auction_price, auction_price == 678391, NA)
  )

library(ggmap)
nzhousingprice_geocoded <- mutate(nzhousingprice,
  property_address2 = str_c(property_address, district, region, "New Zealand",
                            sep = ", ")
) %>%
  mutate_geocode(property_address2) %>%
  select(-property_address2)
geocoded_nz <- mutate(nzhousingprice_geocoded,
  lon = replace(lon, lon < 0, NA),
  lat = replace(lat, lat > 0, NA)
) %>%
  select(property_address, lon, lat)
nzpropertygeo <- geocoded_nz

usethis::use_data(nzhousingprice, overwrite = TRUE)
usethis::use_data(nzpropertygeo, overwrite = TRUE)
