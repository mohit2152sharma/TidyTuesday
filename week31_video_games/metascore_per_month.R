address = function(){
  add = readClipboard()
  add = gsub('\\\\', '/', add)
  return(add)
}

setwd(address())

video_games = readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-07-30/video_games.csv")

View(video_games)

#question: which month would be great to launch the video game

#converting release date column type to date type
library(lubridate)
library(tidyverse)
video_games$release_date2 = mdy(video_games$release_date)

video_games = video_games[-which(is.na(video_games$release_date2)), ]

glimpse(video_games)

video_games = video_games %>% arrange(desc(release_date2))

#not all games have metascore
video_games %>% select(metascore) %>% filter(is.na(.) == TRUE) %>% nrow(.) -> metascore_na_len

metascore_na_len/nrow(video_games) #almost 89% games doesn't have metascore

#games with metascore
metascore_games = video_games %>% filter(is.na(metascore) == FALSE)
dim(metascore_games) #2850 games have metascore rating

ggplot(metascore_games, aes(release_date2, metascore)) +
  geom_point(aes(col = as.factor(month(release_date2)))) +
  labs(color = 'month')
ggsave('metascore_month.jpeg')
#very difficult to see anything significant.

#let's try something else, let's see data for month
metascore_games = metascore_games %>% mutate(month = month(release_date2, label = TRUE))

ggplot(data = metascore_games, aes( x = month, y = metascore)) +
  geom_jitter( aes(color = month)) +
  geom_point(aes(x = month, y = mean(metascore)), col = 'black', size = 5) +
  coord_flip() +
  theme( axis.title.y = element_blank(),
         axis.text.y = element_blank(),
         axis.ticks.y = element_blank())
ggsave('./plots/avg_metascore_month.jpeg')
#the mean metascore is same throughout the months, so it doesn't matter which month you launch the game.
