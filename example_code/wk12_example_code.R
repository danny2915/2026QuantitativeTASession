rm(list = ls())

library(tidyverse)
library(estimatr)
library(pscl)
library(texreg)

# ==============================================
# Import dataset
# ==============================================
acs <- read.csv("data/acs12.csv")

acs <- acs %>%
  na.omit() %>%
  mutate(married = ifelse(married == "yes", 1, 0)) %>%
  filter(income != 0)


# ==============================================
# 1. Data Cleaning
# ==============================================

# 1. pivot_longer()

score_wide <- data.frame(
  student = c("Alice", "Bob"),
  quiz_1 = c(80, 90),
  quiz_2 = c(85, 95)
)

score_wide

score_long <- score_wide %>%
  pivot_longer(
    cols = c(quiz_1, quiz_2),
    names_to = "quiz",
    values_to = "score"
  )

score_long


# 2. pivot_wider()

score_wide_again <- score_long %>%
  pivot_wider(
    names_from = quiz,
    values_from = score
  )

score_wide_again


# ==============================================
# 2. Logarithmic Regression Models
# ==============================================

# 1. Create Log Variables

acs <- acs %>%
  mutate(
    lnincome = log(income),
    lnhrs_work = log(hrs_work)
  )


# 2. Estimate Four Regression Models

# Linear model
model1 <- lm_robust(
  income ~ hrs_work,
  data = acs
)

# Linear-Log model
model2 <- lm_robust(
  income ~ lnhrs_work,
  data = acs
)

# Log-Linear model
model3 <- lm_robust(
  lnincome ~ hrs_work,
  data = acs
)

# Log-Log model
model4 <- lm_robust(
  lnincome ~ lnhrs_work,
  data = acs
)

screenreg(
  list(model1, model2, model3, model4),
  custom.model.names = c("Linear", "Linear-Log", "Log-Linear", "Log-Log"),
  include.ci = FALSE
)


# 3. Prediction with Logarithmic Models

low_hr <- data.frame(
  hrs_work = 40,
  lnhrs_work = log(40)
)

high_hr <- data.frame(
  hrs_work = 42,
  lnhrs_work = log(42)
)

# Linear model
predict(model1, high_hr) - predict(model1, low_hr)

# Linear-Log model
predict(model2, high_hr) - predict(model2, low_hr)

# Log-Linear model
predict(model3, high_hr) - predict(model3, low_hr)
exp(predict(model3, high_hr)) - exp(predict(model3, low_hr))

# Log-Log model
predict(model4, high_hr) - predict(model4, low_hr)
exp(predict(model4, high_hr)) - exp(predict(model4, low_hr))


# ==============================================
# 3. Binary Regression Models
# ==============================================

# 1. Linear Probability Model

lpm <- lm_robust(
  married ~ age,
  data = acs
)


# 2. Logit and Probit Models

logit <- glm(
  married ~ age,
  data = acs,
  family = binomial(link = "logit")
)

probit <- glm(
  married ~ age,
  data = acs,
  family = binomial(link = "probit")
)


# 3. Model Comparison

screenreg(
  list(lpm, logit, probit),
  custom.model.names = c("LPM", "Logit", "Probit"),
  include.ci = FALSE
)


# 4. Prediction

young <- data.frame(age = 25)
old <- data.frame(age = 65)

predict(lpm, young)
predict(lpm, old)

predict(logit, young, type = "response")
predict(logit, old, type = "response")

predict(probit, young, type = "response")
predict(probit, old, type = "response")

# Difference in predicted probability
predict(lpm, old) - predict(lpm, young)
predict(logit, old, type = "response") - predict(logit, young, type = "response")
predict(probit, old, type = "response") - predict(probit, young, type = "response")


# 5. Pseudo R-squared

pR2(logit)
