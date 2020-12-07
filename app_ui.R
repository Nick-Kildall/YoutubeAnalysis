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
  sidebarMenu("Stuff",
              tabName = "Pie Chart")
)

body <- dashboardBody(
  tabItems(
    tabItem(
      tabName = "Pie Chart"
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