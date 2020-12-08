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
  
  ### Quang
  output$boxplot <- renderPlotly({})
  
  ### Isaac 
  
  ### General 
  output$nick_msg_one <- renderText(
    "This plot displays the average amount of views trending videos recieved 
    on a given day (Sunday to Saturday). We created this chart to see if there
    is a relationship between average viewership and the day of the week. 
              
    As you can tell this is a barplot. To make it easier to read we
    included the numbers the bars represent directly above their 
    respective bar. 
              
    This graph clearly shows that trending videos on Friday receive nearly triple
    the average viewership. Additionally, Wednesday is a particularly slow day
    for YouTube videos. This may mean that popular creators should attempt to
    have a video on the trending page every Friday because this is when they
    would likely receive the highest viewership."
  )
  
  output$mitch_msg_one <- renderText(
    "This pie chart displays the distribution of each video category found
    within the trending section as a percentage. Each section of the pie 
    represents a proportion to the total number of videos within the trending 
    section during the 4 month period we pulled our data from.
    
    When hovering over a specific section of the graph you are provided with 
    the category name, the number of videos that  fall under that specific 
    category from our data, and the percentage of the whole rounded to two 
    decimal places that represents how frequent a particular category makes it 
    into the trending section. We created this chart to get an  idea of what 
    types of videos make it onto YouTube's trending section more frequently than
    others.
    
    From looking at the graph, it is clear to see that the majority of videos 
    that make it into the trending section are Music, Entertainment, and 
    Sports, with the combination of the three making up over 50% of the 
    fifteen unique categories that were found in our data. An interesting bit 
    of information that I found was that YouTube has more than just 15 unique
    categories, but the trending section seems to group several categories into 
    a main category to be used in their trending section. "
  )
  
  output$intro_txt <- renderText(
    "Why are you interested in this domain?
    We are frequent consumers of YouTube and we are curious as to what makes
    a YouTube video trending. The trending section can only show a limited
    number of videos each day and captures what is currently going on in the
    world with videos that appeal to a wide range of viewers. Through this
    project, we would like to explore the logistics behind why these videos
    end up in the trending category. 
    
    What data-driven questions do you hope to answer about this domain?
    - When were trending videos posted?  
    
    Using the time of day and days of the week that trending videos are posted, we can try to answer if when videos get posted have an effect on why they become trending.

    - What are the most common characteristics of trending videos?  
    - What types of titles are common in trending videos?
    - Do they ask questions, are they in caps, or do they use symbols?
    - How long are they?
    - What is their like-to-dislike ratio?
    - What is their overall engagement?  
    - How many subscribers do the channels who post trending videos have on average?
    - How many views do the videos within the trending section have on average?
    - Does recency of the video have an impact on entering the trending section?  

    Analyzing these statistics of trending videos will help us get a sense for the logistics behind what makes a video become trending.

    - What video tags make it to the trending section most frequently?

    We will answer this question to determine if there is a correlation between certain types of content and presence within the trending category."
    
  )
}
