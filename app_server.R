library(ggplot2)
library(dplyr)
library(stringr)
library(plotly)
library(RColorBrewer)

source("scripts/piechart-graph.R")
source("scripts/daily_views_graph.R")
source("scripts/boxplot-graph.R")
source("scripts/summary_info_script.R")
source("scripts/Grouped_by.R")

youtube_trending <- read.csv("data/US_youtube_trending_data.csv",
                             encoding = "UTF-8",
                             stringsAsFactors = FALSE
)

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

server <- function(input, output) {
  
  ### Mitchell
  output$piechart <- renderPlotly({
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
  })
  
  ### Nick
  
  output$test <- renderPlot({
    get_daily_views_plot(youtube_trending)
  })
  
  output$barchart <- renderPlot({
    
    ### Creating a bar graph
    days_of_week_viewership_plot <- ggplot(
      data = days_of_week_viewership,
      aes(x = day, y = sum_view, fill = day, width = .75)
    ) +
      geom_bar(position = "dodge", stat = "identity", colour = "black") +
      geom_text(aes(label = prettyNum(sum_view, big.mark = ",")),
                position = position_dodge(width = 0.9), vjust = -.5
      ) +
      scale_colour_manual(values = names(brewer.pal(6, "Set1"))) +
      labs(x = "Day", y = "Average Views") +
      ggtitle("Average Amount of Views by Day of the Week") +
      theme(legend.position = "none", plot.title = element_text(hjust = 0.5))
    
    return(days_of_week_viewership_plot)
  })
  
  ### Quang
  output$boxplot <- renderPlotly({})
  
}
