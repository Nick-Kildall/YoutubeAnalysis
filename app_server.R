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
  output$piechart <- renderPlotly({
    trending_categories_graph(youtube_trending)
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
