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
            c_bigger_se = results$bigger_se,
            c_smaller = results$smaller_prob,
            c_smaller_se = results$smaller_se
        )
    )

    if (results$bigger_prob > results$smaller_prob) {
        prob <- results$bigger_prob
    } else {
        prob <- results$smaller_prob
    }

    plot <- plot_comparison_normal(fit = fit_diff, prob)
    plot <- plot +
        xlab("") +
        ggtitle(var) +
        theme(plot.title = element_text(hjust = 0.5))

    plots[[var]] <- plot
}

# test vs group cognition ------------------------------------------------------
plots_cognition <- list()
plots_cognition[["iq"]] <- plots[["iq"]] +
    xlim(-40, 40) +
    ggtitle("IQ")

plots_cognition[["iq_memory"]] <- plots[["iq_memory"]] +
    xlim(-30, 30) +
    ggtitle("Working memory")

plots_cognition[["iq_speed"]] <- plots[["iq_speed"]] +
    xlim(-30, 30) +
    ggtitle("Processing speed")

plots_cognition[["visual_motor"]] <- plots[["visual_motor"]] +
    xlim(-15, 15) +
    ggtitle("VMI")

plots_cognition[["motor"]] <- plots[["motor"]] +
    xlim(-15, 15) +
    ggtitle("Motor coordination")

plots_cognition[["visual"]] <- plots[["visual"]] +
    xlim(-15, 15) +
    ggtitle("Visual perception")

plots_cognition[["omissions"]] <- plots[["omissions"]] +
    xlim(-10, 10) +
    ggtitle("Omissions")

plots_cognition[["comissions"]] <- plots[["comissions"]] +
    xlim(-15, 15) +
    ggtitle("Comissions")

plots_cognition[["perservations"]] <- plots[["perservations"]] +
    xlim(-15, 15) +
    ggtitle("Perservations")

# english plot
plot_grid(plotlist = plots_cognition, ncol = 3, scale = 0.95)
ggsave(
    "./figs/cognition.png",
    width = 1920,
    height = 1080,
    dpi = 150,
    units = "px",
    bg = "white"
)

# slovenian plot
plots_cognition[["iq_memory"]] <- plots_cognition[["iq_memory"]] +
    ggtitle("Delovni spomin")

plots_cognition[["iq_speed"]] <- plots_cognition[["iq_speed"]] +
    ggtitle("Hitrost procesiranja")

plots_cognition[["motor"]] <- plots_cognition[["motor"]] +
    ggtitle("Motorična koordinacija")

plots_cognition[["visual"]] <- plots_cognition[["visual"]] +
    ggtitle("Vidna zaznava")

plots_cognition[["omissions"]] <- plots_cognition[["omissions"]] +
    ggtitle("Omisije")

plots_cognition[["comissions"]] <- plots_cognition[["comissions"]] +
    ggtitle("Komisije")

plots_cognition[["perservations"]] <- plots_cognition[["perservations"]] +
    ggtitle("Perservarcije")

plot_grid(plotlist = plots_cognition, ncol = 3, scale = 0.95)
ggsave(
    "./figs/cognition_si.png",
    width = 1920,
    height = 1080,
    dpi = 150,
    units = "px",
    bg = "white"
)

# test vs group neural ---------------------------------------------------------
plots_neural <- list()
plots_neural[["cp"]] <- plots[["cp"]] +
    xlim(-0.04, 0.04) +
    ggtitle("Characteristic path")

plots_neural[["cc"]] <- plots[["cc"]] +
    xlim(-0.03, 0.03) +
    ggtitle("Clustering coefficient")

plots_neural[["mod"]] <- plots[["mod"]] +
    xlim(-0.02, 0.02) +
    ggtitle("Modularity")

plots_neural[["sw"]] <- plots[["sw"]] +
    xlim(-0.02, 0.02) +
    ggtitle("Small worldness")

plots_neural[["tihs"]] <- plots[["tihs"]] +
    xlim(-25, 25) +
    ggtitle("IHS")

# english plot
plot_grid(plotlist = plots_neural, ncol = 5, scale = 0.95)
ggsave(
    "./figs/neural.png",
    width = 1920,
    height = 320,
    dpi = 150,
    units = "px",
    bg = "white"
)

# slovenian plot
plots_neural[["cp"]] <- plots_neural[["cp"]] +
    ggtitle("Značilna dolžina poti")

plots_neural[["cc"]] <- plots_neural[["cc"]] +
    ggtitle("Koeficient kopičenja")

plots_neural[["mod"]] <- plots_neural[["mod"]] +
    ggtitle("Modularnost")

plots_neural[["sw"]] <- plots_neural[["sw"]] +
    ggtitle("Indeks majhnih svetov")

plots_neural[["tihs"]] <- plots_neural[["tihs"]] +
    ggtitle("IHM")

plot_grid(plotlist = plots_neural, ncol = 5, scale = 0.95)
ggsave(
    "./figs/neural_si.png",
    width = 1920,
    height = 320,
    dpi = 150,
    units = "px",
    bg = "white"
)
