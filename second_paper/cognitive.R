# Global metrics comparisons between the test and the control group.
library(cowplot)

# load data and models ---------------------------------------------------------
source("data.R")
source("./utils/simple_linear.R")

# linear -----------------------------------------------------------------------
# cp
cp_fit <- fit_simple_linear(df_diff$cognitive, df_diff$cp)
compare_simple_linear(cp_fit)
# P(b > 0) = 55.73 +/- 1.1%
# P(b < 0) = 44.27 +/- 1.1%

# cc
cc_fit <- fit_simple_linear(df_diff$cognitive, df_diff$cc)
compare_simple_linear(cc_fit)
# P(b > 0) = 57.93 +/- 1.1%
# P(b < 0) = 42.08 +/- 1.1%

# sw
sw_fit <- fit_simple_linear(df_diff$cognitive, df_diff$sw)
compare_simple_linear(sw_fit)
# P(b > 0) = 51.9 +/- 1.1%
# P(b < 0) = 48.1 +/- 1.1%

# mod
mod_fit <- fit_simple_linear(df_diff$cognitive, df_diff$mod)
compare_simple_linear(mod_fit)
# P(b > 0) = 35.2 +/- 1%
# P(b < 0) = 64.8 +/- 1%

# dv
dv_fit <- fit_simple_linear(df_diff$cognitive, df_diff$dv)
compare_simple_linear(dv_fit)
# P(b > 0) = 30.3 +/- 1.1%
# P(b < 0) = 69.7 +/- 1.1%

# tihs
tihs_fit <- fit_simple_linear(df_diff$cognitive, df_diff$tihs)
compare_simple_linear(tihs_fit)
# P(b > 0) = 52.05 +/- 0.9%
# P(b < 0) = 47.95 +/- 0.9%

# plot -------------------------------------------------------------------------
min_x <- 0
max_x <- 2

p1 <- plot_simple_linear(cp_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Characteristic path") +
        ylab("Metric value") +
        xlab("Cognitive score") +
        ylim(-0.1, 0.1)

p2 <- plot_simple_linear(cc_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Clustering coefficient") +
        ylab("Metric value") +
        xlab("Cognitive score") +
        ylim(-0.05, 0.05)

p3 <- plot_simple_linear(sw_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Small-worldness") +
        ylab("Metric value") +
        xlab("Cognitive score") +
        ylim(-0.05, 0.05)

p4 <- plot_simple_linear(mod_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Modularity") +
        ylab("Metric value") +
        xlab("Cognitive score") +
        ylim(-0.05, 0.05)

p5 <- plot_simple_linear(dv_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Degree variance") +
        ylab("Metric value") +
        xlab("Cognitive score") +
        ylim(-5, 5)

p6 <- plot_simple_linear(dv_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Total interhemisperhic strength") +
        ylab("Metric value") +
        xlab("Cognitive score") +
        ylim(-5, 5)

plot_grid(p1, p2, p3, p4, p5, p6, ncol = 2, scale = 0.95)

ggsave("./figs/cognitive.pdf",
        width = 3840,
        height = 2160,
        dpi = 450,
        units = "px",
        bg = "white"
)
