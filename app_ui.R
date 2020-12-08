# ui.R

# Loading in libraries
library("shiny")
library("plotly")
library("dplyr")
library("shinythemes")
library("shinydashboard")

header <- dashboardHeader(title = "YouTube Trending Data Analysis")

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Introduction", tabName = "Introduction"),
    menuItem("Graph One", tabName = "Barchart"),
    menuItem("Graph Two", tabName = "Piechart"),
    menuItem("Graph Three", tabName = "Quang's page"),
    menuItem("Summary", tabName = "Summary")
  )
)

graph_one <- fluidRow(
  box(
    plotOutput("barchart", height = 300)
  ),
  box(
    title = "Controls",
    sliderInput("slider", "Number of observations:", 1, 100, 50)
  )
)

graph_two <- fluidRow(
  box(plotlyOutput("piechart", height = 300))
)

body <- dashboardBody(
  ### pages
  tabItems(
    tabItem(tabName = "Introduction",
            h2("Dashboard tab content"),
            textOutput(outputId = "intro_txt")
    ),
    
    tabItem(tabName = "Barchart",
            h2("Widgets tab content"),
            graph_one,
            textOutput(outputId = "nick_msg_one")
    ),
    
    tabItem(tabName = "Piechart",
            h2("Trending Categories"),
            graph_two
    ),
    
    tabItem(tabName = "Quang's page",
            h2("blah")
    ),
    
    tabItem(tabName = "Summary",
            h2("Blah")
    )
  )
)

### Main UI Method
ui <- dashboardPage(
  header,
  sidebar,
  body
)

