rm(list = ls())

library(tidyverse)
library(estimatr)
library(ivreg)
library(lmtest)
library(sandwich)
library(texreg)


# ==============================================
# Import dataset
# ==============================================
smoke <- wooldridge::smoke


# ==============================================
# 1. Instrumental Variable (IV) Regression
# ==============================================

# 1. OLS model

ols <- lm_robust(
  lincome ~ cigs + educ + age + agesq,
  data = smoke
)


# 2. IV model

iv <- ivreg(
  lincome ~ cigs + educ + age + agesq |
    restaurn + educ + age + agesq,
  data = smoke
)


# 3. Model comparison

screenreg(
  list(ols, iv),
  custom.model.names = c("OLS", "IV"),
  include.ci = FALSE,
  digits = 4
)


# 4. IV estimation with robust SE

coeftest(iv, vcov = sandwich)


# ==============================================
# 2. IV Validity
# ==============================================

# 1. First stage regression

first <- lm_robust(
  cigs ~ restaurn + age + agesq,
  data = smoke
)


# 2. Check the F-statistic

summary(first)

# 3. Perform a J-test

iv_overid <- ivreg(
  lincome ~ cigs + educ + age + agesq |
    restaurn + cigpric + educ + age + agesq,
  data = smoke
)

summary(iv_overid, diagnostics = TRUE)
