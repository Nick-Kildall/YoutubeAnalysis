# ui.R

# Loading in libraries
library("shiny")
library("plotly")
library("dplyr")
library("shinythemes")
library("shinydashboard")

### Header
header <- dashboardHeader(titleWidth = "100%",
                          title = "YouTube Trending Data Analysis in 
                          the United States"
)

### Sidebar
sidebar <- dashboardSidebar(width = 275,
  sidebarMenu(
    menuItem("Introduction", tabName = "Introduction"),
    menuItem("Average Views by Category", tabName = "Barchart"),
    menuItem("Trending by Categories", tabName = "Piechart"),
    menuItem("Publish Date vs Trending Date", tabName = "Boxplot"),
    menuItem("Summary", tabName = "Summary")
  )
)
### Bar Chart
graph_one <- fluidRow(
  box(
    plotOutput("barchart", height = 400)
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
      ),
      selected = "Film & Animation"
    )
  ),
  box(textOutput("instructions"))
)
### End Bar Chart

### Pie Chart
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
### End Pie Chart

### Box Plot
graph_three <- fluidRow(
  box(
    plotlyOutput("boxplot", height = 650)
  ),

  box(
    selectInput(
      inputId = "boxplot",
      label = "Select a Month",
      choice = c("ALL", "August", "September", "October", "November"),
      selected = "ALL"
    )
  )
)

### End Boxplot

body <- dashboardBody(

  ### Pages
  tabItems(
    tabItem(tabName = "Introduction",
            includeHTML("www/introduction.html")
    ),
    ### Bar Chart page displaying average views for each category by day of
    ### the week.
    tabItem(tabName = "Barchart",
            h2("Average Views by Category"),
            graph_one,
            includeHTML("www/graph_one.html"),
            plotOutput("all_cat_barchart", height = 400, width = 700),
            includeHTML("www/graph_one2.html")
    ),
    ### Pie Chart page displaying trending categories by frequency (percentage)
    tabItem(tabName = "Piechart",
            includeHTML("www/piechart_header.html"),
            graph_two,
            includeHTML("www/piechart_msg.html")
    ),
    ### Box Plot page displaying how long it takes for a video to go trending.
    tabItem(tabName = "Boxplot",
            includeHTML("www/boxplot_header.html"),
            graph_three,
            includeHTML("www/boxplot.html")
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
