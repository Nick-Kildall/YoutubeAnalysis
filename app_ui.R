# ui.R

# Loading in libraries
library("shiny")
library("plotly")
library("dplyr")
library("shinythemes")
library("shinydashboard")



header <- dashboardHeader(titleWidth = '100%',
                          title = "YouTube Trending Data Analysis in the United States"
)
                          
                          

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Introduction", tabName = "Introduction"),
    menuItem("Graph One", tabName = "Barchart"),
    menuItem("Trending by Categories", tabName = "Piechart"),
    menuItem("Publish Date vs Trending Date", tabName = "Boxplot"),
    menuItem("Summary", tabName = "Summary")
  )
)

graph_one <- fluidRow(
  box(
    plotOutput("barchart", height = 300)
  ),
  box(
    title = "Category",
    cat_input <- selectInput(
      inputId = "cat_input", label = "Category Type",
      choices = list(
          "Film & Animation" = 1, "Autos & Vehicles" = 2, "Music" = 10,
          "Pets & Animals" = 15, "Sports" = 17, "Travel & Events" = 19,
          "Gaming" = 20, "People & Blogs" = 22, "Comedy" = 23, "Entertainment" = 24,
          "News & Politics"=25, "How to & Style" = 26, "Education" = 27,
          "Science & Technology" = 28, "Nonprofits & Activism" = 29
      )
    )
  ),
  box(textOutput(outputId = "nick_msg_two"))
)

graph_two <- fluidRow(
  box(
    plotlyOutput("piechart", height = 400)
  ),
  
  box(
    selectInput(
      inputId = "piechart",
      label = "Select a Month",
      choice = c("ALL", "August", "September", "October", "November"),
      selected = "ALL"
    )
  )
)

graph_three <- fluidRow(
  box(
    plotlyOutput("boxplot", height = 650)
  )
)

body <- dashboardBody(
  
  ### pages
  tabItems(
    tabItem(tabName = "Introduction",
            includeHTML("www/introduction.html")
    ),
    
    tabItem(tabName = "Barchart",
            h2("Widgets tab content"),
            graph_one,
            textOutput(outputId = "nick_msg_one")
    ),
    
    tabItem(tabName = "Piechart",
            includeHTML("www/piechart_header.html"),
            graph_two,
            includeHTML("www/piechart_msg.html")
    ),
    
    tabItem(tabName = "Boxplot",
            h2("Publish Date vs Trend Date"),
            graph_three
    ),
    
    tabItem(tabName = "Summary",
            h2("Blah")
    )
  )
)

### Main UI Method
ui <- shinyUI(
    dashboardPage(
      skin = "red",
      header,
      sidebar,
      body
    )
)


