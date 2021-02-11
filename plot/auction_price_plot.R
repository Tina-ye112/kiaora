#install.packages("leaflet")
#install.packages("zoo")
#install.packages("ggridges")
library(ggmap)
library(leaflet)
library(zoo)
library(stringr)
library(lubridate)
library(ggridges)



add_month <- mutate(nzhousingprice_clear, auction_dates = as.yearmon(auction_dates))
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
dataset <- add_month %>%
  mutate(group = ifelse(region == "Auckland", "Auckland", "Others")) %>%
  group_by(auction_dates, group)
dataset_auction_price <- summarise(dataset, med = median(auction_price, na.rm = TRUE))
ggplot(dataset_auction_price, aes(auction_dates, med)) +
  geom_line(aes(color = group), size = 1) +
  geom_point(aes(color = factor(group))) +
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF"))

# plot for counts per region
dataset_count <- summarise(dataset, counts = n())
ggplot(dataset_count, aes(auction_dates, counts)) +
  geom_line(aes(color = group), size = 1) +
  geom_point(aes(color = factor(group))) +
  scale_color_manual(values = c("#0073C2FF", "#EFC000FF"))

# plot for counts of per year over months
dataset_month <- mutate(dataset, month = month(auction_dates), year = year(auction_dates)) %>%
  group_by(month, year) %>%
  summarise(counts = n())
ggplot(dataset_month, aes(factor(month), counts, group = factor(year))) +
  geom_line(aes(color = factor(year)), size = 1) +
  geom_point(aes(color = factor(year))) +
  labs(x = "Month", colour = "Year") +
  theme(legend.position = "top") +
  scale_color_manual(values = c("#ffd080", "#ff6666", "#cc6600", "#660000"))

# plot for counts Auckland vs Others  over months
dataset_group <- mutate(dataset, month = month(auction_dates), year = year(auction_dates)) %>%
  group_by(month, year, group) %>%
  summarise(counts = n())
ggplot(dataset_group, aes(factor(month), counts, group = factor(year))) +
  geom_line(aes(color = factor(year)), size = 1) +
  geom_point(aes(color = factor(year))) +
  labs(x = "Month", colour = "Year") +
  theme(legend.position = "top") +
  scale_color_manual(values = c("#ffd080", "#ff6666", "#cc6600", "#660000")) +
  facet_wrap(~group)

# plot for counts per day
dataset_day <- mutate(nzhousingprice_clear, year = year(auction_dates), day = factor(weekdays(auction_dates),
  levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
)) %>%
  group_by(day) %>%
  summarise(counts = n())
ggplot(dataset_day, aes(day, counts)) +
  geom_bar(aes(color = day, fill = day),
    stat = "identity", position = position_dodge(0.8),
    width = 0.7
  )



# heatmap
group_by(add_month, bedrooms, bathrooms) %>%
  summarise(counts = n()) %>%
  ggplot(aes(factor(bedrooms), factor(bathrooms))) +
  geom_tile(aes(fill = counts)) +
  labs(x = "Bedrooms", y = "Bathrooms")

# box plot

ggplot(dataset, aes(factor(group), auction_price)) +
  geom_boxplot()

# Auckland district density plot
dataset_auckland <- filter(nzhousingprice_clear, !is.na(auction_price), year(auction_dates) == 2020, region == "Auckland")
ggplot(dataset_auckland, aes(auction_price, district, fill = district)) +
  geom_density_ridges() +
  theme_ridges()

# Auckland district line plot
dataset_auckland_price <- filter(add_month, region == "Auckland") %>%
  group_by(district, auction_dates) %>%
  summarise(med = median(auction_price, na.rm = TRUE))
ggplot(dataset_auckland_price, aes(auction_dates, med, group = district)) +
  geom_line(aes(color = district), size = 1) +
  geom_point(aes(color = district)) +
  labs(x = "Auction Dates", colour = "District") +
  theme(legend.position = "top") +
  facet_wrap(~district)
