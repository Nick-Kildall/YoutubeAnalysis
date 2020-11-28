### Bar graph
### Daily sum of views. Look for high surges. Might correlate to events. (Nick)

library(dplyr)
library(ggplot2)
library(RColorBrewer)

youtube_trending <- read.csv("../data/US_youtube_trending_data.csv", stringsAsFactors = FALSE)

### Alternate graph 
### Days of week with most engagement
days_of_week_viewership <- youtube_trending %>%
  mutate(day = c(
                "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
                "Friday", "Saturday"
                )[as.POSIXlt(substr(publishedAt,1,10))$wday + 1]) %>%
  group_by(day) %>%
  summarise(sum = sum(view_count) ) 

days_of_week_viewership$day <- factor(days_of_week_viewership$day, levels =
                                      c("Sunday", "Monday", "Tuesday",
                                        "Wednesday", "Thursday", "Friday",
                                        "Saturday"))

days_of_week_viewership_plot <- ggplot(days_of_week_viewership, ) +
  geom_bar(stat="identity", mapping = aes(x = day, y = sum, fill = day)) +
  scale_colour_manual(values = names(brewer.pal(6, "Set1"))) +
  labs(x = "Day", y = "Average Views") +
  ggtitle("Average Amount of Views by Day of the Week") +
  theme(legend.position="none") 





