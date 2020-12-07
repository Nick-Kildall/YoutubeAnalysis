library(ggplot2)
library(dplyr)
library(stringr)
library(plotly)

server <- function(input, output) {
  
  ### Mitchell
  output$piechart <- renderPlotly({})
  
  ### Nick
  output$barchart <- renderPlot({})
  
  ### Quang
  output$boxplot <- renderPlotly({})
  
}
