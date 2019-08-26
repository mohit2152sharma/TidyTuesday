address = function(){
  add = readClipboard()
  add = gsub("\\\\", "/", add)
  return(add)
}

directory_path = address()

setwd(directory_path)

emperors <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-08-13/emperors.csv")

readr::write_csv(emperors, 'emperors.csv')

emperors = readr::read_csv('emperors.csv')

library(lubridate)
emperors$life_span = difftime(
  emperors$death,
  emperors$birth,
  units = 'secs'
)/dyears(1)

library(ggplot2)

ggplot(emperors)+
  geom_point(
    aes(
      size = life_span,
      x = dynasty,
      y = life_span,
      color = dynasty
    )
  )
