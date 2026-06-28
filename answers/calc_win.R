calc_win <- function(dat) {
  linpred <- ifelse(dat$side == "emperor_side", -0.7, -3.0) +
    1.35 * dat$stress_level -
    0.85 * dat$tonegawa_pressure -
    0.55 * dat$decision_time +
    0.70 * dat$stress_level * dat$tonegawa_pressure -
    0.25 * dat$decision_time^2

  win_prob <- plogis(linpred)
  if_win <- rbinom(n = nrow(dat), size = 1, prob = win_prob)

  data.frame(if_win = if_win)
}
