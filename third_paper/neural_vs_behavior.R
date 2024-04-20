library(ggplot2)
library(tidyverse)
library(cowplot)

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

        data <- data.frame(x = scaled_neural, y = scaled_behavior)
        plot <- plot_simple_linear(linear_fit, data = data)

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

# comparisons ------------------------------------------------------------------
plot_comparisons <- list()
plot_comparisons[["cp_vs_perservations"]] <- plots[["cp_vs_perservations"]] +
    xlab("Characteristic path") +
    ylab("Perservations") +
    ggtitle("")

plot_comparisons[["tihs_vs_perservations"]] <- plots[["tihs_vs_perservations"]] +
    xlab("Interhemispheric strength") +
    ylab("Perservations") +
    ggtitle("")

plot_comparisons[["cc_vs_perservations"]] <- plots[["cc_vs_perservations"]] +
    xlab("Clustering coefficient") +
    ylab("Perservations") +
    ggtitle("")

plot_comparisons[["sw_vs_perservations"]] <- plots[["sw_vs_perservations"]] +
    xlab("Small world index") +
    ylab("Perservations") +
    ggtitle("")

plot_comparisons[["mod_vs_iq"]] <- plots[["mod_vs_iq"]] +
    xlab("Modularity") +
    ylab("IQ") +
    ggtitle("")

plot_comparisons[["mod_vs_iq_speed"]] <- plots[["mod_vs_iq_speed"]] +
    xlab("Modularity") +
    ylab("Processing speed") +
    ggtitle("")

plot_comparisons[["cc_vs_iq"]] <- plots[["cc_vs_iq"]] +
    xlab("Clustering coefficient") +
    ylab("IQ") +
    ggtitle("")

# english plot
plot_grid(plotlist = plot_comparisons, ncol = 4, scale = 0.9)
ggsave(
    "./figs/comparisons.png",
    width = 1920,
    height = 1080,
    dpi = 150,
    units = "px",
    bg = "white"
)

# slovenian plot
plot_comparisons[["cp_vs_perservations"]] <- plot_comparisons[["cp_vs_perservations"]] +
    xlab("Značilna dolžina poti") +
    ylab("Perzervacije")

plot_comparisons[["tihs_vs_perservations"]] <- plot_comparisons[["tihs_vs_perservations"]] +
    xlab("Interhemisferična moč") +
    ylab("Perzervacije")

plot_comparisons[["cc_vs_perservations"]] <- plot_comparisons[["cc_vs_perservations"]] +
    xlab("Koeficient kopičenja") +
    ylab("Perzervacije")

plot_comparisons[["sw_vs_perservations"]] <- plot_comparisons[["sw_vs_perservations"]] +
    xlab("Indeks majhnih svetov") +
    ylab("Perzervacije")

plot_comparisons[["mod_vs_iq"]] <- plot_comparisons[["mod_vs_iq"]] +
    xlab("Modularnost") +
    ylab("IQ")

plot_comparisons[["mod_vs_iq_speed"]] <- plot_comparisons[["mod_vs_iq_speed"]] +
    xlab("Modularnost") +
    ylab("Processing speed")

plot_comparisons[["cc_vs_iq"]] <- plot_comparisons[["cc_vs_iq"]] +
    xlab("Koeficient kopičenja") +
    ylab("IQ")

plot_grid(plotlist = plot_comparisons, ncol = 4, scale = 0.9)
ggsave(
    "./figs/comparisons_si.png",
    width = 1920,
    height = 1080,
    dpi = 150,
    units = "px",
    bg = "white"
)
