# ui.R

# Loading in libraries
library("shiny")
library("plotly")
library("dplyr")
library("shinythemes")
library("shinydashboard")

### Nick

### Mitchell

### Quang

### Isaac



header <- dashboardHeader(title = "YouTube Trending Data Analysis")

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Introduction", tabName = "intro"),
    menuItem("Graph One", tabName = "barchart")
  )
)

graph_one <- fluidRow(
  box(plotOutput("barchart", height = 300)),
  
  box(
    title = "Controls",
    sliderInput("slider", "Number of observations:", 1, 100, 50)
  )
)

body <- dashboardBody(
  ### pages
  tabItems(
    tabItem(tabName = "intro",
            h2("Dashboard tab content")
    ),
    
    tabItem(tabName = "barchart",
            h2("Widgets tab content"),
            graph_one
    )
  )
)

ui <- dashboardPage(
  header,
  sidebar,
  body
)

#ui_final <- navbarPage(
#  "Midwest Dataset",
#  tabPanel("page one", page_one),
#  tabPanel("page two", page_two)
#)

#### page one
#page_one <- fluidPage(
#  sidebarPanel(
#    y_input1,
#    color_input
#  ),
#  mainPanel(
#    h2("Midwest Plot"),
#    textOutput(outputId = "msg"),
#    plotOutput(outputId = "midwest_one")
#  )
#)

#### page two
#page_two <- fluidPage(
#  sidebarPanel(
#    y_input2,
#    state_input
#  ),
#  mainPanel(
#    h2("Midwest Plot"),
#    textOutput(outputId = "msg2"),
#    plotOutput(outputId = "midwest_two")
#  )
#)