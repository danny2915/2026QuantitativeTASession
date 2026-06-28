rm(list = ls())

library(tidyverse)
library(estimatr)

# ==============================================
# Import dataset
# ==============================================
acs <- read.csv("data/acs12.csv")


# ==============================================
# 1. Regular Expressions
# ==============================================

# 1. String Replacement: sub() and gsub()

text <- "apple apple apple"

sub("apple", "pear", text)
gsub("apple", "pear", text)

gsub("-", "/", c("2025-04-22", "2025-04-29"))


# 2. Regular Expressions: ^ and $

words <- c("cat", "catalog", "mycat")

grepl("^cat", words)
grepl("cat$", words)


# 3. Regular Expressions: [0-9]

text <- c("room12", "apple", "A7")

grepl("[0-9]", text)
gsub("[0-9]", "", text)


# 4. Regular Expressions: .

strings <- c("cat", "cot", "cut", "coat")

grepl("c.t", strings)


# 5. Regular Expressions: String Cleaning

weight <- c("52kg", "61kg", "48kg")

gsub("kg", "", weight)

gsub("[0-9]", "", weight)


# 6. Regular Expressions: * and +

strings <- c("a", "ab", "abb", "abbb", "ac")

grepl("ab*", strings)
grepl("ab+", strings)


# 7. Regular Expressions: Combining Symbols

emails <- c("alice@gmail.com", "bob@ntu.edu.tw")

sub("@.*", "", emails)


# ==============================================
# 2. Regressions
# ==============================================

# 1. Nonlinear Regression: Polynomial Terms

acs <- acs %>%
  na.omit() %>%
  mutate(univ = ifelse(edu == "hs or lower", 0, 1)) %>% 
  filter(income != 0)

acs <- acs %>%
  mutate(age2 = age * age)

lm_model_poly <- lm_robust(
  income ~ age + I(age^2),
  data = acs
)

# 2. Visualizing Regression: geom_smooth()

ggplot(acs, aes(x = age, y = income)) +
  geom_point() +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2)
  ) 

ggplot(acs, aes(x = age, y = income, color = citizen)) +
  geom_point() +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2)
  ) 

# 3. Nonlinear Regression: Interaction Terms

lm_model_interaction_1 <- lm_robust(
  income ~ age * univ,
  data = acs
)

lm_model_interaction_1

lm_model_interaction_2 <- lm_robust(
  income ~ age + univ + age:univ,
  data = acs
)

lm_model_interaction_2

# 4. Prediction: predict()

model <- lm_robust(income ~ hrs_work, data = acs)

low_hr <- data.frame(
  hrs_work = 40
)

high_hr <- data.frame(
  hrs_work = 42
)

predict(model, low_hr)

predict(model, high_hr)

predict(model, high_hr) - predict(model, low_hr)
