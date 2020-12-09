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

### Difficult mutate calculation. Only needs to be done once.
youtube_days <- youtube_trending %>% mutate(day = c(
  "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
  "Friday", "Saturday"
)[as.POSIXlt(substr(publishedAt, 1, 10))$wday + 1])

youtube_trending$categoryId[youtube_trending$categoryId == "1"] <- "Film & Animation"
youtube_trending$categoryId[youtube_trending$categoryId == "2"] <- "Auto & Vehicles"
youtube_trending$categoryId[youtube_trending$categoryId == "10"] <- "Music"
youtube_trending$categoryId[youtube_trending$categoryId == "15"] <- "Pets & Animals"
youtube_trending$categoryId[youtube_trending$categoryId == "17"] <- "Sports"
youtube_trending$categoryId[youtube_trending$categoryId == "19"] <- "Travel & Events"
youtube_trending$categoryId[youtube_trending$categoryId == "20"] <- "Gaming"
youtube_trending$categoryId[youtube_trending$categoryId == "22"] <- "People & Blogs"
youtube_trending$categoryId[youtube_trending$categoryId == "23"] <- "Comedy"
youtube_trending$categoryId[youtube_trending$categoryId == "24"] <- "Entertainment"
youtube_trending$categoryId[youtube_trending$categoryId == "25"] <- "News & Politics"
youtube_trending$categoryId[youtube_trending$categoryId == "26"] <- "How to & Style"
youtube_trending$categoryId[youtube_trending$categoryId == "27"] <- "Education"
youtube_trending$categoryId[youtube_trending$categoryId == "28"] <- "Science & Technology"
youtube_trending$categoryId[youtube_trending$categoryId == "29"] <- "Nonprofits & Activism"

### Main Server Function
server <- function(input, output) {
  
  ### Mitchell
  
  show_categories_by_date <- reactive({
    if ("ALL" %in% input$piechart) {
      categories_by_date <- youtube_trending %>%
        group_by(categoryId) %>%
        summarize(counts = n())
    } else if ("August" %in% input$piechart) {
      categories_by_date <- youtube_trending %>%
        mutate(month = substr(publishedAt, 6, 7)) %>%
        filter(month == "08") %>%
        group_by(month, categoryId) %>%
        summarize(counts = n())
    } else if ("September" %in% input$piechart) {
      categories_by_date <- youtube_trending %>%
        mutate(month = substr(publishedAt, 6, 7)) %>%
        filter(month == "09") %>%
        group_by(month, categoryId) %>%
        summarize(counts = n())
    } else if ("October" %in% input$piechart) {
      categories_by_date <- youtube_trending %>%
        mutate(month = substr(publishedAt, 6, 7)) %>%
        filter(month == "10") %>%
        group_by(month, categoryId) %>%
        summarize(counts = n())
    } else if ("November" %in% input$piechart) {
      categories_by_date <- youtube_trending %>%
        mutate(month = substr(publishedAt, 6, 7)) %>%
        filter(month == "11") %>%
        group_by(month, categoryId) %>%
        summarize(counts = n())
    }
    
    return(categories_by_date)
  })

  output$piechart <- renderPlotly({
    plot_ly(data = show_categories_by_date(),
            labels = ~categoryId,
            values = ~counts,
            type = "pie",
            textposition = "inside",
            textinfo = "label+percent",
            insidetextfont = list(color = "black"),
            hoverinfo = "text",
            text = ~paste0("Category: ",
                           categoryId,
                           "\nNumber of videos: ",
                           counts,
                           "\nPercentage: ",
                           round(counts / sum(counts) * 100, 2), "%"),
            marker = list(line = list(color = "black", width = 1)),
            showlegend = FALSE
    ) %>%
      layout(title = "Trending Categories",
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  ### Nick
  
  #if (input$piechart == 1) {
  #  categories_by_date <- youtube_trending %>%
  #    group_by(categoryId) %>%
  #    summarize(counts = n())
  #} else if (input$piechart != 1) {
  #  categories_by_date <- youtube_trending %>%
  #    mutate(month = substr(publishedAt, 6, 7)) %>%
  #    filter(month == input$piechart) %>%
  #    group_by(month, categoryId) %>%
  #    summarize(counts = n())
  #}
  
  #output$barchart <- renderPlot({
  #  get_daily_views_plot(youtube_trending)
  #})
  
  ### shows output of user input
  output$nick_msg_two <- renderText(paste0("this is the output of the button: ", input$cat_input))
  
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
  
  output$barchart <- renderPlot({
    ggplot(
      data = youtube_filtered(),
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
  })
  
  output$all_cat_barchart <- renderPlot(get_daily_views_plot(youtube_trending))
  
  ### Quang
  
  time_until_trending <- reactive({
    result <- youtube_trending %>%
      select(title, categoryId, publishedAt, trending_date) %>%
      mutate(
        publishedAt = as.POSIXct(publishedAt,
                                 format = "%Y-%m-%dT%H:%M:%SZ"
        ),
        trending_date = as.POSIXct(trending_date,
                                   format = "%Y-%m-%dT%H:%M:%SZ"
        ),
        days_until_trending = (trending_date - publishedAt) / 86400,
        # getting rid of negative time values and replacing them with 0
        days_until_trending = replace(
          days_until_trending,
          which(days_until_trending < 0),
          0
        ),
        categoryId = factor(
          categoryId,
          levels = c(1, 2, 10, 15, 17, 19, 20, 22, 23, 24, 25, 26, 27, 28, 29),
          labels = c(
            "Film & Animation", "Autos & Vehicles", "Music",
            "Pets & Animals", "Sports", "Travel & Events",
            "Gaming", "People & Blogs", "Comedy", "Entertainment",
            "News & Politics", "How to & Style", "Education",
            "Science & Technology", "Nonprofits & Activism"
          )
        )
      )
    return(result)
  })
  
  output$boxplot <- renderPlotly({
    plot_ly(data = time_until_trending(),
            x = ~categoryId,
            y = ~days_until_trending,
            type = "box")
  })
  
  ### Isaac 
  
  ### General 

  
}
