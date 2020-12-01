library(dplyr)
library(stringr)

get_table_info <- function(youtube) {
  views_mean <- youtube%>%
    group_by(categoryId)%>%
    summarise(averageviews = mean(view_count))%>%
    pull(averageviews)
  
  averagelikes <- youtube%>%
    group_by(categoryId)%>%
    summarise(averagelikes = mean(likes))%>%
    pull(averagelikes)
  
  topchannel <- youtube%>%
    select(channelTitle, view_count, categoryId)%>%
    group_by(categoryId)%>%
    filter(view_count == max(view_count))%>%
    arrange(categoryId)%>%
    pull(channelTitle)
  
  commentsmean <- youtube%>%
    select(comment_count, categoryId)%>%
    group_by(categoryId)%>%
    summarise(comment_count = mean(comment_count))%>%
    arrange(categoryId)%>%
    pull(comment_count)
  
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

aggregate_table <- get_table_info(youtube)


