# libraries
library(bayesplot)
library(cmdstanr)
library(ggplot2)
library(ggdist)
library(mcmcse)
library(posterior)
library(tidyverse)

# fit the linear model ---------------------------------------------------------
fit_simple_linear <- function(x, y, robust = FALSE) {
  # load the model
  if (!robust) {
    model <- cmdstan_model("./models/linear.stan")
  } else {
    model <- cmdstan_model("./models/linear_robust.stan")
  }

  # prep data
  stan_data <- list(n = length(x),
                    x = x,
                    y = y)

  # fit
  fit <- model$sample(
    data = stan_data,
    parallel_chains = 4,
    refresh = 0
  )

  print(mcmc_trace(fit$draws()))
  print(fit$summary())

  return(fit)
}

# compare the simple_lienear fit with a constant -------------------------------
compare_simple_linear <- function(fit, constant = 0) {
  # extract
  df_samples <- as_draws_df(fit$draws())

  # compare
  bigger <- mcse(df_samples$b > constant)
  smaller <- mcse(df_samples$b < constant)

  # extract
  bigger_prob <- round(bigger[[1]] * 100, 2)
  bigger_se <- round(bigger[[2]] * 100, 1)
  smaller_prob <- round(smaller[[1]] * 100, 2)
  smaller_se <- round(smaller[[2]] * 100, 1)

  # print results
  cat(paste0("# P(β > ", constant, ") = ",
             bigger_prob, " +/- ", bigger_se, "%\n"))
  cat(paste0("# P(β < ", constant, ") = ",
             smaller_prob, " +/- ", smaller_se, "%"))
}
