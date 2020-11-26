library(ggplot2)
library(dplyr)
library(RColorBrewer)

### Reading in the data frame
youtube_trending <- read.csv("data/US_youtube_trending_data.csv",
                             stringsAsFactors = FALSE)

# Changing the column name I will be using later to snake_case
colnames(youtube_trending)[6] <- "category_id"

# Creating a new data frame that only contains the counts of each Category ID
count <- youtube_trending %>%
  group_by(category_id) %>%
  summarize(counts = unique((sum(category_id) / category_id)))

# Labeling the Category IDs with their respective categories.
count$category_id <- c("Film & Animation", "Autos & Vehicles", "Music",
                     "Pets & Animals", "Sports", "Travel & Events", "Gaming",
                     "People & Blogs", "Comedy", "Entertainment",
                     "News & Politics", "How to & Style", "Education",
                     "Science & Technology", "Nonprofits & Activism")

# Getting percentages rounded to two decimal places.
count$percentages <- round(count$counts / sum(count$counts) * 100, 2)

# Cumulative percentages (top of each rectangle)
count$ymax <- cumsum(count$percentages)

# Bottom of each rectangle
count$ymin <- c(0, head(count$ymax, n = -1))

# Label positions
count$label_position <- (count$ymax + count$ymin) / 2

# Computing labels
count$label <- paste0(count$category_id, "\n", count$counts)

# Needed more than 9 colors, so had to concatenate palettes.
my_colors <- c(brewer.pal(name = "Paired", n = 8),
             brewer.pal(name = "Pastel2", n = 7))

### Doughnut graph
trending_categories_plot <- ggplot(count, aes(ymax = ymax, ymin = ymin,
                                              xmax = 4, xmin = 3,
                                              fill = category_id)) +
  geom_rect(color = "black") +
  geom_label(x = 4.15,
             aes(y = label_position,
                 label = paste(category_id, "\n", percentages, "%")),
             size = 2.25) +
  scale_color_manual(values = my_colors) +
  coord_polar(theta = "y") +
  xlim(c(0, 4)) +
  theme_void() +
  theme(legend.position = "none") +
  ggtitle("Percentage of categories that reach the trending section")
