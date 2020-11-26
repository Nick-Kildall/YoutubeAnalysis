library(ggplot2)
library(plotly)
library(dplyr)
library(RColorBrewer)

### Reading in the data frame

youtube_trending <- read.csv("data/US_youtube_trending_data.csv", stringsAsFactors = FALSE)

### The numbers below are the corresponding categories for the category IDs in
### the initial dataframe.

# 1 -  Film & Animation
# 2 -  Autos & Vehicles
# 10 - Music
# 15 - Pets & Animals
# 17 - Sports
# 19 - Travel & Events
# 20 - Gaming
# 22 - People & Blogs
# 23 - Comedy
# 24 - Entertainment
# 25 - News & Politics
# 26 - How to & Style
# 27 - Education
# 28 - Science & Technology
# 29 - Nonprofits & Activism


count <- youtube_trending %>%
  group_by(categoryId) %>%
  summarize(counts = unique((sum(categoryId) / categoryId)))

# Labeling the Category IDs with their respective categories.

count$categoryId <- c("Film & Animation", "Autos & Vehicles", "Music", 
                     "Pets & Animals", "Sports", "Travel & Events", "Gaming", 
                     "People & Blogs", "Comedy", "Entertainment", 
                     "News & Politics", "How to & Style", "Education", 
                     "Science & Technology", "Nonprofits & Activism")

# Getting percentages rounded to two decimal places.
count$percentages <- round(count$counts / sum(count$counts) * 100, 2)

# Cumulative percentages (top of each rectangle)
count$ymax = cumsum(count$percentages)

# Bottom of each rectangle
count$ymin = c(0, head(count$ymax, n = -1))

# Label positions
count$labelPosition <- (count$ymax + count$ymin) / 2

# Computing labels
count$label <- paste0(count$categoryId, "\n", count$counts)

### Needed more than 9 colors, so had to concatenate 
mycolors = c(brewer.pal(name = "Paired", n = 8),
             brewer.pal(name = "Pastel2", n = 7))

### Doughnut graph
ggplot(count, aes(ymax = ymax, ymin = ymin, xmax = 4, xmin = 3, 
                  fill = categoryId)) +
  geom_rect(color = "black") +
  geom_label(x = 4.15,
             aes(y = labelPosition, 
                 label = paste(categoryId, "\n", percentages, "%")),
             size = 2.25) +
  scale_color_manual(values = mycolors) +
  coord_polar(theta = "y") +
  xlim(c(0, 4)) +
  theme_void() +
  theme(legend.position = "none") +
  ggtitle("Percentage of categories that reach the trending section")
  