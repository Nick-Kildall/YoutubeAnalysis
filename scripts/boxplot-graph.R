#set working directory to AF-4

library(dplyr)
library(ggplot2)
library(plotly)

#read youtube df
youtube_trending <- read.csv("data/US_youtube_trending_data.csv",
                             encoding = "UTF-8",
                             stringsAsFactors = FALSE)

#create df that shows difference in publish/trending time
time_until_trending <- youtube_trending %>%
  select(title, categoryId, publishedAt, trending_date) %>%
  mutate(publishedAt = as.POSIXct(publishedAt,
                                  format = "%Y-%m-%dT%H:%M:%SZ"),
         trending_date = as.POSIXct(trending_date,
                                    format = "%Y-%m-%dT%H:%M:%SZ"),
         days_until_trending = (trending_date - publishedAt) / 86400)

#convert categoryid into name
time_until_trending$categoryId <- factor(time_until_trending$categoryId,
        levels = c(1,2,10,15,17,19,20,22,23,24,25,26,27,28,29),
        labels = c("Film & Animation", "Autos & Vehicles", "Music",
                   "Pets & Animals", "Sports", "Travel & Events",
                   "Gaming", "People & Blogs", "Comedy", "Entertainment",
                   "News & Politics", "How to & Style", "Education",
                   "Science & Technology", "Nonprofits & Activism"))

#boxplot
days_until_trending_plot <- ggplot(time_until_trending,
                                   aes(x = categoryId,
                                       y = days_until_trending,
                                       fill = categoryId)) +
  ggtitle("Comparing Publish Dates and Trending Dates of Videos by Category") +
  theme(plot.title = element_text(hjust = .5)) +
  geom_boxplot(outlier.shape = 8) +
  stat_summary(fun.y = mean, geom = "point") +
  xlab("Category ID") + ylab("Days Until Trending")

#plotly
days_until_trending_plotly <- ggplotly(days_until_trending_plot,
                                       height = 650,
                                       width = 1100)
