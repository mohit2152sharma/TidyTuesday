library(tidyr)
library(dplyr)
library(magrittr)
library(readr)
library(ggplot2)

files = list.files('./data')

for(i in 1:length(files)){
  assign(
    x = gsub('.csv', '', files[i]),
    value = read_csv(paste0('./data/', files[i])),
    envir = .GlobalEnv
  )
}

View(country_totals)
View(energy_types)


# energy type vs country --------------------------------------------------

plot_dt = energy_types %>%
  group_by(country_name) %>%
  mutate(x=sum(`2018`)) %>%
  arrange(desc(x)) %>%
  select(-x) %>%
  filter(!is.na(country_name))

ggplot(plot_dt, aes(y = `2018`, x = reorder(country_name, `2018`, sum))) +
  geom_bar(aes(fill = type), position = 'stack', stat = 'identity', na.rm=TRUE) +
  labs(x = 'Country Name',
       y = 'Energy for 2018 in GWh',
       title = 'Top Energy Producers for year 2018',
       caption = 'Source: TidyTuesday, \U00A9 Monty',
       fill = 'Energy Type') +
  scale_fill_brewer(type = 'div', direction = 1, palette = 'PiYG') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        text = element_text(family = 'serif'),
        plot.title = element_text(hjust = 0.5, size = 15, face = 'bold'),
        axis.title = element_text(face = 'bold'),
        legend.title = element_text(face = 'bold'),
        legend.background = element_rect(fill = '#F9E79F'),
        plot.background = element_rect(fill = '#F9E79F'),
        panel.background = element_rect(fill = '#F9E79F'),
        panel.grid = element_blank(),
        axis.line = element_line(color = 'grey'),
        plot.caption = element_text(hjust = 1))

ggsave('./plots/top_energy_producer.png', width = 300, height = 180, units = 'mm')
  
