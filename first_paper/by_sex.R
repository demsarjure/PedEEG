# libraries
library(cmdstanr)
library(ggplot2)
library(ggdist)
library(bayesplot)
library(posterior)
library(tidyverse)
library(mcmcse)

# compile the model ------------------------------------------------------------
model <- cmdstan_model("./models/normal_robust.stan")

# analysis ---------------------------------------------------------------------
datasets <- c("test", "validation")
bands <- c("theta", "alpha", "beta")
df_results <- data.frame(dataset = character(),
                         band = character(),
                         metric = character(),
                         probability = numeric(),
                         mcse = numeric())

for (dataset in datasets) {
  for (band in bands) {
    # load the data
    if (dataset == "test") {
      source("data_test.R")
    } else {
      source("data_validation.R")
    }

    # report
    cat(paste0("\n===> Processing: ", dataset, "_", band, "\n\n"))

    # split into male and female -----------------------------------------------
    df_m <- df %>% filter(sex == 0)
    df_f <- df %>% filter(sex == 1)

    # characteristic path ------------------------------------------------------
    # prep the data
    stan_data_m <- list(n = nrow(df_m), y = df_m$cp)
    stan_data_f <- list(n = nrow(df_f), y = df_f$cp)

    # fit male
    fit_cp_m <- model$sample(
      data = stan_data_m,
      parallel_chains = 4,
      refresh = 0,
      show_messages = FALSE
    )

    # traceplot
    #mcmc_trace(fit_cp_m$draws())
    # summary
    #fit_cp_m$summary()

    # extract
    df_cp_m <- as_draws_df(fit_cp_m$draws())

    # fit
    fit_cp_f <- model$sample(
      data = stan_data_f,
      parallel_chains = 4,
      refresh = 0,
      show_messages = FALSE
    )

    # traceplot
    #mcmc_trace(fit_cp_f$draws())
    # summary
    #fit_cp_f$summary()

    # extract
    df_cp_f <- as_draws_df(fit_cp_f$draws())

    # compare and store result
    res_cp <- mcse(df_cp_f$mu > df_cp_m$mu)
    df_results <- df_results %>%
      add_row(data.frame(dataset = dataset,
                         band = band,
                         metric = "cp",
                         probability = round(res_cp[[1]] * 100, 1),
                         mcse = round(res_cp[[2]] * 100, 1)))

    # merge
    df_stats <- data.frame(Value = df_cp_m$mu,
                           sex = "M",
                           Metric = "Characteristic path")

    df_stats <- df_stats %>%
      add_row(data.frame(Value = df_cp_f$mu,
                         sex = "F",
                         Metric = "Characteristic path"))

    # global efficiency --------------------------------------------------------
    # prep the data
    stan_data_m <- list(n = nrow(df_m), y = df_m$ge)
    stan_data_f <- list(n = nrow(df_f), y = df_f$ge)

    # fit male
    fit_ge_m <- model$sample(
      data = stan_data_m,
      parallel_chains = 4,
      refresh = 0,
      show_messages = FALSE
    )

    # traceplot
    #mcmc_trace(fit_ge_m$draws())
    # summary
    #fit_ge_m$summary()

    # extract
    df_ge_m <- as_draws_df(fit_ge_m$draws())

    # fit
    fit_ge_f <- model$sample(
      data = stan_data_f,
      parallel_chains = 4,
      refresh = 0,
      show_messages = FALSE
    )

    # traceplot
    #mcmc_trace(fit_ge_f$draws())
    # summary
    #fit_ge_f$summary()

    # extract
    df_ge_f <- as_draws_df(fit_ge_f$draws())

    # compare and store result
    res_ge <- mcse(df_ge_f$mu > df_ge_m$mu)
    df_results <- df_results %>%
      add_row(data.frame(dataset = dataset,
                         band = band,
                         metric = "ge",
                         probability = round(res_ge[[1]] * 100, 1),
                         mcse = round(res_ge[[2]] * 100, 1)))

    # merge
    df_stats <- df_stats %>%
      add_row(data.frame(Value = df_ge_m$mu,
                         sex = "M",
                         Metric = "Global efficiency"))

    df_stats <- df_stats %>%
      add_row(data.frame(Value = df_ge_f$mu,
                         sex = "F",
                         Metric = "Global efficiency"))

    # clustering coefficient ---------------------------------------------------
    # prep the data
    stan_data_m <- list(n = nrow(df_m), y = df_m$cc)
    stan_data_f <- list(n = nrow(df_f), y = df_f$cc)

    # fit male
    fit_cc_m <- model$sample(
      data = stan_data_m,
      parallel_chains = 4,
      refresh = 0,
      show_messages = FALSE
    )

    # traceplot
    #mcmc_trace(fit_cc_m$draws())
    # summary
    #fit_cc_m$summary()

    # extract
    df_cc_m <- as_draws_df(fit_cc_m$draws())

    # fit
    fit_cc_f <- model$sample(
      data = stan_data_f,
      parallel_chains = 4,
      refresh = 0,
      show_messages = FALSE
    )

    # traceplot
    #mcmc_trace(fit_cc_f$draws())
    # summary
    #fit_cc_f$summary()

    # extract
    df_cc_f <- as_draws_df(fit_cc_f$draws())

    # compare and store result
    res_cc <- mcse(df_cc_f$mu > df_cc_m$mu)
    df_results <- df_results %>%
      add_row(data.frame(dataset = dataset,
                         band = band,
                         metric = "cc",
                         probability = round(res_cc[[1]] * 100, 1),
                         mcse = round(res_cc[[2]] * 100, 1)))

    # merge
    df_stats <- df_stats %>%
      add_row(data.frame(Value = df_cc_m$mu,
                         sex = "M",
                         Metric = "Clustering coefficient"))

    df_stats <- df_stats %>%
      add_row(data.frame(Value = df_cc_f$mu,
                         sex = "F",
                         Metric = "Clustering coefficient"))

    # small worldness ----------------------------------------------------------
    # prep the data
    stan_data_m <- list(n = nrow(df_m), y = df_m$sw)
    stan_data_f <- list(n = nrow(df_f), y = df_f$sw)

    # fit male
    fit_sw_m <- model$sample(
      data = stan_data_m,
      parallel_chains = 4,
      refresh = 0,
      show_messages = FALSE
    )

    # traceplot
    #mcmc_trace(fit_sw_m$draws())
    # summary
    #fit_sw_m$summary()

    # extract
    df_sw_m <- as_draws_df(fit_sw_m$draws())

    # fit
    fit_sw_f <- model$sample(
      data = stan_data_f,
      parallel_chains = 4,
      refresh = 0,
      show_messages = FALSE
    )

    # traceplot
    #mcmc_trace(fit_sw_f$draws())
    # summary
    #fit_sw_f$summary()

    # extract
    df_sw_f <- as_draws_df(fit_sw_f$draws())

    # compare and store result
    res_sw <- mcse(df_sw_f$mu > df_sw_m$mu)
    df_results <- df_results %>%
      add_row(data.frame(dataset = dataset,
                         band = band,
                         metric = "sw",
                         probability = round(res_sw[[1]] * 100, 1),
                         mcse = round(res_sw[[2]] * 100, 1)))

    # merge
    df_stats <- df_stats %>%
      add_row(data.frame(Value = df_sw_m$mu,
                         sex = "M",
                         Metric = "Small worldness"))

    df_stats <- df_stats %>%
      add_row(data.frame(Value = df_sw_f$mu,
                         sex = "F",
                         Metric = "Small worldness"))

    # interhemispheric strength ------------------------------------------------
    # prep the data
    stan_data_m <- list(n = nrow(df_m), y = df_m$tihs)
    stan_data_f <- list(n = nrow(df_f), y = df_f$tihs)

    # fit male
    fit_tihs_m <- model$sample(
      data = stan_data_m,
      parallel_chains = 4,
      refresh = 0,
      show_messages = FALSE
    )

    # traceplot
    #mcmc_trace(fit_tihs_m$draws())
    # summary
    #fit_tihs_m$summary()

    # extract
    df_tihs_m <- as_draws_df(fit_tihs_m$draws())

    # fit
    fit_tihs_f <- model$sample(
      data = stan_data_f,
      parallel_chains = 4,
      refresh = 0,
      show_messages = FALSE
    )

    # traceplot
    #mcmc_trace(fit_tihs_f$draws())
    # summary
    #fit_tihs_f$summary()

    # extract
    df_tihs_f <- as_draws_df(fit_tihs_f$draws())

    # compare and store result
    res_tihs <- mcse(df_tihs_f$mu > df_tihs_m$mu)
    df_results <- df_results %>%
      add_row(data.frame(dataset = dataset,
                         band = band,
                         metric = "tihs",
                         probability = round(res_tihs[[1]] * 100, 1),
                         mcse = round(res_tihs[[2]] * 100, 1)))

    # merge
    df_stats <- df_stats %>%
      add_row(data.frame(Value = df_tihs_m$mu,
                         sex = "M",
                         Metric = "IH strength"))

    df_stats <- df_stats %>%
      add_row(data.frame(Value = df_tihs_f$mu,
                         sex = "F",
                         Metric = "IH strength"))

    # alpha peak ---------------------------------------------------------------
    if (band == "alpha") {
      # prep the data
      df_ap_filter_m <- df_m %>% filter(ap != -1)
      df_ap_filter_f <- df_f %>% filter(ap != -1)
      stan_data_m <- list(n = nrow(df_ap_filter_m), y = df_ap_filter_m$ap)
      stan_data_f <- list(n = nrow(df_ap_filter_f), y = df_ap_filter_f$ap)

      # fit male
      fit_ap_m <- model$sample(
        data = stan_data_m,
        parallel_chains = 4,
        refresh = 0,
        show_messages = FALSE
      )

      # traceplot
      #mcmc_trace(fit_ap_m$draws())
      # summary
      #fit_ap_m$summary()

      # extract
      df_ap_m <- as_draws_df(fit_ap_m$draws())

      # fit
      fit_ap_f <- model$sample(
        data = stan_data_f,
        parallel_chains = 4,
        refresh = 0,
        show_messages = FALSE
      )

      # traceplot
      #mcmc_trace(fit_ap_f$draws())
      # summary
      #fit_ap_f$summary()

      # extract
      df_ap_f <- as_draws_df(fit_ap_f$draws())

      # compare and store result
      res_ap <- mcse(df_ap_f$mu > df_ap_m$mu)
      df_results <- df_results %>%
        add_row(data.frame(dataset = dataset,
                           band = band,
                           metric = "ap",
                           probability = round(res_ap[[1]] * 100, 1),
                           mcse = round(res_ap[[2]] * 100, 1)))

      # merge
      df_stats <- df_stats %>%
        add_row(data.frame(Value = df_ap_m$mu,
                           sex = "M",
                           Metric = "Individual alpha frequency"))

      df_stats <- df_stats %>%
        add_row(data.frame(Value = df_ap_f$mu,
                           sex = "F",
                           Metric = "Individual alpha frequency"))
    }

    # plot ---------------------------------------------------------------------
    # factors
    df_stats$Metric <-
      factor(df_stats$Metric,
             levels = c("Characteristic path",
                        "Global efficiency",
                        "Clustering coefficient",
                        "Small worldness",
                        "IH strength",
                        "Individual alpha frequency"))

    if (band == "alpha") {
      n_col <- 3
    } else {
      n_col <- 5
    }

    # english plot
    ggplot(data = df_stats, aes(x = Value, y = sex)) +
      stat_pointinterval(fill = "skyblue", alpha = 0.75, .width = c(.5, .95)) +
      facet_wrap(. ~ Metric, scales = "free", ncol = n_col) +
      theme(panel.spacing = unit(2, "lines")) +
      xlab("value") +
      ylab("sex")

    if (band == "alpha") {
      ggsave(paste0("figs/by_sex_", dataset, "_", band, ".png"),
            width = 3840,
            height = 2160,
            dpi = 400,
            units = "px")
    } else {
      ggsave(paste0("figs/by_sex_", dataset, "_", band, ".png"),
            width = 3840,
            height = 1080,
            dpi = 350,
            units = "px")
    }

    # slovenian plot
    df_stats_si <- df_stats
    mapping <- c("Characteristic path" = "Značilna dolžina poti",
                  "Global efficiency" = "Globalna učinkovitost",
                  "Clustering coefficient" = "Koeficient kopičenja",
                  "Small worldness" = "Indeks majhnih svetov",
                  "IH strength" = "Interhemisferična moč",
                  "Individual alpha frequency" = "Individualni vrh alfa frekvence")
    df_stats_si <- df_stats %>%
      mutate(Metric = recode(Metric, !!!mapping))

    ggplot(data = df_stats_si, aes(x = Value, y = sex)) +
      stat_pointinterval(fill = "skyblue", alpha = 0.75, .width = c(.5, .95)) +
      facet_wrap(. ~ Metric, scales = "free", ncol = n_col) +
      theme(panel.spacing = unit(2, "lines")) +
      xlab("vrednost") +
      ylab("spol")

    if (band == "alpha") {
      ggsave(paste0("figs/by_sex_", dataset, "_", band, "_si.png"),
            width = 3840,
            height = 2160,
            dpi = 400,
            units = "px")
    } else {
      ggsave(paste0("figs/by_sex_", dataset, "_", band, "_si.png"),
            width = 3840,
            height = 1080,
            dpi = 350,
            units = "px")
    }
  }
}

# save results
write.table(df_results, file = "./results/by_sex.csv",
            sep = ",", row.names = FALSE)
