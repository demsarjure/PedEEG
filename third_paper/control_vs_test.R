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

    plot <- plot_comparison_normal(fit = fit_diff)
    plot <- plot +
        xlab("") +
        ggtitle(var) +
        theme(plot.title = element_text(hjust = 0.5))

    plots[[var]] <- plot
}

# first plot, left panel -------------------------------------------------------
p1 <- plots[["mod"]] +
    xlim(-0.02, 0.02) +
    ggtitle("Modularity")

p2 <- plots[["cc"]] +
    xlim(-0.03, 0.03) +
    ggtitle("Clustering coefficient")

plot_grid(p1, p2, ncol = 1, scale = 0.95)

ggsave(
    "./figs/1_left.pdf",
    width = 1080,
    height = 1080,
    dpi = 300,
    units = "px",
    bg = "white"
)

# first plot, middle panel -----------------------------------------------------
p1 <- plots[["iq"]] +
    xlim(-30, 30) +
    ggtitle("IQ")

p2 <- plots[["iq_speed"]] +
    xlim(-30, 30) +
    ggtitle("Processing speed")

plot_grid(p1, p2, ncol = 1, scale = 0.95)

ggsave(
    "./figs/1_mid.pdf",
    width = 1080,
    height = 1080,
    dpi = 300,
    units = "px",
    bg = "white"
)

# second plot, left panel ------------------------------------------------------
p1 <- plots[["cp"]] +
    xlim(-0.04, 0.04) +
    ggtitle("Characteristic path")

p2 <- plots[["tihs"]] +
    xlim(-25, 25) +
    ggtitle("Interhemispheric strength")

p3 <- plots[["cc"]] +
    xlim(-0.03, 0.03) +
    ggtitle("Clustering coefficient")

p4 <- plots[["sw"]] +
    xlim(-0.02, 0.02) +
    ggtitle("Small worldness")

plot_grid(p1, p2, p3, p4, ncol = 1, scale = 0.95)

ggsave(
    "./figs/2_left.pdf",
    width = 1080,
    height = 1620,
    dpi = 300,
    units = "px",
    bg = "white"
)

# second plot, middle panel ----------------------------------------------------
p1 <- plots[["perservations"]] +
    xlim(-15, 15) +
    ggtitle("Perservations")

p1

ggsave(
    "./figs/2_mid.pdf",
    width = 1080,
    height = 1080,
    dpi = 300,
    units = "px",
    bg = "white"
)

# all plots test vs group ------------------------------------------------------
plots[["cp"]] <- plots[["cp"]] +
    xlim(-0.04, 0.04) +
    ggtitle("Characteristic path")

plots[["cc"]] <- plots[["cc"]] +
    xlim(-0.03, 0.03) +
    ggtitle("Clustering coefficient")

plots[["mod"]] <- plots[["mod"]] +
    xlim(-0.02, 0.02) +
    ggtitle("Modularity")

plots[["sw"]] <- plots[["sw"]] +
    xlim(-0.02, 0.02) +
    ggtitle("Small worldness")

plots[["tihs"]] <- plots[["tihs"]] +
    xlim(-25, 25) +
    ggtitle("IHS")

plots[["iq"]] <- plots[["iq"]] +
    xlim(-30, 30) +
    ggtitle("IQ")

plots[["iq_memory"]] <- plots[["iq_memory"]] +
    xlim(-30, 30) +
    ggtitle("Working memory")

plots[["iq_speed"]] <- plots[["iq_speed"]] +
    xlim(-30, 30) +
    ggtitle("Processing speed")

plots[["visual_motor"]] <- plots[["visual_motor"]] +
    xlim(-15, 15) +
    ggtitle("VMI")

plots[["motor"]] <- plots[["motor"]] +
    xlim(-15, 15) +
    ggtitle("Motor coordination")

plots[["visual"]] <- plots[["visual"]] +
    xlim(-15, 15) +
    ggtitle("Visual perception")

plots[["omissions"]] <- plots[["omissions"]] +
    xlim(-10, 10) +
    ggtitle("Omissions")

plots[["comissions"]] <- plots[["comissions"]] +
    xlim(-15, 15) +
    ggtitle("Comissions")

plots[["perservations"]] <- plots[["perservations"]] +
    xlim(-15, 15) +
    ggtitle("Perservations")

plot_grid(plotlist = plots, ncol = 5, scale = 0.95)
ggsave(
    "./figs/control_vs_test.png",
    width = 1920,
    height = 1080,
    dpi = 200,
    units = "px",
    bg = "white"
)
