# ui.R

# Loading in libraries
library(shiny)
library(plotly)
library(dplyr)
library(shinythemes)

ui <- fluidPage(
  theme = shinytheme("slate"),
  
  titlePanel("YouTube Trending Data Analysis")
)