# libraries
library(cmdstanr)
library(ggplot2)
library(ggdist)
library(cowplot)
library(bayesplot)
library(posterior)
library(tidyverse)
library(mcmcse)

# compile the model ------------------------------------------------------------
model <- cmdstan_model("./models/linear_robust.stan")

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

    # characteristic path ------------------------------------------------------
    # prep the data
    stan_data <- list(n = nrow(df), x = df$age, y = df$cp)

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

    # store result
    res_cp <- mcse(df_cp$b > 0)
    df_results <- df_results %>%
      add_row(data.frame(dataset = dataset,
                         band = band,
                         metric = "cp",
                         probability = round(res_cp[[1]] * 100, 1),
                         mcse = round(res_cp[[2]] * 100, 1)))

    # plot
    df_plot <- tibble(
        .draw = df_cp$.draw,
        intercept = df_cp$a,
        slope = df_cp$b,
        x = list(5:18),
        y = map2(intercept, slope, ~ .x + .y * 5:18)
    )
    df_plot <- df_plot %>% unnest(c(x, y))

    p1 <- ggplot(data = df_plot, aes(x = x, y = y)) +
      stat_lineribbon(.width = c(.95), alpha = 0.5, size = 1) +
      geom_point(data = df,
                 aes(x = age, y = cp),
                 color = "grey25",
                 alpha = 0.5,
                 shape = 16) +
      scale_fill_manual(values = c("grey75")) +
      ggtitle("Characteristic path") +
      xlab("age") +
      ylab("Value") +
      theme(legend.position = "none")

    # global efficiency coefficient --------------------------------------------
    # prep the data
    stan_data <- list(n = nrow(df), x = df$age, y = df$ge)

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

    # store result
    res_ge <- mcse(df_ge$b > 0)
    df_results <- df_results %>%
      add_row(data.frame(dataset = dataset,
                         band = band,
                         metric = "ge",
                         probability = round(res_ge[[1]] * 100, 1),
                         mcse = round(res_ge[[2]] * 100, 1)))

    # plot
    df_plot <- tibble(
      .draw = df_ge$.draw,
      intercept = df_ge$a,
      slope = df_ge$b,
      x = list(5:18),
      y = map2(intercept, slope, ~ .x + .y * 5:18)
    )
    df_plot <- df_plot %>% unnest(c(x, y))

    p2 <- ggplot(data = df_plot, aes(x = x, y = y)) +
      stat_lineribbon(.width = c(.95), alpha = 0.5, size = 1) +
      geom_point(data = df,
                 aes(x = age, y = ge),
                 color = "grey25",
                 alpha = 0.5,
                 shape = 16) +
      scale_fill_manual(values = c("grey75")) +
      ggtitle("Global efficiency") +
      xlab("age") +
      ylab("Value") +
      theme(legend.position = "none")

    # clustering coefficient ---------------------------------------------------
    # prep the data
    stan_data <- list(n = nrow(df), x = df$age, y = df$cc)

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

    # store result
    res_cc <- mcse(df_cc$b > 0)
    df_results <- df_results %>%
      add_row(data.frame(dataset = dataset,
                         band = band,
                         metric = "cc",
                         probability = round(res_cc[[1]] * 100, 1),
                         mcse = round(res_cc[[2]] * 100, 1)))

    # plot
    df_plot <- tibble(
      .draw = df_cc$.draw,
      intercept = df_cc$a,
      slope = df_cc$b,
      x = list(5:18),
      y = map2(intercept, slope, ~ .x + .y * 5:18)
    )
    df_plot <- df_plot %>% unnest(c(x, y))

    p3 <- ggplot(data = df_plot, aes(x = x, y = y)) +
      stat_lineribbon(.width = c(.95), alpha = 0.5, size = 1) +
      geom_point(data = df,
                 aes(x = age, y = cc),
                 color = "grey25",
                 alpha = 0.5,
                 shape = 16) +
      scale_fill_manual(values = c("grey75")) +
      ggtitle("Clustering coefficient") +
      xlab("age") +
      ylab("Value") +
      theme(legend.position = "none")

    # small worldness ----------------------------------------------------------
    # prep the data
    stan_data <- list(n = nrow(df), x = df$age, y = df$sw)

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

    # store result
    res_sw <- mcse(df_sw$b > 0)
    df_results <- df_results %>%
      add_row(data.frame(dataset = dataset,
                         band = band,
                         metric = "sw",
                         probability = round(res_sw[[1]] * 100, 1),
                         mcse = round(res_sw[[2]] * 100, 1)))

    # plot
    df_plot <- tibble(
      .draw = df_sw$.draw,
      intercept = df_sw$a,
      slope = df_sw$b,
      x = list(5:18),
      y = map2(intercept, slope, ~ .x + .y * 5:18)
    )
    df_plot <- df_plot %>% unnest(c(x, y))

    p4 <- ggplot(data = df_plot, aes(x = x, y = y)) +
      stat_lineribbon(.width = c(.95), alpha = 0.5, size = 1) +
      geom_point(data = df,
                 aes(x = age, y = sw),
                 color = "grey25",
                 alpha = 0.5,
                 shape = 16) +
      scale_fill_manual(values = c("grey75")) +
      ggtitle("Small worldness") +
      xlab("age") +
      ylab("Value") +
      theme(legend.position = "none")

    # interhemispheric strength ------------------------------------------------
    # prep the data
    stan_data <- list(n = nrow(df), x = df$age, y = df$tihs)

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

    # store result
    res_tihs <- mcse(df_tihs$b > 0)
    df_results <- df_results %>%
      add_row(data.frame(dataset = dataset,
                         band = band,
                         metric = "tihs",
                         probability = round(res_tihs[[1]] * 100, 1),
                         mcse = round(res_tihs[[2]] * 100, 1)))

    # plot
    df_plot <- tibble(
      .draw = df_tihs$.draw,
      intercept = df_tihs$a,
      slope = df_tihs$b,
      x = list(5:18),
      y = map2(intercept, slope, ~ .x + .y * 5:18)
    )
    df_plot <- df_plot %>% unnest(c(x, y))

    p5 <- ggplot(data = df_plot, aes(x = x, y = y)) +
      stat_lineribbon(.width = c(.95), alpha = 0.5, size = 1) +
      geom_point(data = df,
                 aes(x = age, y = tihs),
                 color = "grey25",
                 alpha = 0.5,
                 shape = 16) +
      scale_fill_manual(values = c("grey75")) +
      ggtitle("Interhemispheric strength") +
      xlab("age") +
      ylab("Value") +
      theme(legend.position = "none")

    # alpha peak ---------------------------------------------------------------
    if (band == "alpha") {
      # prep the data
      df_ap_filter <- df %>% filter(ap != -1)
      stan_data <- list(n = nrow(df_ap_filter),
                        x = df_ap_filter$age,
                        y = df_ap_filter$ap)

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

      # store result
      res_ap <- mcse(df_ap$b > 0)
      df_results <- df_results %>%
        add_row(data.frame(dataset = dataset,
                           band = band,
                           metric = "ap",
                           probability = round(res_ap[[1]] * 100, 1),
                           mcse = round(res_ap[[2]] * 100, 1)))

      # plot
      df_plot <- tibble(
        .draw = df_ap$.draw,
        intercept = df_ap$a,
        slope = df_ap$b,
        x = list(5:18),
        y = map2(intercept, slope, ~ .x + .y * 5:18)
      )
      df_plot <- df_plot %>% unnest(c(x, y))

      # df_ap_plot
      p6 <- ggplot(data = df_plot, aes(x = x, y = y)) +
        stat_lineribbon(.width = c(.95), alpha = 0.5, size = 1) +
        geom_point(data = df_ap_filter,
                   aes(x = age, y = ap),
                   color = "grey25",
                   alpha = 0.5,
                   shape = 16) +
        scale_fill_manual(values = c("grey75")) +
        ggtitle("Individual alpha frequency") +
        xlab("age") +
        ylab("Value") +
        theme(legend.position = "none")
    }

    # plot ---------------------------------------------------------------------
    if (band == "alpha") {
      plot_grid(p1, p2, p3, p4, p5, p6, scale = 0.95)
      ggsave(paste0("figs/by_age_", dataset, "_", band, ".png"),
             width = 3840,
             height = 2160,
             dpi = 250,
             units = "px",
             bg = "white")
    } else {
      plot_grid(p1, p2, p3, p4, p5, scale = 0.95, ncol = 5)
      ggsave(paste0("figs/by_age_", dataset, "_", band, ".png"),
             width = 3840,
             height = 1080,
             dpi = 250,
             units = "px",
             bg = "white")
    }
  }
}

# save results
write.table(df_results, file = "./results/by_age.csv",
            sep = ",", row.names = FALSE)
