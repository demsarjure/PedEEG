library(cowplot)
library(ggplot2)
library(tidyverse)

# load data and models ---------------------------------------------------------
source("data.R")
source("./utils/normal.R")

# results storage --------------------------------------------------------------
df_results <- NULL
plots <- list()
robust <- FALSE

# compare control vs test ------------------------------------------------------
for (var in all_vars) {
    control <- df_control[[var]]
    test <- df_test[[var]]

    fit_control <- fit_normal(df_control$cp, robust = robust)
    fit_test <- fit_normal(df_test$cp, robust = robust)
    results <- compare_two_normal(
        fit1 = fit_control, label1 = "control",
        fit2 = fit_test, label2 = "test"
    )
    df_results <- rbind(
        df_results,
        data.frame(
            variable = var,
            c_bigger = results$bigger_prob,
            c_smaller = results$smaller_prob
        )
    )

    plot <- plot_comparison_two_normal(
        fit1 = fit_control, label1 = "control",
        fit2 = fit_test, label2 = "test"
    )

    plot <- plot +
        xlab("") +
        ggtitle(var) +
        theme(plot.title = element_text(hjust = 0.5))

    plots[[var]] <- plot
}

# plot results -----------------------------------------------------------------
# plot_grid(plotlist = plots, ncol = 4, scale = 0.90)
#
# ggsave("./figs/control_vs_test.pdf",
#     width = 3840,
#     height = 2160,
#     dpi = 450,
#     units = "px",
#     bg = "white"
# )
