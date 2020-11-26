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

### Alternate graph 
### Days of week with most engagement
days_of_week_viewership <- youtube_trending %>%
  mutate(day = c(
                "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
                "Friday", "Saturday"
                )[as.POSIXlt(substr(publishedAt,1,10))$wday + 1]) %>%
  group_by(day) %>%
  summarise(sum = sum(view_count) + sum(likes) + sum(dislikes) + sum(comment_count)) 

days_of_week_viewership$day <- factor(days_of_week_viewership$day, levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
                                                                              "Friday", "Saturday"))

days_of_week_viewership_plot <- ggplot(data = days_of_week_viewership) +
  geom_col(mapping = aes(x = day, y = sum)) 

