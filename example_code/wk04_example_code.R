# clear the memory

rm(list = ls())
library(tidyverse)

# ==============================================
# 0. Import dataset
# ==============================================
loan <- read.csv("data/loans_full_schema.csv")
housing <- read.csv("data/ames.csv")


# ==============================================
# 1. geom_line(), geom_vline(), geom_hline()
# ==============================================

# 1. Histogram: geom_histogram()
loan %>%
  ggplot(aes(x = interest_rate)) +
  
  ## plot the histogram (choose appropriate bin width, and colors you like)
  geom_histogram(binwidth = 2.5, 
                 fill = "steelblue", 
                 color = "black"
  )

# 2. plot loan application interest rate: according to different grades
facet_wrap_plot <- loan %>%
  ggplot(aes(x = interest_rate)) +
  geom_histogram(bins = 20) +
  facet_wrap(~grade, scales = "free_y", nrow = 2)

# ==============================================
# 2. geom_bar(), labs()
# ==============================================

# 1. Bar plot: `geom_bar()`

## specify the x-axis and subgroup for filling color of the graph
bar_graph <- loan %>%
  ggplot(aes(x = homeownership, fill = application_type)) +
  
  ## add bar graph, and let different bars dodge each other
  geom_bar(position = "dodge")

print(bar_graph)


# 2. Add labels to the graph: `labs()`

## let's continue from the bar graph we just draw
bar_graph_withlabel <- bar_graph +
  
  ## add graph title and axis label to make the graph more readable
  labs(
    x = "Type of Homeownership",
    y = "Number of People",
    title = "The Bar Graph with Beautiful Labels",
    fill = "Application Type"
  ) +
  
  ## center the title text
  theme(plot.title = element_text(hjust = 0.5))

print(bar_graph_withlabel)


# ==============================================
# 3. factor(), as.Date()
# ==============================================

# 1. Categorical variables in R: `factor()`

## A factor stores categorical values with a set of levels.
four_seasons <- c("spring", "summer", "autumn", "winter")
four_seasons_factor <- factor(four_seasons)
print(four_seasons_factor)

## Use mutate() to convert a character column into a factor.
df <- data.frame(cat = c("Large","Small","Large"))
df_factor <- df %>%
  mutate(cat = factor(cat, levels = c("Small","Large")))

## The order of the x-axis follows the factor levels for many ggplot2 functions.
df %>%
  ggplot(aes(x = cat)) +
  geom_bar()

df_factor %>%
  ggplot(aes(x = cat)) +
  geom_bar()


## 2. Turn strings into date type: `as.Date()`

as.Date("2025-01-02")

as.Date("01-02-2025", format = "%m-%d-%Y")

# ==============================================
# 4. geom_line(), geom_vline(), geom_hline()
# ==============================================

# 1. Line Graph: `geom_line()`

# add "01" to date so it is of the form 2025-06-01
housing$date <- as.Date(paste(housing$`Yr.Sold`,
                              housing$`Mo.Sold`,
                              "01",
                              sep = "-")
                        )

# without stat and fun
housing %>% 
  ggplot(aes(x = date, y = price)) + 
  geom_line(linewidth = 0.7, 
            color = "steelblue"
  )

# with stat and fun
housing %>% 
  ggplot(aes(x = date, y = price)) + 
  geom_line(stat = "summary", 
            fun = "mean", 
            linewidth = 0.7, 
            color = "steelblue"
  )


# 2. Draw Vertical Line: geom_vline()
vline_plot <- housing %>% 
  ggplot(aes(x = date, y = price)) + 
  geom_line(stat = "summary", 
            fun = "mean", 
            linewidth = 0.7, 
            color = "steelblue"
  ) +
  
  ## add vertical line to the one with highest average price
  geom_vline(xintercept = as.Date("2006-09-01"), color = "lightcoral")

print(vline_plot)

# 3. Draw Horizontal Line: geom_hline()
hline_plot <- housing %>% 
  ggplot(aes(x = date, y = price)) + 
  geom_line(stat = "summary", 
            fun = "mean", 
            linewidth = 0.7, 
            color = "steelblue"
  ) +
  geom_hline(yintercept = 180000, color = "gray")

print(hline_plot)



# ==============================================
# 4. ggsave()
# ==============================================

## save your graph
ggsave(filename = "vline_plot.png",
       plot = vline_plot,
       path = "figures",
       width = 6,
       height = 4,
       dpi = 300)   

ggsave(filename = "hline_plot.png",
       plot = hline_plot,
       path = "figures",
       width = 6,
       height = 4,
       dpi = 300) 

ggsave(filename = "facet_wrap_plot.png",
       plot = facet_wrap_plot,
       path = "figures",
       width = 6,
       height = 4,
       dpi = 300) 



