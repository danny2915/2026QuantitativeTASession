

# ==============================================
# 1. Import dataset: "read.csv()"
# ==============================================
babies <- read.csv("data/babies.csv")
earthquake <- read.csv("data/earthquake.csv")


# ==============================================
# 2. Logical expressions
# ==============================================

# 1. Comparison Operators: >, <, =, !

# > (Greater than)
print(5 > 4)

# >= (Greater or equal)
print(3 >= 4)

# < (Smaller than)
print(5 < 4)

# >= (Smaller or equal)
print(3 <= 4)

# == (Equal to) 
print(4 == 4)

# != (Not equal to)
print("H" != "I")

# 2. AND: & (element wise), && (first element only)

# AND: & (element wise), && (first element only)
x <- c(3, 5, 8)
x > 4 & x < 7 # FALSE TRUE FALSE
# Error: 'length = 3' in coercion to 'logical(1)'
# x > 4 && x < 7

# OR: | (element wise), || (first element only)
x <- c(3, 5, 8)
x > 4 | x < 7 # TRUE TRUE TRUE
# Error: 'length = 3' in coercion to 'logical(1)'
#x > 4 || x < 7

# Use && if inside an if statement
if (TRUE || FALSE){
  print("TRUE!")
}

# & and | are useful as filters:
df <- data.frame(age = c(16, 22, 30, 40),
                 score = c(80, 90, 55, 60))
df[df$age > 18 & df$score > 70, ]

# 3. Check if object inside a vector or list: %in%

# example 1
fruit <- c("apple", "banana", "pear")
basket <- c("banana", "orange", "pear", "kiwi")
fruit %in% basket # FALSE TRUE TRUE

# example 2
3 %in% list(1, 2, 3, 4, 5) # TRUE
3 %in% list(1:5, 6:10) # FALSE
1:5 %in% list(1:5, 6:10) # FALSE FALSE FALSE FALSE FALSE
list(1:5) %in% list(1:5, 6:10) # TRUE

# 4. Use () for clearer expressions

x <- 7

# comparisons (>, <, ==) are evaluated before &
# & is evaluated before |
x > 4 & x < 10 | x == 2 & x > 8 # TRUE
# this is equivalent to
(x > 4 & x < 10) | (x == 2 & x > 8) # TRUE

# however, if you meant to calculate from left to right
(((x > 4 & x < 10) | x == 2) & x > 8) # FALSE


# ==============================================
# 3. Data Wrangling
# =============================================

# 1. Using pipeline to pass data to function: `%>%`

# example: calling the function to deal with numeric data
num <- -3:3
print(num)

num %>% 
  cumsum() %>%
  print()


# 2. Filter the data according to some conditions: `filter()`

## example 1: single condition
babies_height_62_64 <- babies %>% 
  filter(height %in% 62:64)

print(babies_height_62_64)


## example 2: multiple conditions
babies_bwt_gt120_smoke <- babies %>% 
  filter(bwt > 120 & smoke == 1)

print(babies_bwt_gt120_smoke)

# 3. Select variables: `select()`
babies_age_bwt <- babies %>% 
  select(bwt, age)

print(babies_age_bwt)

babies_wo_case_bwt <- babies %>% 
  select(-c(case, bwt))

print(babies_wo_case_bwt)

# 4. Generate new column from existing variables: `mutate()`

# example 1
babies_ht_plus_wt <- babies %>% 
  mutate(ht_plus_wt = height + weight)

print(babies_ht_plus_wt)

# example 2
babies_age_gt30 <- babies %>% 
  mutate(age_30 = ifelse(age > 30, "age > 30", "age <= 30"))

print(babies_age_gt30)  

# example 3
babies_ht_group <- babies %>% 
  mutate(ht_group = case_when(
    is.na(height) ~ NA,
    height <= 63 ~ "ht <= 63",
    height > 63 & height < 67 ~ "63 < ht < 67",
    TRUE ~ "ht >= 67"
  ))

print(babies_ht_group)  


# 5. Sort the data according to some variable: `arrange()`

# descending order
babies_ht_desc <- babies %>% 
  arrange(desc(height)) # desc = descending; default = ascending

print(babies_ht_desc)

# ascending order
babies_ht_asc <- babies %>% 
  arrange(height) 

print(babies_ht_asc)


# 6. summarize the data: `summarize()`

earthquake %>% 
  na.omit() %>% 
  summarize(
    avg_scale = mean(richter),
    avg_death = mean(deaths)
  )


# 7. grouping the data: `group_by()`
# [REMARK] we usually use `group_by()` together with `summarize()`

## example 1: compute the average number of death for each country from 1900 to 1999
earthquake %>% 
  group_by(region) %>% 
  summarize(
    max_scale = max(richter),
    min_scale = min(richter),
    avg_death = mean(deaths)
  ) %>% 
  arrange(desc(avg_death))

## example 2: add the statistics of example 1 to the whole dataframe using mutate()
earthquake %>% 
  group_by(region) %>% 
  mutate(
    max_scale = max(richter),
    min_scale = min(richter),
    avg_death = mean(deaths)
  ) %>% 
  arrange(desc(avg_death)) %>%
  ungroup()

## example 3: compute the number of earthquake in each year from 1900 to 1999
earthquake %>%
  mutate(N = 1) %>% 
  group_by(year) %>% 
  summarize(earthquake_time = sum(N))

## example 4: forget using ungroup() may cause problems
sales <- data.frame(region = c("N","N","S","S","S","S"),
                    store  = c("A","B","A","A","B","B"),
                    sales  = c(100,120,90,110,150,140))

# forget to ungroup()
by_region_store <- sales %>%
  group_by(region, store) %>%
  summarise(total_sales = sum(sales))

# Now by_region_store is group by region
# So there would be two columns instead of one
by_region_store %>% filter(total_sales == max(total_sales))

