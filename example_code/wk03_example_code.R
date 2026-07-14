
# 1. Remove Everything in the Environment: `rm(list = ls())`

  ## remove all objects in the global environment
  rm(list = ls())
  
  ## check object names in the current environment
  x <- 1
  y <- "hi"
  ls()
  
  ## clean again before starting the examples
  rm(list = ls())


# 2. Import Packages and Datasets

  ## tidyverse includes dplyr, ggplot2, tidyr, readr, and more
  library(tidyverse)
  
  ## import csv files
  loan <- read.csv("data/loans_full_schema.csv")
  babies <- read.csv("data/babies.csv")
  earthquake <- read.csv("data/earthquakes.csv")


# 3. Create Contingency Table: `table()`

  ## table() counts the combinations of categorical variables
  loan_table <- table(loan$application_type,
                      loan$homeownership)
  print(loan_table)
  class(loan_table)
  
  ## dnn means "dimension names"
  loan_table <- table(loan$application_type,
                      loan$homeownership,
                      dnn = c("application type",
                              "home ownership"))
  print(loan_table)


# 4. Add Sum Row and Sum Column: `addmargins()`

  loan_table_withsum <- addmargins(loan_table)
  print(loan_table_withsum)
  class(loan_table_withsum)


# 5. Chain Operations with Pipeline: `%>%`

  ## the pipe sends the result from one line into the next function
  num <- -3:3
  
  num %>%
    sum() %>%
    print()


# 6. Filter Sample in Dataset: `filter()`

  ## filter mothers with height 62, 63, or 64 inches
  babies_height_62_64 <- babies %>%
    filter(height %in% 62:64)
  
  print(babies_height_62_64)
  
  ## use multiple conditions with &
  babies_bwt_gt120_smoke <- babies %>%
    filter(bwt > 120 & smoke == 1)
  
  print(babies_bwt_gt120_smoke)


# 7. Select Variables in Dataset: `select()`

  ## keep only bwt and age
  babies_age_bwt <- babies %>%
    select(bwt, age)
  
  print(babies_age_bwt)
  
  ## remove columns by using -
  babies_wo_case_bwt <- babies %>%
    select(-c(case, bwt))
  
  print(babies_wo_case_bwt)


# 8. Create New Columns by Existing Variables: `mutate()`

  ## create a new column by adding height and weight
  babies_ht_plus_wt <- babies %>%
    mutate(ht_plus_wt = height + weight)
  
  print(babies_ht_plus_wt)
  
  ## create a binary group with ifelse()
  babies_age_gt30 <- babies %>%
    mutate(age_30 = ifelse(age > 30, "age > 30", "age <= 30"))
  
  print(babies_age_gt30)
  
  ## create three or more groups with case_when()
  babies_ht_group <- babies %>%
    mutate(ht_group = case_when(
      is.na(height) ~ NA,
      height <= 63 ~ "ht <= 63",
      height > 63 & height < 67 ~ "63 < ht < 67",
      TRUE ~ "ht >= 67"
    ))
  
  print(babies_ht_group)


# 9. Sort the Dataset: `arrange()`

  ## descending order
  babies_ht_desc <- babies %>%
    arrange(desc(height))
  
  print(babies_ht_desc)
  
  ## ascending order
  babies_ht_asc <- babies %>%
    arrange(height)
  
  print(babies_ht_asc)
  
  ## combine filter(), select(), and arrange() with the pipe
  babies_filtered_sorted <- babies %>%
    filter(height >= 60) %>%
    select(bwt, height) %>%
    arrange(desc(bwt))
  
  print(babies_filtered_sorted)


# 10. Summarize Data: `summarize()`

  ## remove rows with missing values before computing summary statistics
  earthquake_summary <- earthquake %>%
    na.omit() %>%
    summarize(
      avg_scale = mean(richter),
      avg_death = mean(deaths)
    )
  
  print(earthquake_summary)
  
  ## summarize multiple statistics at once
  earthquake_more_summary <- earthquake %>%
    na.omit() %>%
    summarize(
      mean_richter = mean(richter),
      sd_richter = sd(richter),
      max_deaths = max(deaths),
      min_deaths = min(deaths)
    )
  
  print(earthquake_more_summary)


# 11. Group Data by Variables: `group_by()`

  ## summarize by region
  earthquake_region_summary <- earthquake %>%
    na.omit() %>%
    group_by(region) %>%
    summarize(
      max_scale = max(richter),
      min_scale = min(richter),
      avg_death = mean(deaths),
      .groups = "drop"
    ) %>%
    arrange(desc(avg_death))
  
  print(earthquake_region_summary)
  
  ## add group-level summaries to each row
  earthquake_region_mutate <- earthquake %>%
    na.omit() %>%
    group_by(region) %>%
    mutate(
      max_scale = max(richter),
      min_scale = min(richter),
      avg_death = mean(deaths)
    ) %>%
    arrange(desc(avg_death)) %>%
    ungroup()
  
  print(earthquake_region_mutate)


# 12. Remember to Ungroup

  sales <- data.frame(region = c("N", "N", "S", "S", "S", "S"),
                      store = c("A", "B", "A", "A", "B", "B"),
                      sales = c(100, 120, 90, 110, 150, 140))
  
  ## summarise() drops only the last grouping level by default
  by_region_store <- sales %>%
    group_by(region, store) %>%
    summarize(total_sales = sum(sales))
  
  print(by_region_store)
  
  ## because by_region_store is still grouped by region,
  ## this returns the largest store within each region
  by_region_store %>%
    filter(total_sales == max(total_sales)) %>%
    print()
  
  ## use ungroup() if you want the largest store overall
  by_region_store %>%
    ungroup() %>%
    filter(total_sales == max(total_sales)) %>%
    print()
