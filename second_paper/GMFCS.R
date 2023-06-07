# Global metrics comparisons between the test and the control group.
library(cowplot)

# load data and models ---------------------------------------------------------
source("data.R")
source("./utils/simple_linear.R")

# linear -----------------------------------------------------------------------
# cp
cp_fit <- fit_simple_linear(df_diff$GMFCS, df_diff$cp)
compare_simple_linear(cp_fit)
# P(b > 0) = 62.68 +/- 1%
# P(b < 0) = 37.33 +/- 1%

# cc
cc_fit <- fit_simple_linear(df_diff$GMFCS, df_diff$cc)
compare_simple_linear(cc_fit)
# P(b > 0) = 53.5 +/- 1.1%
# P(b < 0) = 46.5 +/- 1.1%

# sw
sw_fit <- fit_simple_linear(df_diff$GMFCS, df_diff$sw)
compare_simple_linear(sw_fit)
# P(b > 0) = 72.17 +/- 0.9%
# P(b < 0) = 27.82 +/- 0.9%

# mod
mod_fit <- fit_simple_linear(df_diff$GMFCS, df_diff$mod)
compare_simple_linear(mod_fit)
# P(b > 0) = 94.53 +/- 0.5%
# P(b < 0) = 5.47 +/- 0.5%

# dv
dv_fit <- fit_simple_linear(df_diff$GMFCS, df_diff$dv)
compare_simple_linear(dv_fit)
# P(b > 0) = 76.72 +/- 0.8%
# P(b < 0) = 23.28 +/- 0.8%

# tihs
tihs_fit <- fit_simple_linear(df_diff$GMFCS, df_diff$tihs)
compare_simple_linear(tihs_fit)
# P(b > 0) = 58.7 +/- 0.8%
# P(b < 0) = 41.3 +/- 0.8%

# plot -------------------------------------------------------------------------
min_x <- 0
max_x <- 2

p1 <- plot_simple_linear(cp_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Characteristic path") +
        ylab("Metric value") +
        xlab("GMFCS") +
        ylim(-0.05, 0.05)

p2 <- plot_simple_linear(cc_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Clustering coefficient") +
        ylab("Metric value") +
        xlab("GMFCS") +
        ylim(-0.05, 0.05)

p3 <- plot_simple_linear(sw_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Small-worldness") +
        ylab("Metric value") +
        xlab("GMFCS") +
        ylim(-0.05, 0.05)

p4 <- plot_simple_linear(mod_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Modularity") +
        ylab("Metric value") +
        xlab("GMFCS") +
        ylim(-0.05, 0.05)

p5 <- plot_simple_linear(dv_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Degree variance") +
        ylab("Metric value") +
        xlab("GMFCS") +
        ylim(-5, 5)

p6 <- plot_simple_linear(dv_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Total interhemisperhic strength") +
        ylab("Metric value") +
        xlab("GMFCS") +
        ylim(-5, 5)

plot_grid(p1, p2, p3, p4, p5, p6, ncol = 2, scale = 0.95)

ggsave("./figs/GMFCS.pdf",
        width = 3840,
        height = 2160,
        dpi = 450,
        units = "px",
        bg = "white"
)
