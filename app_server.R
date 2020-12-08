library(ggplot2)
library(dplyr)
library(stringr)
library(plotly)
library(RColorBrewer)

source("scripts/piechart-graph.R")
<<<<<<< HEAD
source("scripts/daily_views_graph.R")
source("scripts/boxplot-graph.R")
source("scripts/summary_info_script.R")
source("scripts/Grouped_by.R")
=======
>>>>>>> e0f89876aac475ebb919f488104d76ef18280db8

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
    trending_categories_graph(youtube_trending)
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
