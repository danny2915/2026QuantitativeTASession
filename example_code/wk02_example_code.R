
# 1. Import Dataset

  ## load the package for data visualization
  library(tidyverse)
  
  ## import csv files
  loan <- read.csv("data/loans_full_schema.csv")
  birth <- read.csv("data/ncbirths.csv")
  
  
# 2. Histogram: `geom_histogram()`
  
  ## plot the histogram of interest rates
  loan %>% 
    ggplot(aes(x = interest_rate)) +
    geom_histogram(binwidth = 2.5,
                   fill = "steelblue",
                   color = "black"
                   )
  
  
# 3. Barplot: `geom_bar()`
  
  ## plot homeownership by application type
  loan %>% 
    ggplot(aes(x = homeownership, fill = application_type)) +
    geom_bar(position = "dodge") # stack, fill, ...
  
  
# 4. Add Title and Axis Labels: `labs()`
  
  ## add labels to the bar plot
  loan %>% 
    ggplot(aes(x = homeownership, fill = application_type)) +
    geom_bar(position = "dodge") +
    labs(
      x = "Type of Homeownership",
      y = "Number of People",
      title = "The Bar Graph with Beautiful Labels",
      fill = "Application Type"
    )
  
  
# 5. Scatter Plot: `geom_point()`
  
  ## plot baby weight by birth weeks
  birth_scatter <- ggplot(birth, aes(x = weeks, y = weight)) +
    geom_point(color = "steelblue", size = 2.5) +
    labs(
      x = "Birth Weeks",
      y = "Baby Weight (pounds)"
    )
  
  print(birth_scatter)
  
  
# 6. Adjust Scale of x, y Axes: `scale_x_continuous()`, `scale_y_continuous()`
  
  ## set limits, breaks, and labels for the scatter plot
  birth_scatter_scaled <- birth_scatter +
    scale_x_continuous(
      limits = c(20, 45),
      breaks = c(20, 25, 30, 35, 40, 45)
    ) +
    scale_y_continuous(
      limits = c(0, 12),
      breaks = c(0, 4, 8, 12),
      labels = c("0 lb", "4 lb", "8 lb", "12 lb")
    )
  
  print(birth_scatter_scaled)
  
  
# 7. Boxplot: `geom_boxplot()`
  
  ## plot interest rates by loan grade
  box_plot <- ggplot(loan, aes(x = grade, y = interest_rate)) +
    geom_boxplot(width = 0.3)
  
  print(box_plot)
  
  
# 8. Save Your Graph into File: `ggsave()`
  
  ## ggsave() saves the newest plot by default
  print(birth_scatter)
  print(box_plot)
  ggsave(filename = "box_plot.png") # It saves box_plot!
  
  ## use plot = ... to assign which plot you want to save
  ggsave(filename = "box_plot.png",
         plot = box_plot)
  
  ## type the path inside filename = ...
  ggsave(filename = "figures/box_plot.png")
  
  ## or use path = ...
  ggsave(filename = "box_plot.png",
         plot = box_plot,
         path = "figures")
  
  ## use width, height, and dpi to control the output size and quality
  ggsave(filename = "box_plot.png",
         plot = box_plot,
         path = "figures",
         width = 6,
         height = 4,
         dpi = 300)
