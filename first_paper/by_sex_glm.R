# libraries
library(cmdstanr)
library(ggplot2)
library(ggdist)
library(bayesplot)
library(posterior)
library(tidyverse)
library(mcmcse)

# compile the model ------------------------------------------------------------
model <- cmdstan_model("./models/linear_multiple_robust.stan")

# analysis ---------------------------------------------------------------------
datasets <- c("test", "validation")
bands <- c("theta", "alpha", "beta")
df_results <- data.frame(dataset = character(),
                         band = character(),
                         metric = character(),
                         age = numeric(),
                         mcse_age = numeric(),
                         sex = numeric(),
                         mcse_sex = numeric())

for (dataset in datasets) {
  for (band in bands) {
    # load the data
    if (dataset == "test") {
      source("data_test.R")
    } else {
      source("data_dataset.R")
    }

    # report
    cat(paste0("\n===> Processing: ", dataset, "_", band, "\n\n"))

    # sex to 0 and 1
    df$sex <- df$sex - 1

    # characteristic path ------------------------------------------------------
    # prep the data
    stan_data <- list(n = nrow(df),
                        age = df$age,
                        sex = df$sex,
                        y = df$cp)

    # fit
    fit_cp <- model$sample(
      data = stan_data,
      parallel_chains = 4,
      refresh = 0,
      show_messages = FALSE
    )

    # traceplot
    #mcmc_trace(fit_cp$draws())
    # summary
    #fit_cp$summary()

    # extract
    df_cp <- as_draws_df(fit_cp$draws())

    # compare and store result
    res_cp_age <- mcse(df_cp$b_age > 0)
    res_cp_sex <- mcse(df_cp$b_sex > 0)

    df_results <- df_results %>%
      add_row(data.frame(dataset = dataset,
                         band = band,
                         metric = "cp",
                         age = round(res_cp_age[[1]] * 100, 1),
                         mcse_age = round(res_cp_age[[2]] * 100, 1),
                         sex = round(res_cp_sex[[1]] * 100, 1),
                         mcse_sex = round(res_cp_sex[[2]] * 100, 1)))


    # global efficiency --------------------------------------------------------
    # prep the data
        stan_data <- list(n = nrow(df),
                        age = df$age,
                        sex = df$sex,
                        y = df$ge)

    # fit
    fit_ge <- model$sample(
      data = stan_data,
      parallel_chains = 4,
      refresh = 0,
      show_messages = FALSE
    )

    # traceplot
    #mcmc_trace(fit_ge$draws())
    # summary
    #fit_ge$summary()

    # extract
    df_ge <- as_draws_df(fit_ge$draws())

    # compare and store result
    res_ge_age <- mcse(df_ge$b_age > 0)
    res_ge_sex <- mcse(df_ge$b_sex > 0)

    df_results <- df_results %>%
      add_row(data.frame(dataset = dataset,
                         band = band,
                         metric = "ge",
                         age = round(res_ge_age[[1]] * 100, 1),
                         mcse_age = round(res_ge_age[[2]] * 100, 1),
                         sex = round(res_ge_sex[[1]] * 100, 1),
                         mcse_sex = round(res_ge_sex[[2]] * 100, 1)))

    # clustering coefficient ---------------------------------------------------
    # prep the data
    stan_data <- list(n = nrow(df),
                        age = df$age,
                        sex = df$sex,
                        y = df$cc)

    # fit
    fit_cc <- model$sample(
      data = stan_data,
      parallel_chains = 4,
      refresh = 0,
      show_messages = FALSE
    )

    # traceplot
    #mcmc_trace(fit_cc$draws())
    # summary
    #fit_cc$summary()

    # extract
    df_cc <- as_draws_df(fit_cc$draws())

    # compare and store result
    res_cc_age <- mcse(df_cc$b_age > 0)
    res_cc_sex <- mcse(df_cc$b_sex > 0)

    df_results <- df_results %>%
      add_row(data.frame(dataset = dataset,
                         band = band,
                         metric = "cc",
                         age = round(res_cc_age[[1]] * 100, 1),
                         mcse_age = round(res_cc_age[[2]] * 100, 1),
                         sex = round(res_cc_sex[[1]] * 100, 1),
                         mcse_sex = round(res_cc_sex[[2]] * 100, 1)))

    # small worldness ----------------------------------------------------------
    # prep the data
        stan_data <- list(n = nrow(df),
                        age = df$age,
                        sex = df$sex,
                        y = df$sw)

    # fit
    fit_sw <- model$sample(
      data = stan_data,
      parallel_chains = 4,
      refresh = 0,
      show_messages = FALSE
    )

    # traceplot
    #mcmc_trace(fit_sw$draws())
    # summary
    #fit_sw$summary()

    # extract
    df_sw <- as_draws_df(fit_sw$draws())

    # compare and store result
    res_sw_age <- mcse(df_sw$b_age > 0)
    res_sw_sex <- mcse(df_sw$b_sex > 0)

    df_results <- df_results %>%
      add_row(data.frame(dataset = dataset,
                         band = band,
                         metric = "sw",
                         age = round(res_sw_age[[1]] * 100, 1),
                         mcse_age = round(res_sw_age[[2]] * 100, 1),
                         sex = round(res_sw_sex[[1]] * 100, 1),
                         mcse_sex = round(res_sw_sex[[2]] * 100, 1)))

    # interhemispheric strength ------------------------------------------------
    # prep the data
        stan_data <- list(n = nrow(df),
                        age = df$age,
                        sex = df$sex,
                        y = df$tihs)

    # fit
    fit_tihs <- model$sample(
      data = stan_data,
      parallel_chains = 4,
      refresh = 0,
      show_messages = FALSE
    )

    # traceplot
    #mcmc_trace(fit_tihs$draws())
    # summary
    #fit_tihs$summary()

    # extract
    df_tihs <- as_draws_df(fit_tihs$draws())

    # compare and store result
    res_tihs_age <- mcse(df_tihs$b_age > 0)
    res_tihs_sex <- mcse(df_tihs$b_sex > 0)

    df_results <- df_results %>%
      add_row(data.frame(dataset = dataset,
                         band = band,
                         metric = "tihs",
                         age = round(res_tihs_age[[1]] * 100, 1),
                         mcse_age = round(res_tihs_age[[2]] * 100, 1),
                         sex = round(res_tihs_sex[[1]] * 100, 1),
                         mcse_sex = round(res_tihs_sex[[2]] * 100, 1)))

    # alpha peak ---------------------------------------------------------------
    if (band == "alpha") {
      # prep the data
      stan_data <- list(n = nrow(df),
                    age = df$age,
                    sex = df$sex,
                    y = df$ap)

      # fit
      fit_ap <- model$sample(
        data = stan_data,
        parallel_chains = 4,
        refresh = 0,
        show_messages = FALSE
      )

      # traceplot
      #mcmc_trace(fit_ap$draws())
      # summary
      #fit_ap$summary()

      # extract
      df_ap <- as_draws_df(fit_ap$draws())

      # compare and store result
      res_ap_age <- mcse(df_ap$b_age > 0)
      res_ap_sex <- mcse(df_ap$b_sex > 0)

      df_results <- df_results %>%
        add_row(data.frame(dataset = dataset,
                          band = band,
                          metric = "ap",
                          age = round(res_ap_age[[1]] * 100, 1),
                          mcse_age = round(res_ap_age[[2]] * 100, 1),
                          sex = round(res_ap_sex[[1]] * 100, 1),
                          mcse_sex = round(res_ap_sex[[2]] * 100, 1)))
    }
  }
}

# save results
write.table(df_results, file = "by_sex_linear_results.csv",
            sep = ",", row.names = FALSE)
