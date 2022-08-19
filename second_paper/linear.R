# Global metrics comparisons between the test and the control group.

# load data and models ---------------------------------------------------------
source("data.R")
source("./utils/simple_linear.R")

# linear -----------------------------------------------------------------------
# cp
cp_fit <- fit_simple_linear(df_diff$volume, df_diff$cp)
compare_simple_linear(cp_fit)
# P(β > 0) = 78.05 +/- 0.8%
# P(β < 0) = 21.95 +/- 0.8%

# cc
cc_fit <- fit_simple_linear(df_diff$volume, df_diff$cc)
compare_simple_linear(cc_fit)
# P(β > 0) = 68.5 +/- 0.8%
# P(β < 0) = 31.5 +/- 0.8%

# sw
sw_fit <- fit_simple_linear(df_diff$volume, df_diff$sw)
compare_simple_linear(sw_fit)
# P(β > 0) = 81.62 +/- 0.8%
# P(β < 0) = 18.38 +/- 0.8%

# mod
mod_fit <- fit_simple_linear(df_diff$volume, df_diff$mod)
compare_simple_linear(mod_fit)
# P(β > 0) = 81.27 +/- 0.8%
# P(β < 0) = 18.73 +/- 0.8%

# dv
dv_fit <- fit_simple_linear(df_diff$volume, df_diff$dv)
compare_simple_linear(dv_fit)
# P(β > 0) = 85.67 +/- 0.7%
# P(β < 0) = 14.32 +/- 0.7%

# tihs
tihs_fit <- fit_simple_linear(df_diff$volume, df_diff$tihs)
compare_simple_linear(tihs_fit)
# P(β > 0) = 71.95 +/- 1%
# P(β < 0) = 28.05 +/- 1%

# plot -------------------------------------------------------------------------
min_x <- 0
max_x <- 140

p1 <- plot_simple_linear(cp_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Characteristic path") +
        ylab("Metric value") +
        xlab("Volume") +
        ylim(-0.15, 0.15)

p2 <- plot_simple_linear(cc_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Clustering coefficient") +
        ylab("Metric value") +
        xlab("Volume") +
        ylim(-0.15, 0.15)

p3 <- plot_simple_linear(sw_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Small-worldness") +
        ylab("Metric value") +
        xlab("Volume") +
        ylim(-0.15, 0.15)

p4 <- plot_simple_linear(mod_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Modularity") +
        ylab("Metric value") +
        xlab("Volume") +
        ylim(-0.15, 0.15)

p5 <- plot_simple_linear(dv_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Degree variance") +
        ylab("Metric value") +
        xlab("Volume") +
        ylim(-15, 15)

p6 <- plot_simple_linear(dv_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Total interhemisperhic strength") +
        ylab("Metric value") +
        xlab("Volume") +
        ylim(-15, 15)

plot_grid(p1, p2, p3, p4, p5, p6, ncol = 2, scale = 0.95)

ggsave("./figs/volume.tiff",
       width = 1920,
       height = 960,
       dpi = 150,
       units = "px",
       bg = "white")
