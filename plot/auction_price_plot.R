# install.packages("leaflet")
# install.packages("zoo")
# install.packages("ggridges")
# devtools::install_github("phildonovan/nzcensr")
library(ggmap)
library(leaflet)
library(stringr)
library(lubridate)
library(ggridges)
library(kiaora)
library(tidyverse)
# library(nzcensr)
# library(sf)
#
# nz_simple <- st_simplify(regions, dTolerance = 1000) %>%
#   st_transform(crs = 2193)
#
# nzmap <- nzpropertygeo %>%
#   filter(lon > 160) %>%
#   st_as_sf(coords = c("lon", "lat"), crs = 2193)
#
# st_join(nz_simple, nzmap)
# ggplot() +
#   # geom_sf(data = nz_simple) +
#   geom_sf(data = nzmap)
#   # geom_point(aes(lon, lat), size = 0.3) +
#   geom_density2d()

nzpropertygeo %>%
  filter(lon > 160) %>%
  ggplot(aes(lon, lat)) +
  geom_point(size = 0.5) +
  geom_density2d()

# map for auction property
register_google(key = "")
filter(add_month, region %in% c("Auckland"), auction_price >= 5000000) %>%
  mutate(property_address = str_c(property_address, district, " Auckland", " New Zealand", sep = ",")) %>%
  mutate_geocode(property_address) -> geocoded
geocoded$level <- cut(geocoded$auction_price,
  breaks = c(5000000, 7000000, 9000000, 13000000), right = FALSE,
)
pal <- colorFactor(palette = c("blue", "red", "green"), domain = geocoded$level)
label <- paste(
  "Address:", geocoded$property_address, "<br>",
  "Price:", geocoded$auction_price
)
geocoded %>%
  leaflet() %>%
  addTiles() %>%
  addCircleMarkers(
    color = ~ pal(level),
    popup = label
  )

# map for auction_price per region
dataset <- nzhousingprice %>%
  mutate(
    group = ifelse(region == "Auckland", region, "Others"),
    auction_yrmth = zoo::as.yearmon(auction_dates)
  )
dataset_auction_price <- dataset %>%
  group_by(auction_yrmth, group) %>%
  summarise(med = median(auction_price, na.rm = TRUE))

dataset %>%
  ggplot(aes(auction_yrmth, auction_price)) +
  geom_boxplot(aes(group = auction_yrmth)) +
  facet_wrap(~ group, ncol = 1) +
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF"))

# plot for counts per region
dataset_count <- dataset %>%
  group_by(auction_yrmth, group) %>%
  summarise(counts = n())
ggplot(dataset_count, aes(auction_yrmth, counts)) +
  geom_line(aes(color = group), size = 1) +
  geom_point(aes(color = factor(group))) +
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF"))

# plot for counts of per year over months
dataset_month <- dataset %>%
  mutate(
    month = month(auction_dates, label = TRUE),
    year = as.factor(year(auction_dates))) %>%
  group_by(month, year) %>%
  summarise(counts = n())
ggplot(dataset_month, aes(month, counts, group = year, colour = year)) +
  geom_line(size = 1) +
  geom_point() +
  labs(x = "Month", colour = "Year") +
  theme(legend.position = "top") +
  scale_color_manual(values = c("#ffd080", "#ff6666", "#cc6600", "#660000"))

# plot for counts Auckland vs Others  over months
dataset_group <- dataset %>%
  mutate(month = month(auction_dates, label = TRUE),
         year = as.factor(year(auction_dates))) %>%
  group_by(month, year, group) %>%
  summarise(counts = n())
ggplot(dataset_group, aes(month, counts, group = year, colour = year)) +
  geom_line(size = 1) +
  geom_point() +
  labs(x = "Month", colour = "Year") +
  theme(legend.position = "top") +
  scale_color_manual(values = c("#ffd080", "#ff6666", "#cc6600", "#660000")) +
  facet_wrap(~ group, scales = "free_y", ncol = 1)

# plot for counts per day
dataset_day <- dataset %>%
  mutate(
  year = year(auction_dates),
  day = wday(auction_dates, label = TRUE, week_start = 1)
) %>%
  group_by(day, group) %>%
  summarise(counts = n())
ggplot(dataset_day, aes(day, counts)) +
  geom_col(aes(fill = group), position = position_dodge(1))

# heatmap
group_by(dataset, bedrooms, bathrooms) %>%
  summarise(counts = n()) %>%
  ggplot(aes(factor(bedrooms), factor(bathrooms))) +
  geom_tile(aes(fill = counts), colour = "white") +
  geom_text(aes(label = counts), colour = "white") +
  scale_fill_viridis_c(breaks = seq(0, 4000, by = 500)) +
  labs(x = "Bedrooms", y = "Bathrooms")

# box plot
ggplot(dataset, aes(group, auction_price)) +
  geom_boxplot()

# Auckland district density plot
dataset_auckland <- dataset %>%
  mutate(year = year(auction_dates)) %>%
  filter(region == "Auckland")
ggplot(dataset_auckland, aes(auction_price, district, fill = district)) +
  geom_density_ridges() +
  theme_ridges() +
  xlim(c(0, 6e+06))

# Auckland district line plot
dataset_auckland_price <- dataset_auckland %>%
  filter(auction_price < 9e+06) %>%
  group_by(district, year) %>%
  summarise(med = median(auction_price, na.rm = TRUE))
ggplot(dataset_auckland_price, aes(year, med, group = district)) +
  geom_line(aes(color = district), size = 1) +
  geom_point(aes(color = district)) +
  labs(x = "Auction Dates", colour = "District") +
  theme(legend.position = "top")
