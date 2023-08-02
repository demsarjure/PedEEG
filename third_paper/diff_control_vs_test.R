library(cowplot)
library(ggplot2)
library(tidyverse)

# load data and models ---------------------------------------------------------
source("data.R")
source("./utils/normal.R")

# results storage --------------------------------------------------------------
df_results <- NULL
plots <- list()
robust <- TRUE

# compare control vs test ------------------------------------------------------
for (var in all_vars) {
    diff <- df_diff[[var]]

    fit_diff <- fit_normal(diff, robust = robust)
    results <- compare_normal(
        fit = fit_diff, label1 = "control", label2 = "test"
    )
    df_results <- rbind(
        df_results,
        data.frame(
            variable = var,
            c_bigger = results$bigger_prob,
            c_smaller = results$smaller_prob
        )
    )

    plot <- plot_comparison_normal(fit = fit_diff)
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
