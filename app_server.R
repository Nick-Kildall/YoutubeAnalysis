library(ggplot2)
library(dplyr)
library(stringr)
library(plotly)
library(RColorBrewer)

### Sourcing Data
source("scripts/daily_views_graph.R")
source("scripts/boxplot-graph.R")
source("scripts/summary_info_script.R")
source("scripts/piechart-graph.R")
source("scripts/Grouped_by.R")

### Reading in our dataset.
youtube_trending <- read.csv("data/US_youtube_trending_data.csv",
  encoding = "UTF-8",
  stringsAsFactors = FALSE
)

### Difficult mutate calculation. Only needs to be done once.
youtube_days <- youtube_trending %>% mutate(day = c(
  "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
  "Friday", "Saturday"
)[as.POSIXlt(substr(publishedAt, 1, 10))$wday + 1])

### Changing categoryId into recognizable categories.
youtube_trending$categoryId[youtube_trending$categoryId == "1"] <-
  "Film & Animation"
youtube_trending$categoryId[youtube_trending$categoryId == "2"] <-
  "Auto & Vehicles"
youtube_trending$categoryId[youtube_trending$categoryId == "10"] <-
  "Music"
youtube_trending$categoryId[youtube_trending$categoryId == "15"] <-
  "Pets & Animals"
youtube_trending$categoryId[youtube_trending$categoryId == "17"] <-
  "Sports"
youtube_trending$categoryId[youtube_trending$categoryId == "19"] <-
  "Travel & Events"
youtube_trending$categoryId[youtube_trending$categoryId == "20"] <-
  "Gaming"
youtube_trending$categoryId[youtube_trending$categoryId == "22"] <-
  "People & Blogs"
youtube_trending$categoryId[youtube_trending$categoryId == "23"] <-
  "Comedy"
youtube_trending$categoryId[youtube_trending$categoryId == "24"] <-
  "Entertainment"
youtube_trending$categoryId[youtube_trending$categoryId == "25"] <-
  "News & Politics"
youtube_trending$categoryId[youtube_trending$categoryId == "26"] <-
  "How to & Style"
youtube_trending$categoryId[youtube_trending$categoryId == "27"] <-
  "Education"
youtube_trending$categoryId[youtube_trending$categoryId == "28"] <-
  "Science & Technology"
youtube_trending$categoryId[youtube_trending$categoryId == "29"] <-
  "Nonprofits & Activism"

### Main Server Function
server <- function(input, output) {

  ### Creating a reactive df that filters for data based off the user's input
  ### The options are either viewing the entire df or filtering by month.
  show_categories_by_date <- reactive({
    trending <- youtube_trending %>%
      select(categoryId, publishedAt) %>%
      mutate(month = substr(publishedAt, 6, 7))

    trending$month[trending$month == "08"] <- "August"
    trending$month[trending$month == "09"] <- "September"
    trending$month[trending$month == "10"] <- "October"
    trending$month[trending$month == "11"] <- "November"

    categories_by_date <- if ("ALL" %in% input$piechart) {
      trending %>%
        group_by(categoryId) %>%
        summarize(counts = n())
    } else {
      trending %>%
        filter(month == input$piechart) %>%
        group_by(categoryId) %>%
        summarize(counts = n())
    }

    return(categories_by_date)
  })

  ### Creating piechart visual.
  output$piechart <- renderPlotly({
    plot_ly(
      data = show_categories_by_date(),
      labels = ~categoryId,
      values = ~counts,
      type = "pie",
      textposition = "inside",
      textinfo = "label+percent",
      insidetextfont = list(color = "black"),
      hoverinfo = "text",
      text = ~ paste0(
        "Category: ",
        categoryId,
        "\nNumber of videos: ",
        counts,
        "\nPercentage: ",
        round(counts / sum(counts) * 100, 2), "%"
      ),
      marker = list(line = list(color = "black", width = 1)),
      showlegend = FALSE
    ) %>%
      layout(
        title = "Trending Categories",
        xaxis = list(
          showgrid = FALSE, zeroline = FALSE,
          showticklabels = FALSE
        ),
        yaxis = list(
          showgrid = FALSE, zeroline = FALSE,
          showticklabels = FALSE
        )
      )
  })

  ### Filters data by the user's specified category and finds the average
  ### amount of videos that occured on that day.
  youtube_filtered <- reactive({
    result <- youtube_days %>%
      filter(categoryId == input$cat_input) %>%
      group_by(day) %>%
      summarise(sum_view = sum(view_count))

    result$day <- factor(
      result$day,
      levels =
        c(
          "Sunday", "Monday", "Tuesday",
          "Wednesday", "Thursday", "Friday",
          "Saturday"
        )
    )

    return(result)
  })

  ### Creates a barpot that changes based on the users prefered category
  output$barchart <- renderPlotly({
    plot <- plot_ly(youtube_filtered(),
      x = ~day, y = ~sum_view, type = "bar",
      line = list(color = "rgb(8,48,107)", width = 1.5),
      hoverinfo = "text",
      text = ~ paste0(
        "Day: ",
        day,
        "\nAverage Views: ",
        sum_view
      ),
      marker = list(line = list(color = "black", width = 1))
    ) %>%
      layout(
        title = "Average Amount of Views by Day of the Week",
        xaxis = list(title = "Day"),
        yaxis = list(title = "Average Views")
      )
    return(plot)
  })

  ### Calls function in the script file.
  ### Renders a plot that shows average views per day with out
  ### regard for category.
  output$all_cat_barchart <- renderPlot(get_daily_views_plot(youtube_trending))
  
  ### Intructions for barplot
  output$instructions <- renderText("This plot displays the average amount
    of views trending videos recieved on a given day (Sunday to Saturday) for
    whatever YouTube category the user would like to specify. Use the widget
    above to select the category you would like to see.")
  
  ### Create dataframe that shows the difference between a video's publish
  ### and trending date
  time_until_trending <- reactive({
    df <- youtube_trending %>%
      select(title, categoryId, publishedAt, trending_date) %>%
      mutate(
        publishedAt = as.POSIXct(publishedAt,
          format = "%Y-%m-%dT%H:%M:%SZ"
        ),
        trending_date = as.POSIXct(trending_date,
          format = "%Y-%m-%dT%H:%M:%SZ"
        ),
        publishMonth = format(as.Date(publishedAt), "%B"),
        days_until_trending = (trending_date - publishedAt) / 86400,
        # getting rid of negative time values and replacing them with 0
        days_until_trending = replace(
          days_until_trending,
          which(days_until_trending < 0),
          0
        )
      )

    result <- if ("ALL" %in% input$boxplot) {
      df
    } else {
      df %>%
        filter(publishMonth == input$boxplot) %>%
        group_by(publishMonth, categoryId)
    }

    return(result)
  })
  
  ### Create boxplot that shows data from the month a user chooses
  output$boxplot <- renderPlotly({
    plot_ly(
      data = time_until_trending(),
      x = ~categoryId,
      y = ~days_until_trending,
      type = "box"
    ) %>%
      layout(
        title = paste0("Comparing Publish Dates and Trending",
          "\nDates of Videos by Category"),
        xaxis = list(title = "Category ID", tickangle = -90),
        yaxis = list(title = "Days Until Trending", hoverformat = ".2f")
      )
  })
  
  ## Summary Graphs
  
  ### Render Table
  output$summary_table <- renderTable({get_table_info(youtube_days)})
  ### Render Barplot
  output$summary_barchart <- renderPlot({get_daily_views_plot(youtube_trending)})
  ### Render Piechart
  output$summary_piechart <- renderPlotly({trending_categories_graph(youtube_trending)})
  ### Render Boxplot
  output$summary_boxplot <- renderPlotly({time_until_trending_graph(youtube_days)})
}
