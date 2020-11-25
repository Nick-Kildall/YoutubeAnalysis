### Bar graph
### Daily sum of views. Look for high surges. Might correlate to events. (Nick)

library(dplyr)
library(ggplot2)

youtube_trending <- read.csv("data/US_youtube_trending_data.csv", stringsAsFactors = FALSE)

daily_viewership <- youtube_trending %>%
  mutate(date = substr(publishedAt,1,10)) %>%
  group_by(date) %>%
  summarise(sum = sum(view_count)) 
  
daily_viewership_plot <-  ggplot(data = daily_viewership) +
    geom_col(mapping = aes(x = date, y = sum)) +
    theme(axis.text.x = element_text(angle = 90))


