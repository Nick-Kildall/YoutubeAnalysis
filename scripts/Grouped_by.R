
library("httr")
library("jsonlite")

library(dplyr)
library(leaflet)
library(ggplot2)
library(stringr)
youtube <- read.csv("data/US_youtube_trending_data.csv", stringsAsFactors = FALSE)


get_table_info <- function(youtube) {

  views_mean <- youtube%>%
    group_by(categoryId)%>%
    summarise(averageviews = mean(view_count))%>%
    head(1)%>%
    pull(averageviews)
  averagelikes <- youtube%>%
    group_by(categoryId)%>%
    summarise(averagelikes = mean(likes))%>%
    head(1)%>%
    pull(averagelikes)
  topchannel <- youtube%>%
    select(channelTitle, view_count, categoryId)%>%
    group_by(categoryId)%>%
    filter(view_count == max(view_count))%>%
    arrange(categoryId)
    pull(channelTitle)
  commentsmean <- youtube%>%
    select(comment_count, categoryId)%>%
    group_by(categoryId)%>%
    summarise(comment_count = mean(comment_count))%>%
    arrange(categoryId)
    pull(comment_count)
  titlestat <- youtube%>%
    mutate(per_cap = str_count(youtube$title, "[A-Z]") / nchar(youtube$title))%>%
    group_by(categoryId)%>%
    summarise(avg_per_cap = paste0(round(100 * mean(per_cap), 1), "%"))%>%
    pull()
  return (table)
}


str_count(youtube$title, "[A-Z]") / nchar(youtube$title)
Average views
Average like / dislike ratio
Top channel per category
Average number of comments 
Title statistics (average percent of letters that are capitalized)


