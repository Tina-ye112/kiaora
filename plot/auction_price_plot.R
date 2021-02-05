install.packages("leaflet")
install.packages("zoo")
library(ggmap)
library(leaflet)
library(zoo)
library(stringr)

# map for auction property
register_google(key = )
filter(nzhousingprice,region %in% c("Auckland"),auction_price >=5000000) %>%
  mutate(property_address=str_c(property_address,district," Auckland"," New Zealand",sep = ",")) %>%
  mutate_geocode(property_address) -> geocoded
geocoded %>% leaflet() %>% addTiles() %>% addMarkers(label = geocoded$property_address)

# map for auction_price per region
add_month <- nzhousingprice
add_month <- mutate(add_month,auction_dates=as.yearmon(auction_dates))
dataset <- add_month %>%
  #filter(region %in% c("Auckland")) %>%
  group_by(auction_dates,region) %>%
  summarise(med=median(auction_price,na.rm = TRUE))
auckland_district <- filter(dataset,region %in% c("Auckland","Bay of Plenty"))
ggplot(auckland_district,aes(auction_dates,med))+geom_line(aes(color=region),size=1)+
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF"))
#map for counts per region
dataset_count <- add_month %>%
  #filter(region %in% c("Auckland")) %>%
  group_by(auction_dates,region) %>%
  summarise(counts=n())
auckland_district_count <- filter(dataset_count,region %in% c("Auckland","Bay of Plenty"))
ggplot(auckland_district_count,aes(auction_dates,counts))+geom_line(aes(color=region),size=1)+
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF"))
