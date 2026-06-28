
library(tidyverse)

# ==============================================
# 1. rm(list = ls())
# ==============================================

# 1. Remove Everything: `rm(list = ls())`
rm(list = ls())

# 2. Return character vector of object names `ls()`
x <- 1
y <- "hi"
ls()

# ==============================================
# Import dataset
# ==============================================
birth <- read.csv("data/ncbirths.csv")

# ==============================================
# 2. colnames()
# ==============================================

# 1. Assign Column Names: `colnames()`

## rename a dataframe's column names
df <- data.frame(a = 1:3, b = 4:6)
colnames(df) <- c("height", "weight")

## rename a matrix's column names
m <- matrix(1:6, nrow = 3)
colnames(m) <- c("col1", "col2") 


# ==============================================
# 3. na.omit(), as.numeric()
# ==============================================

# 1. Remove Missing Values: `na.omit()`

## example 1: vector
x <- c(1, NA, 3, NA, 5)
x_clean <- na.omit(x)
print(x_clean)
as.vector(x_clean) # you can use as.vector() to remove attributes

## example 2: dataframe
df <- data.frame(
  x = c(1, NA, 3, 4, NA),
  y = c(10, 20, NA, 40, 50)
) %>%
  na.omit()
print(df)

# 2. Create Numeric Type Object: `as.numeric()`
logical_to_num <- as.numeric(c(TRUE, FALSE, TRUE))
character_to_num <- as.numeric(c("0", "1.1", "-6.5"))

print(logical_to_num)
print(character_to_num)


# ==============================================
# 4. cor(), lm(), summary()
# ==============================================

# 1. Before regression, first detect correlation: `cor()`

## correlation coefficient between two variables
cor(birth$weeks, birth$weight)

## correlation matrix
birth %>% 
  na.omit() %>%
  select(mage, gained, weeks, weight) %>% 
  cor()


# 2. Linear regression model: `lm()`
lm_model <- lm(data = birth, weight ~ weeks)
print(lm_model)

lm_model_multiple <- lm(data = birth, weight ~ weeks + gender + visits)
print(lm_model_multiple)

# 3. Obtain the result of linear regression: `summary()`
summary(lm_model)
summary(lm_model)$coefficient
summary(lm_model)$coefficient[1]
summary(lm_model)$coefficient[2]
summary(lm_model)$r.squared


summary(lm_model_multiple)

# =====================================================
# 5. geom_point(), scale_x_continuous(), geom_abline()
# =====================================================


# 1. scatter plot: `geom_point()`
ggplot(birth, aes(x = weeks, y = weight)) +
  geom_point(color = "steelblue", size = 2.5) +
  labs(
    x = "Birth Weeks",
    y = "Baby Weight (pounds)"
  )

# 2. Adjust the scale of x and y-axis: `scale_x_continuous()` or `scale_y_continuous()`

## We want to change the scales and labels of x, y-axis in the plot to make it more readable
ggplot(birth, aes(x = weeks, y = weight)) +
  geom_point(color = "steelblue", size = 2.5) +
  labs(
    x = "Birth Weeks",
    y = "Baby Weight (pounds)"
  ) +
  scale_x_continuous(
    limits = c(20, 45),
    breaks = c(20, 25, 30, 35, 40, 45)
  ) +
  scale_y_continuous(
    limits = c(0, 12),
    breaks = c(0, 4, 8, 12),
    labels = c("0 lb", "4 lb", "8 lb", "12 lb")
  )


# 3. Adding fitted line on scatter plot: `geom_abline()`

## obtain the estimated coefficients
intercept <- summary(lm_model)$coefficient[1]
slope <- summary(lm_model)$coefficient[2]

## add the fitted line
ggplot(birth, aes(x = weeks, y = weight)) +
  geom_point(color = "steelblue", size = 2.5) +
  labs(
    x = "Birth Weeks",
    y = "Baby Weight (pounds)"
  ) +
  scale_x_continuous(
    limits = c(20, 45),
    breaks = c(20, 25, 30, 35, 40, 45)
  ) +
  scale_y_continuous(
    limits = c(0, 12),
    breaks = c(0, 4, 8, 12),
    labels = c("0 lb", "4 lb", "8 lb", "12 lb")
  ) +
  geom_abline(slope = slope, 
              intercept = intercept, 
              color = "lightcoral", 
              linetype = "dashed"
  )

