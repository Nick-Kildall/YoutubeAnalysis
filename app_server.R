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

server <- function(input, output) {
  
  ### Mitchell
  output$piechart <- renderPlotly({
    trending_categories_graph(youtube_trending)
  })
  
  ### Nick
  
  output$barchart <- renderPlot({
    get_daily_views_plot(youtube_trending)
  })

  ### Quang
  output$boxplot <- renderPlotly({})
  
}
