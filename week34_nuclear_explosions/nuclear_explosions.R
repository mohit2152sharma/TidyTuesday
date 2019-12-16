setwd(gsub("\\\\", "/", readClipboard()))

download_path = ("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-08-20/nuclear_explosions.csv")

nuclear_explosions = readr::read_csv(download_path)

View(nuclear_explosions)

library(lubridate)
library(tidyverse)
library(ggthemes)

class(nuclear_explosions$date_long)

nuclear_explosions$date_long = ymd(nuclear_explosions$date_long)

nuclear_explosions = nuclear_explosions %>% arrange(date_long)

ggplot( data = nuclear_explosions %>% 
          group_by(year) %>% summarize(n()) %>% rename(count = `n()`),
        aes(x = year, y = count)
) +
  geom_line() +
  labs(title = 'Number of Nuclear Bombs detonated with year',
       caption = 'source:tidytuesday') +
  theme_wsj()

ggsave('bombs_with_year.jpeg')

library(maps)
library(gganimate)

world_map = ggplot() +
  borders(database = 'world', colour = 'grey50', fill = 'grey85')

map_plot = world_map +
  geom_point(
      data = nuclear_explosions,
      aes(
        x = longitude,
        y = latitude,
        size = yield_upper
      ),
      color = 'orange',
      alpha = 0.5
    ) +
  labs(size = 'Yield Upper',
       caption = 'source:tidytuesday')

animated_plot = map_plot +
  transition_time(date_long) + 
  ggtitle('Nuclear Explosion Locations',
          subtitle = 'Year: {frame_time}')

animate(animated_plot, fps = 2, rewind = TRUE)

anim_save('animation.gif', animated_plot)


