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

        plot_key <- paste0(n_var, "_vs_", b_var)
        plots[[plot_key]] <- plot

        df_results <- rbind(
            df_results,
            data.frame(
                neural = n_var,
                behavior = b_var,
                positive = results$positive_prob,
                positive_se = results$positive_se,
                negative = results$negative_prob,
                negative_se = results$negative_se
            )
        )
    }
}

# first plot, right panel ------------------------------------------------------
p1 <- plots[["mod_vs_iq"]] +
    xlab("Modularity") +
    ylab("IQ") +
    ggtitle("")

p2 <- plots[["mod_vs_iq_speed"]] +
    xlab("Modularity") +
    ylab("Processing speed") +
    ggtitle("")

p3 <- plots[["cc_vs_iq"]] +
    xlab("Clustering coefficient") +
    ylab("IQ") +
    ggtitle("")

p4 <- NULL

plot_grid(p1, p2, p3, p4, ncol = 2, scale = 0.9)

ggsave(
    "./figs/1_right.pdf",
    width = 1080,
    height = 1080,
    dpi = 300,
    units = "px",
    bg = "white"
)

# second plot, right panel -----------------------------------------------------
p1 <- plots[["cp_vs_perservations"]] +
    xlab("CP") +
    ylab("perservations") +
    ggtitle("")

p2 <- plots[["tihs_vs_perservations"]] +
    xlab("IHS") +
    ylab("perservations") +
    ggtitle("")

p3 <- plots[["cc_vs_perservations"]] +
    xlab("CC") +
    ylab("perservations") +
    ggtitle("")

p4 <- plots[["sw_vs_perservations"]] +
    xlab("SW") +
    ylab("perservations") +
    ggtitle("")

plot_grid(p1, p2, p3, p4, ncol = 1, scale = 0.9)

ggsave(
    "./figs/2_right.pdf",
    width = 1080,
    height = 1620,
    dpi = 300,
    units = "px",
    bg = "white"
)
