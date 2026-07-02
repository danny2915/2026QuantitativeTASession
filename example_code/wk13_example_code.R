rm(list = ls())

library(tidyverse)
library(estimatr)
library(fixest)
library(texreg)

# ==============================================
# Import dataset
# ==============================================
gun <- read.csv("data/guns.csv")

gun <- gun %>% 
  mutate(lnvio = log(vio))


# ==============================================
# 1. Unique Function
# ==============================================

# 1. unique()

fruit <- c("apple", "banana", "apple", "orange", "banana")

fruit

unique(fruit)


# 2. unique() with panel data

states <- unique(gun$stateid)
years <- unique(gun$year)

states
years


# ==============================================
# 2. Panel Data
# ==============================================

# 1. A brief view of panel data

head(
  gun %>%
    select(stateid, year, vio, lnvio)
)


# 2. Simple OLS model

model_1 <- lm_robust(
  lnvio ~ shall,
  data = gun
)


# 3. OLS model with controls

model_2 <- lm_robust(
  lnvio ~ shall + density + avginc + pop + pb1064 +
    pw1064 + pm1029,
  data = gun
)


# 4. One-way fixed effect model

model_3 <- feols(
  lnvio ~ shall + incarc_rate + density + avginc +
    pop + pb1064 + pw1064 + pm1029 | stateid,
  data = gun
)


# 5. Two-way fixed effect model

model_4 <- feols(
  lnvio ~ shall + incarc_rate + density + avginc +
    pop + pb1064 + pw1064 + pm1029 | stateid + year,
  data = gun
)


# 6. Model comparison

screenreg(
  list(model_1, model_2, model_3, model_4),
  custom.model.names = c("Simple", "Control", "OWFE", "TWFE"),
  include.ci = FALSE
)


# 7. Without clustering

summary(model_4, vcov = "iid")


# 8. Clustered standard errors by state

summary(model_4, vcov = ~ stateid)
