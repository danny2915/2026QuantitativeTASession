calc_win <- function(dat) {
  win_prob <- ifelse(dat$side == "emperor_side", 0.36, 0.06) -
    0.42 * dat$kaiji_stress -
    0.02 * dat$tonegawa_pressure -
    0.01 * dat$decision_time
  
  win_prob <- pmin(pmax(win_prob, 0.01), 0.99)
  
  data.frame(
    if_win = rbinom(n = nrow(dat), size = 1, prob = win_prob)
  )
}