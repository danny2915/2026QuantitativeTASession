rm(list = ls())

library(tidyverse)
library(estimatr)
library(car)

# ==============================================
# Import dataset
# ==============================================
birth <- read.csv("data/ncbirths.csv")

# ==============================================
# 1. Random Number Generator
# ==============================================

# 1. set random seed (for replication): "set.seed()"

set.seed(20260407)

# 2. draw random number from uniform distribution: "runif()"

## draw 20 samples from uniform distribution [0, 1] (default min/max)
rdnum <- runif(10)
print(rdnum)
class(rdnum)

## draw 30 samples from uniform distribution [0, 100]
rdnum_2 <- runif(n = 10, min = 0, max = 100)
print(rdnum_2)
class(rdnum_2)

# 3. random number draw from normal distribution: "rnorm()"

## draw 10 samples from normal distribution (mean = 0, sd = 1) (default)
rdnum <- rnorm(10)
print(rdnum)
class(rdnum)

## draw 10 samples from normal distribution (mean = 60, sd = 15)
rdnum_2 <- rnorm(n = 10, mean = 60, sd = 15)
print(rdnum_2)
class(rdnum_2)


# 4. random number draw from binomial distribution: "rbinom()"

## draw 20 samples from binomial distribution, each sample expreienced 5 times bernoulli with probability = .5
rdnum <- rbinom(n = 30, size = 20, prob = .5)
print(rdnum)
class(rdnum)
print(mean(rdnum))


# 5. draw random number from poisson distribution: `rpois()`

# draw 20 samples from poisson distribution (lambda = 5), and plot sample histogram
rdnum_pois <- rpois(n = 20, lambda = 5)
print(rdnum_pois)
# draw 1,000 samples from poisson distribution (lambda = 5), and plot sample histogram
rdnum_pois_2 <- rpois(n = 1000, lambda = 5)
ggplot() +
  geom_histogram(mapping = aes(x = rdnum_pois_2))

# 6. draw random number from exponential distribution: `rexp()`

## draw 20 samples from exponential distribution (rate = 5)
rdnum_exp <- rexp(20, rate = 5)
rdnum_exp <- round(rdnum_exp, digits = 6)
print(rdnum_exp)

rdnum_exp_2 <- rexp(1000, rate = 5)
ggplot() +
  geom_histogram(mapping = aes(x = rdnum_exp_2))


# ==============================================
# 2. Data Wrangling: Combine Dataset
# ==============================================

# 1. combine two different dataset by rows

## first, let's draw two different sets of random sample
rdnum_pois_20 <- rpois(n = 20, lambda = 5)
rdnum_pois_10000 <- rpois(n = 10000, lambda = 5)

## using the two sets of random sample, build two DataFrames respectively
df_20 <- data.frame(
  size = 20,
  values = rdnum_pois_20
)
df_10000 <- data.frame(
  size = 10000,
  values = rdnum_pois_10000
)

## combine the two DataFrames together, and draw the histogram
df <- rbind(df_20, df_10000)

ggplot(df, aes(x = values)) +
  geom_histogram() +
  facet_wrap(~size, scales = "free_y")


# 2. combine two different dataset by columns

## first, let's draw two different sets of random sample
rdnum_pois_param5 <- rpois(n = 1000, lambda = 5)
rdnum_pois_param20 <- rpois(n = 1000, lambda = 20)

## using the two sets of random sample, build two DataFrames respectively
df_param5 <- data.frame(
  values_param5 = rdnum_pois_param5
)
df_param20 <- data.frame(
  values_param20 = rdnum_pois_param20
)

## combine the two DataFrames together, and draw the histogram
df <- cbind(df_param5, df_param20)
ggplot(df) +
  geom_histogram(mapping = aes(x = values_param5, 
                               fill = "lambda = 5"), 
                 alpha = 0.7
  ) +
  geom_histogram(mapping = aes(x = values_param20, 
                               fill = "lambda = 20"), 
                 alpha = 0.7
  )


# ==============================================
# 3. Standardization
# ==============================================

# 1. Standardize Variables: `scale()`

## Default: center = TRUE, scale = TRUE
score <- c(70, 80, 75, 95)
scale(score)

## With scale = TRUE (Devided by standard deviation only)
scale(score, center = FALSE, scale = TRUE)


# ==============================================
# 4. Multiple Regression
# ==============================================

# 1. Multiple Testing: `linearHypothesis()`

lm_model_multiple_robust <- lm_robust(
  data = birth, 
  weight ~ weeks + gender + visits
)

## Test 1
linearHypothesis(
  lm_model_multiple_robust,
  c("weeks = 0", "visits = 0"),
  test = "F"
)

## Test 2
linearHypothesis(
  lm_model_multiple_robust,
  c("weeks = visits"),
  test = "F"
)
