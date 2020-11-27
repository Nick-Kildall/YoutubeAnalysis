
library("httr")
library("jsonlite")

library(dplyr)
library(leaflet)
library(ggplot2)
library(stringr)
youtube <- read.csv("data/US_youtube_trending_data.csv", stringsAsFactors = FALSE)


average_views <- (mean(youtube$view_count))

average_likes <- (mean(youtube$likes))

average_dislikes <- (mean(youtube$dislikes))


summary <- youtube%>%
  select(view_count, likes, dislikes, comment_count, categoryId)%>%
  group_by(categoryId)%>%
  summarise(average_views = mean(view_count)
            average)
  
get_summary_info <- function(youtube) {
  ret <- list()
  ret$length <- length(dataset)
  # do some more interesting stuff
  return (ret)
} 





gg <- function(youtube) {
  select(categoryid, view_count, likes, comment_count)
}
