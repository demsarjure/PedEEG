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

# compare the simple_linear fit with a constant -------------------------------
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
  cat(paste0("# P(b > ", constant, ") = ",
             bigger_prob, " +/- ", bigger_se, "%\n"))
  cat(paste0("# P(b < ", constant, ") = ",
             smaller_prob, " +/- ", smaller_se, "%"))
}

# plot the simple_linear-------------------------------
plot_simple_linear <- function(fit, min_x, max_x) {
  # get samples
  df_samples <- as_draws_df(fit$draws())

  # get mean averages
  a <- df_samples$a
  b <- df_samples$b

  # number of samples
  n <- length(a)

  df <- tibble(
    draw = 1:n,
    x = list(min_x:max_x),
    y = map2(a, b, ~ .x + .y * min_x:max_x)
  ) %>% unnest(c(x, y))

  p <- df %>%
    group_by(x) %>%
    median_qi(y, .width = c(.50, .90)) %>%
    ggplot(aes(x = x, y = y, ymin = .lower, ymax = .upper)) +
    geom_lineribbon(show.legend = FALSE, size = 0.5) +
    scale_fill_brewer() +
    theme_minimal()

  return(p)
}
