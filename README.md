## Domain of interest

#### Why are you interested in this domain?
We are frequent consumers of YouTube and we are curious as to what makes a YouTube video trending. Trending YouTube videos capture what is currently going on in the world and we would like to explore why these videos end up in the trending category.

#### What other examples of data driven projects have you found related to this domain?
- [This data project](https://scholarworks.calstate.edu/downloads/k3569434b) looks at how YouTube data is used by companies to improve their product. Discusses how popular a product is by looking at view counts, shares, and etc. This is more focused on company marketing profit, but still utilizes the YouTube algorithm to gain its success.
- [This study](https://www.appypie.com/how-youtube-algorithm-works) uses data to create infographics that explain best times to post and other factors that determine a video's success. Looks at the YouTube algorithm, so it's more broad than our topic.
- [Study done with the same dataset](https://towardsdatascience.com/why-study-statistics-behind-youtube-trending-videos-231b72c81256). Could potentially be a useful reference.

#### What data-driven questions do you hope to answer about this domain?
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

  We will answer this question to determine if there is a correlation between certain types of content and presence within the trending category.

## Finding Data
#### Where did you download the data (e.g., a web URL)?    

We downloaded [“US_youtube_trending_data.csv”](https://www.kaggle.com/rsrishav/youtube-trending-video-dataset?select=US_youtube_trending_data.csv) from kaggle (current data)

We downloaded [“USvideos.csv”](https://www.kaggle.com/datasnaek/youtube-new?select=USvideos.csv) from kaggle (2017 data)

We found [an API developed by Google](https://developers.google.com/youtube/analytics) for creators.


#### How was the data collected or generated?
- US_youtube_trending_data was collected by Rishav Sharma via the YouTube API to observe the daily statistics of trending YouTube videos. It is updated daily and has been recording entries since August 12th, 2020.
- USvideos was collected by Mitchell J via the YouTube API and contains information about trending videos from November 2017 through June 2018.
- API information are gathered from the  YouTube Analytics API and YouTube Reporting API which contains reports that includes two types of data;
    - **Dimensions** are common criteria that are used to aggregate data, such as the date on which the user activity occurred or the country where the users were located.

    In a report, each row of data has a unique combination of dimension values. As such, each row's combination of dimension values functions as the primary key for that row.
   - **Metrics** are individual measurements of user activity, ad performance, or estimated revenue. User activity metrics include things like video view counts and ratings (likes and dislikes).


#### How many observations (rows) are in your data?
We downloaded our csv files into R and ran nrow()
- “US_youtube_trending_data.csv” has 18,798 rows
- “USvideos.csv” has 40,949 rows
- The API is not a csv file, therefore it has no rows.

#### How many features (columns) are in the data?
We downloaded our csv files into R and ran ncol()
- “US_youtube_trending_data.csv” has 16 columns
- “USvideos.csv” has 16 columns
- The API is not a csv file, therefore it has no columns.

#### What questions from above can be answered using the data in this dataset?
- We can analyze the data to figure out what factors — such as; likes, dislikes, titles, comments, and length — are typically found in trending videos.
- We can analyze when trending videos are posted.
- We can analyze what tags are most frequently found in trending.
