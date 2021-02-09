#install.packages("leaflet")
#install.packages("zoo")
library(ggmap)
library(leaflet)
library(zoo)
library(stringr)
library(lubridate)

add_month <- nzhousingprice
add_month <- mutate(add_month, auction_dates = as.yearmon(auction_dates))
add_month <- mutate(add_month,auction_price =replace(auction_price,auction_price== 12017200001202 , 720000),
                              auction_price = replace(auction_price,auction_price== 240000270000 ,255000),
                              auction_price = replace(auction_price,auction_price== 2957, 2900000),
                              auction_price = replace(auction_price,auction_price==678391 ,6780000))
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
  group_by(auction_dates, group) %>%
  filter(group %in% c("Auckland", "Others") & auction_dates != "Jul 2016"
  & auction_dates != "Jul 2017"
  & auction_dates != "Sep 2017")
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

# plot for counts per region  over months
dataset_month <- mutate(dataset, month = month(auction_dates), year = year(auction_dates)) %>%
  group_by(month, year) %>%
  summarise(counts = n())
ggplot(dataset_month, aes(factor(month), counts, group = factor(year))) +
  geom_line(aes(color = factor(year)), size = 1) +
  geom_point(aes(color = factor(year))) +
  labs(x = "Month", colour = "Year") +
  theme(legend.position = "top") +
  scale_color_manual(values = c("#ffd080", "#ff6666", "#cc6600", "#660000"))

# plot for counts weekday v.s weekend
dataset_day <- mutate(nzhousingprice, year = year(auction_dates), day = weekdays(auction_dates)) %>%
  mutate(group = ifelse(day %in% c("Sunday", "Saturday"), "weekend", "weekday")) %>%
  group_by(group, year) %>%
  summarise(counts = n()) %>%
  filter(year != "2016"
  & year != "2017")
ggplot(dataset_day, aes(factor(year), counts)) +
  geom_bar(aes(color = group, fill = group),
    stat = "identity", position = position_dodge(0.8),
    width = 0.7
  ) +
  scale_color_manual(values = c("#ffd080", "#ff6666")) +
  scale_fill_manual(values = c("#ffd080", "#ff6666")) +
  geom_text(aes(label = counts, group = group),
    position = position_dodge(0.8),
    vjust = -0.3, size = 3.5
  )



# heatmap
filter(dataset, !is.na(auction_price)) %>%
  ggplot(aes(factor(bedrooms), factor(bathrooms))) +
  geom_tile(aes(fill = auction_price)) +
  # scale_fill_continuous(limits=c(0, 8000000), breaks=seq(0,8000000,by=1000000))+
  labs(x = "Bedrooms", y = "Bathrooms")

# box plot

ggplot(dataset, aes(factor(group), auction_price)) +
  geom_boxplot()
