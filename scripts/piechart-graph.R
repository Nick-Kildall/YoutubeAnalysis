library(dplyr)
library(plotly)
library(RColorBrewer)
library(stringr)

trending_categories_graph <- function(youtube_trending) {

  # Changing the column name I will be using later to snake_case
  colnames(youtube_trending)[6] <- "category_id"

  # Creating a new data frame that only contains the counts of each Category ID
  count <- youtube_trending %>%
    group_by(category_id) %>%
    summarize(counts = n())

  # Labeling the Category IDs with their respective categories.
  count$category_id <- c("Film & Animation", "Autos & Vehicles", "Music",
                       "Pets & Animals", "Sports", "Travel & Events", "Gaming",
                       "People & Blogs", "Comedy", "Entertainment",
                       "News & Politics", "How to & Style", "Education",
                       "Science & Technology", "Nonprofits & Activism")

  # Getting percentages rounded to two decimal places.
  count$percentages <- round(count$counts / sum(count$counts) * 100, 2)

  # Computing labels
  count$label <- paste0(count$category_id)

  # Needed more than 9 colors, so had to concatenate palettes.
  my_colors <- c(brewer.pal(name = "Paired", n = 8),
               brewer.pal(name = "Pastel2", n = 7))


  ### Plotly pie chart

  trending_categories_plotly <-  plot_ly(count,
                                         labels = ~label,
                                         values = ~counts,
                                         type = "pie",
                                         textposition = "inside",
                                         textinfo = "label+percent",
                                         insidetextfont = list(color = "black"),
                                         hoverinfo = "text",
                                         text = ~paste0("Category: ",
                                                        category_id,
                                                       "\nNumber of videos: ",
                                                       counts,
                                                       "\nPercentage: ",
                                                       percentages, "%"),
                                         marker = list(colors = my_colors,
                                                       line =
                                                         list(color = "black",
                                                              width = 1)),
                                         showlegend = FALSE,
                                         title =
                                           "Trending Categories by Percent"
                                         )
  return(trending_categories_plotly)
}

