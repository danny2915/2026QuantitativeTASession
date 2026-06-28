rm(list = ls())

library(tidyverse)
library(estimatr)
library(texreg)

# ==============================================
# Import dataset
# ==============================================
birth <- read.csv("data/ncbirths.csv")
loan <- read.csv("data/loans_full_schema.csv")

# ==============================================
# 1. Data Wrangling
# ==============================================

# 1. Number of rows/columns: `nrow()`, `ncol()`, `dim()`

## example 1
df <- data.frame(
  name  = c("Alice", "Bob"),
  score = c(80, 90),
  pass  = c(TRUE, TRUE)
)

nrow(df)  # 2
ncol(df)  # 3
dim(df)   # 2 3

# 2. Count Number of Characters: `nchar()`

## example 1
word1 <- "apple"
nchar(word1)

## example 2
words <- c(15, -3.5, TRUE)
nchar(words)

# 3. trim string: `substring()`

## example 1
str1 <- "Cat_and_Dog"
substr1 <- substring(str1, 1, 3)
print(substr1)

## example 2
str2 <- "aaaaHello!bbbb"
substr2 <- substring(str2, 5)
print(substr2)


# 4. Find patterns inside element: `grepl()`

## example 1: 
fruits <- c("apple", "banana", "pineapple", "pear")
grepl("apple", fruits) 

## example 2:
strings <- c("abcba", "acbcb", "abbbc", "babcc")
grepl("abc", strings)



# ==============================================
# 2. Summary Statistics Table
# ==============================================

# 1. Create contingency table object: `table()`

## using 'table' function to easily build contingency table within dataset
table <- table(loan$application_type, 
               loan$homeownership
)
print(table)
class(table)

## we can also specify the column name in the function arguments 
## by giving a vector of names to parameter `dnn`, which means "dimension names"
table <- table(loan$application_type, 
               loan$homeownership, 
               dnn = c("application type", 
                       "home ownership"
               )
)
print(table)
class(table)


# 2. Create sum column and sum row in contingency table: `addmargins()`
table_withsum <- addmargins(table)
print(table_withsum)
class(table_withsum)


# ==============================================
# 3. cor(), lm(), summary()
# ==============================================

# 1. Robust-standard error multiple regression: `lm_robust()`

lm_model_multiple_robust <- lm_robust(data = birth, weight ~ weeks + gender + visits)
summary(lm_model_multiple_robust)


# 2. Regression table: `screenreg()`

lm_model <- lm(data = birth, weight ~ weeks)
lm_model_multiple <- lm(data = birth, weight ~ weeks + gender + visits)

screenreg(
  list(lm_model, lm_model_multiple, lm_model_multiple_robust),
  custom.model.names = 
    c("Model 1: Single", "Model 2: Multiple", "Model 3: Multiple (Robust SE)"),
  include.ci = FALSE,
  digits = 3
)