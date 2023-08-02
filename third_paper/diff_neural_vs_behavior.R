library(ggplot2)
library(tidyverse)

# load data and models ---------------------------------------------------------
source("data.R")
source("./utils/simple_linear.R")

# results storage --------------------------------------------------------------
df_results <- NULL
plots <- list()
robust <- FALSE

# neural vs behavior -----------------------------------------------------------
for (n_var in neural_vars) {
    neural <- df_diff[[n_var]]

    for (b_var in behavior_vars) {
        behavior <- df_diff[[b_var]]
        scaled_neural <- scale(neural)
        scaled_behavior <- scale(behavior)

        linear_fit <- fit_simple_linear(
            scaled_neural,
            scaled_behavior,
            robust = robust
        )
        results <- compare_simple_linear(linear_fit)

        x <- max(scaled_neural)
        plot <- plot_simple_linear(linear_fit, min_x = -x, max_x = x)

        plot <- plot +
            xlab(n_var) +
            ylab(b_var) +
            ggtitle(paste0(n_var, " vs. ", b_var)) +
            theme(plot.title = element_text(hjust = 0.5))

        df_results <- rbind(
            df_results,
            data.frame(
                neural = n_var,
                behavior = b_var,
                positive = results$positive_prob,
                negative = results$negative_prob
            )
        )
    }
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
