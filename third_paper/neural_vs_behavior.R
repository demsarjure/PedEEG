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

p2 <- plots[["mod_vs_iq_memory"]] +
    xlab("Modularity") +
    ylab("IQ memory") +
    ggtitle("")

p3 <- plots[["mod_vs_iq_speed"]] +
    xlab("Modularity") +
    ylab("IQ speed") +
    ggtitle("")

plot_grid(p1, p2, p3, ncol = 1, scale = 0.9)

ggsave(
    "./figs/1_right.pdf",
    width = 1080,
    height = 1620,
    dpi = 300,
    units = "px",
    bg = "white"
)

# second plot, right panel -----------------------------------------------------
p1 <- plots[["mod_vs_motor"]] +
    xlab("Modularity") +
    ylab("Motor") +
    ggtitle("")

p2 <- plots[["tihs_vs_visual"]] +
    xlab("Interhemispheric strength") +
    ylab("Visual") +
    ggtitle("")

p3 <- plots[["cc_vs_visual"]] +
    xlab("Clustering coefficient") +
    ylab("Visual") +
    ggtitle("")

p4 <- plots[["sw_vs_visual"]] +
    xlab("Small-worldness") +
    ylab("Visual") +
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

# third plot, right panel ------------------------------------------------------
p1 <- plots[["cp_vs_omissions"]] +
    xlab("CP") +
    ylab("Omissions") +
    ggtitle("")

p2 <- plots[["tihs_vs_omissions"]] +
    xlab("IHS") +
    ylab("Omissions") +
    ggtitle("")

p3 <- plots[["cc_vs_omissions"]] +
    xlab("CC") +
    ylab("Omissions") +
    ggtitle("")

p4 <- plots[["sw_vs_omissions"]] +
    xlab("SW") +
    ylab("Omissions") +
    ggtitle("")

p5 <- plots[["cp_vs_perservation"]] +
    xlab("CP") +
    ylab("Perservation") +
    ggtitle("")

p6 <- plots[["tihs_vs_perservation"]] +
    xlab("IHS") +
    ylab("Perservation") +
    ggtitle("")

p7 <- plots[["cc_vs_perservation"]] +
    xlab("CC") +
    ylab("Perservation") +
    ggtitle("")

p8 <- plots[["sw_vs_perservation"]] +
    xlab("SW") +
    ylab("Perservation") +
    ggtitle("")

plot_grid(p1, p5, p2, p6, p3, p7, p4, p8, ncol = 2, scale = 0.9)

ggsave(
    "./figs/3_right.pdf",
    width = 1080,
    height = 1620,
    dpi = 300,
    units = "px",
    bg = "white"
)
