# libraries
library(bayesplot)
library(cmdstanr)
library(ggplot2)
library(ggdist)
library(mcmcse)
library(posterior)
library(tidyverse)


# fit the normal model ---------------------------------------------------------
fit_normal <- function(y) {
  # load the model
  model <- cmdstan_model("./models/normal.stan")

  # prep data
  stan_data <- list(n = length(y),
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


# compare two normal fits ------------------------------------------------------
compare_normal <- function(fit1, label1, fit2, label2) {
  # extract
  df_samples_1 <- as_draws_df(fit1$draws())
  df_samples_2 <- as_draws_df(fit2$draws())

  # compare
  bigger <- mcse(df_samples_1$mu > df_samples_2$mu)
  smaller <- mcse(df_samples_1$mu < df_samples_2$mu)

  # extract
  bigger_prob <- round(bigger[[1]] * 100, 2)
  bigger_se <- round(bigger[[2]] * 100, 2)
  smaller_prob <- round(smaller[[1]] * 100, 2)
  smaller_se <- round(smaller[[2]] * 100, 2)

  cat(paste0("# P(", label1, " > ", label2, ") = ",
             bigger_prob, " +/- ", bigger_se, "%\n"))
  cat(paste0("# P(", label1, " < ", label2, ") = ",
             smaller_prob, " +/- ", smaller_se, "%"))
}


# plot comparison between two normal fits --------------------------------------
plot_comparison_normal <- function(fit1, label1, fit2, label2) {
  # extract
  df_samples_1 <- as_draws_df(fit1$draws())
  df_samples_2 <- as_draws_df(fit2$draws())

  # prepare the df
  df_comparison <- data.frame(mu = df_samples_1$mu, label = label1)
  df_comparison <- df_comparison %>%
    add_row(data.frame(mu = df_samples_2$mu, label = label2))

  # plot
  p <- ggplot(data = df_comparison, aes(x = mu, y = label)) +
    stat_halfeye(fill = "skyblue", alpha = 0.75) +
    xlab("Mean") +
    ylab("")

  return(p)
}


# compare a normal fit with a constant -----------------------------------------
compare_normal <- function(fit, constant = 0, label1 = "", label2 = "") {
  # extract
  df_samples <- as_draws_df(fit$draws())

  # compare
  bigger <- mcse(df_samples$mu > constant)
  smaller <- mcse(df_samples$mu < constant)

  # extract
  bigger_prob <- round(bigger[[1]] * 100, 2)
  bigger_se <- round(bigger[[2]] * 100, 1)
  smaller_prob <- round(smaller[[1]] * 100, 2)
  smaller_se <- round(smaller[[2]] * 100, 1)

  # set label
  if (label2 == "") {
    label2 <- constant
  }

  # print results
  cat(paste0("# P(", label1, " > ", label2, ") = ",
             bigger_prob, " +/- ", bigger_se, "%\n"))
  cat(paste0("# P(", label1, " < ", label2, ") = ",
             smaller_prob, " +/- ", smaller_se, "%"))
}


# plot comparison between a normal fit and a constant --------------------------
plot_comparison_normal <- function(fit, constant = 0) {
  # extract
  df_samples <- as_draws_df(fit$draws())

  # prepare the df
  df_comparison <- data.frame(mu = df_samples$mu)

  # plot
  p <- ggplot(data = df_comparison, aes(x = mu)) +
    stat_halfeye(fill = "skyblue", alpha = 0.75) +
    geom_vline(xintercept = constant, linetype = "dashed",
               color = "grey50", size = 1) +
    xlab("Mean") +
    ylab("")

  return(p)
}
