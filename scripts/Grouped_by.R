library(dplyr)
library(stringr)
library("lintr")

#create function that creates a table with aggregated stats
get_table_info <- function(youtube) {
  
  #get the average views based on categoryId
  views_mean <- youtube%>%
    group_by(categoryId)%>%
    summarise(averageviews = mean(view_count))%>%
    pull(averageviews)
  
  #get average amount of likes on a trending video based on categoryId
  averagelikes <- youtube%>%
    group_by(categoryId)%>%
    summarise(averagelikes = mean(likes))%>%
    pull(averagelikes)

  #get the top channel based on categoryId trending the videos  
  topchannel <- youtube%>%
    select(channelTitle, view_count, categoryId)%>%
    group_by(categoryId)%>%
    filter(view_count == max(view_count))%>%
    arrange(categoryId)%>%
    pull(channelTitle)
  
  #get the average amnount of comments on a trending video based on categoryId
  commentsmean <- youtube%>%
    select(comment_count, categoryId)%>%
    group_by(categoryId)%>%
    summarise(comment_count = mean(comment_count))%>%
    arrange(categoryId)%>%
    pull(comment_count)
  
  #get the average amnount of comments on a trending video based on categoryId  
  titlestat <- youtube%>%
    mutate(per_cap = str_count(youtube$title, "[A-Z]") / nchar(youtube$title))%>%
    group_by(categoryId)%>%
    summarise(avg_per_cap = paste0(round(100 * mean(per_cap), 1), "%"))%>%
    pull(avg_per_cap)
  
  category_names <- c("Film & Animation", "Autos & Vehicles", "Music",
                   "Pets & Animals", "Sports", "Travel & Events", "Gaming",
                   "People & Blogs", "Comedy", "Entertainment",
                   "News & Politics", "How to & Style", "Education",
                   "Science & Technology", "Nonprofits & Activism")
  aggregate <- data.frame(category_names, views_mean, averagelikes, topchannel,
                          commentsmean, titlestat)
  return (aggregate)
}



