address = function(){
  add = readClipboard()
  add = gsub('\\\\', '/', add)
  return(add)
}

setwd(address())

video_games = readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-07-30/video_games.csv")

View(video_games)

#converting release date column type to date type
library(lubridate)
library(tidyverse)
video_games$release_date2 = mdy(video_games$release_date)

video_games = video_games[-which(is.na(video_games$release_date2)), ]

glimpse(video_games)


#has the price of games gone up?
#remove the outliers as well
video_games %>%
  filter(!is.na(price)) %>% 
  filter(
    price < 1.5*sd(price)
  ) %>% 
  mutate(year = as.factor(year(release_date2))) -> price_data

library(ggridges)
ggplot(price_data, aes(y = as.factor(year), x = price)) +
  geom_density_ridges(aes(fill = year)) +
  theme(legend.position = 'none') +
  labs(title = 'Price of games over the years', y = 'Year', x = 'Price')
ggsave('./plots/price_year.jpeg')
