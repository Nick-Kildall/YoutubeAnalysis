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

server <- function(input, output) {
  
  ### Mitchell
  
  date <- youtube_trending %>%
    mutate(month = substr(publishedAt, 6, 7)) %>%
    group_by(month, categoryId) %>%
    summarize(counts = n())
  
  date$month[date$month == "08"] <- "August"
  date$month[date$month == "09"] <- "September"
  date$month[date$month == "10"] <- "October"
  date$month[date$month == "11"] <- "November"
  
  date$categoryId[date$categoryId == "1"] <- "Film & Animation"
  date$categoryId[date$categoryId == "2"] <- "Autos & Vehicles"
  date$categoryId[date$categoryId == "10"] <- "Music"
  date$categoryId[date$categoryId == "15"] <- "Pets & Animals"
  date$categoryId[date$categoryId == "17"] <- "Sports"
  date$categoryId[date$categoryId == "19"] <- "Travel & Events"
  date$categoryId[date$categoryId == "20"] <- "Gaming"
  date$categoryId[date$categoryId == "22"] <- "People & Blogs"
  date$categoryId[date$categoryId == "23"] <- "Comedy"
  date$categoryId[date$categoryId == "24"] <- "Entertainment"
  date$categoryId[date$categoryId == "25"] <- "News & Politics"
  date$categoryId[date$categoryId == "26"] <- "How to & Style"
  date$categoryId[date$categoryId == "27"] <- "Education"
  date$categoryId[date$categoryId == "28"] <- "Science & Technology"
  date$categoryId[date$categoryId == "29"] <- "Nonprofits & Activism"
  
  alldates <- youtube_trending %>%
    group_by(categoryId) %>%
    summarize(counts = n())
  
  alldates$categoryId <- c("Film & Animation", "Autos & Vehicles", "Music",
                           "Pets & Animals", "Sports", "Travel & Events", "Gaming",
                           "People & Blogs", "Comedy", "Entertainment",
                           "News & Politics", "How to & Style", "Education",
                           "Science & Technology", "Nonprofits & Activism")
  
  categories_by_date <- reactive({
    if ("ALL" %in% input$piechart) {
      categories_by_date <- alldates
    } else if ("August" %in% input$piechart) {
      categories_by_date <- date %>%
        filter(month == "August")
    } else if ("September" %in% input$piechart) {
      categories_by_date <- date %>%
        filter(month == "September")
    } else if ("October" %in% input$piechart) {
      categories_by_date <- date %>%
        filter(month == "October")
    } else if ("November" %in% input$piechart) {
      categories_by_date <- date %>%
        filter(month == "November")
    }
    return(categories_by_date)
  })
  
  # Getting percentages rounded to two decimal places.
  percentages <- reactive({
    if ("ALL" %in% input$piechart) {
      round(alldates$counts / sum(alldates$counts) * 100, 2)
    } else {
      round(categories_by_date$counts / sum(categories_by-date$counts) * 100, 2)
    }
  })
  
  # Computing labels
  label <- reactive({
    if ("ALL" %in% input$piechart) {
      paste0(alldates$categoryId)
    } else {
      paste0(categories_by_date$categoryId)
    }
  })
  
  # Needed more than 9 colors, so had to concatenate palettes.
  my_colors <- c(brewer.pal(name = "Paired", n = 8),
                 brewer.pal(name = "Pastel2", n = 7))
  
  output$piechart <- renderPlotly({
    plot_ly(categories_by_date,
            labels = ~label,
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
                           percentages, "%"),
            marker = list(colors = my_colors,
                          line =
                            list(color = "black",
                                 width = 1)),
            showlegend = FALSE,
            title =
              "Trending Categories by Percent"
    )
  })
  
  ### Nick
  
  output$barchart <- renderPlot({
    get_daily_views_plot(youtube_trending)
  })
  
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

  ### Quang
  output$boxplot <- renderPlotly({})
  
}
