### Bar graph
### Average amount of views on any given day

library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(plotly)

### Reading in file
youtube_trending <- read.csv("data/US_youtube_trending_data.csv",
  encoding = "UTF-8",
  stringsAsFactors = FALSE
)

### getting total views per day within dataset
days_of_week_viewership <- youtube_trending %>%
  mutate(day = c(
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
    "Friday", "Saturday"
  )[as.POSIXlt(substr(publishedAt, 1, 10))$wday + 1]) %>%
  group_by(day) %>%
  summarise(sum_view = sum(view_count))

### Using factors to put the days of the week in the desired order
days_of_week_viewership$day <- factor(days_of_week_viewership$day,
  levels =
    c(
      "Sunday", "Monday", "Tuesday",
      "Wednesday", "Thursday", "Friday",
      "Saturday"
    )
)

### Creating a bar graph
days_of_week_viewership_plot <- ggplot(data = days_of_week_viewership,
       aes(x = day, y = sum_view, fill = day, width = .75)) +
  geom_bar(position = "dodge", stat = "identity", colour = "black") +
  geom_text(aes(label = prettyNum(sum_view, big.mark=",")), 
            position = position_dodge(width = 0.9), vjust = -.5) +
  scale_colour_manual(values = names(brewer.pal(6, "Set1"))) +
  labs(x = "Day", y = "Average Views") +
  ggtitle("Average Amount of Views by Day of the Week") +
  theme(legend.position = "none", plot.title = element_text(hjust = 0.5))