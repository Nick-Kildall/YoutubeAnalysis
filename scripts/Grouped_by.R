
library("httr")
library("jsonlite")

library(dplyr)
library(leaflet)
library(ggplot2)
library(stringr)
youtube <- read.csv("data/US_youtube_trending_data.csv", stringsAsFactors = FALSE)


get_table_info <- function(youtube) {
  table <- list()
  table$views_mean <- youtube%>%
    group_by(categoryId)%>%
    summarise(averageviews = mean(view_count))%>%
    head(1)%>%
    pull(averageviews)
  table$averagelikes <- youtube%>%
    group_by(categoryId)%>%
    summarise(averagelikes = mean(likes))%>%
    head(1)%>%
    pull(averagelikes)
  table$topchannel <- youtube%>%
    group_by(categoryId, channelTitle)%>%
    summarise(topchannel = max(view_count))%>%
    head(1)%>%
    pull(channelTitle)
  table$commentsmean <- youtube%>%
    group_by(categoryId, channelTitle, comment_count)%>%
    summarise(commentsmean = mean(comment_count))%>%
    head(1)%>%
    pull(comment_count)
  table$titlestat <- youtube%>%
    group_by(categoryId, channelTitle, comment_count, title)%>%
    str_count(youtube$title, "[A-Z]") / nchar(youtube$title)
  return (table)
}


str_count(youtube$title, "[A-Z]") / nchar(youtube$title)
Average views
Average like / dislike ratio
Top channel per category
Average number of comments 
Title statistics (average percent of letters that are capitalized)


