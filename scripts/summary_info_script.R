### returns a list of basic information about the given dataset
get_summary_info <- function(dataset) {
  ret <- list()
  ret$rows <- nrow(dataset)
  ret$columns <- ncol(dataset)
  ret$column_names <- colnames(dataset)
  youtube_dates <- youtube_trending %>%
    mutate(date = substring(publishedAt, 1, 10)) %>%
    select(date)
  ret$earliest_date <- min(youtube_dates$date)
  ret$latest_date <- max(youtube_dates$date)
  return (ret)
} 