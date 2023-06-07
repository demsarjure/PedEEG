# Global metrics comparisons between the test and the control group.
library(cowplot)

# load data and models ---------------------------------------------------------
source("data.R")
source("./utils/simple_linear.R")

# linear -----------------------------------------------------------------------
# cp
cp_fit <- fit_simple_linear(df_diff$epilepsy, df_diff$cp)
compare_simple_linear(cp_fit)
# P(b > 0) = 18.1 +/- 0.8%
# P(b < 0) = 81.9 +/- 0.8%

# cc
cc_fit <- fit_simple_linear(df_diff$epilepsy, df_diff$cc)
compare_simple_linear(cc_fit)
# P(b > 0) = 11.1 +/- 0.6%
# P(b < 0) = 88.9 +/- 0.6%

# sw
sw_fit <- fit_simple_linear(df_diff$epilepsy, df_diff$sw)
compare_simple_linear(sw_fit)
# P(b > 0) = 25.37 +/- 0.8%
# P(b < 0) = 74.62 +/- 0.8%

# mod
mod_fit <- fit_simple_linear(df_diff$epilepsy, df_diff$mod)
compare_simple_linear(mod_fit)
# P(b > 0) = 88.02 +/- 0.7%
# P(b < 0) = 11.97 +/- 0.7%

# dv
dv_fit <- fit_simple_linear(df_diff$epilepsy, df_diff$dv)
compare_simple_linear(dv_fit)
# P(b > 0) = 42.68 +/- 0.8%
# P(b < 0) = 57.33 +/- 0.8%

# tihs
tihs_fit <- fit_simple_linear(df_diff$epilepsy, df_diff$tihs)
compare_simple_linear(tihs_fit)
# P(b > 0) = 41.65 +/- 0.8%
# P(b < 0) = 58.35 +/- 0.8%

# plot -------------------------------------------------------------------------
min_x <- 0
max_x <- 1

p1 <- plot_simple_linear(cp_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Characteristic path") +
        ylab("Metric value") +
        xlab("Epilepsy") +
        ylim(-0.1, 0.1)

p2 <- plot_simple_linear(cc_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Clustering coefficient") +
        ylab("Metric value") +
        xlab("Epilepsy") +
        ylim(-0.05, 0.05) +
        ylim(-0.1, 0.1)

p3 <- plot_simple_linear(sw_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Small-worldness") +
        ylab("Metric value") +
        xlab("Epilepsy") +
        ylim(-0.05, 0.05)

p4 <- plot_simple_linear(mod_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Modularity") +
        ylab("Metric value") +
        xlab("Epilepsy") +
        ylim(-0.05, 0.05)

p5 <- plot_simple_linear(dv_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Degree variance") +
        ylab("Metric value") +
        xlab("Epilepsy") +
        ylim(-5, 5)

p6 <- plot_simple_linear(dv_fit, min_x = min_x, max_x = max_x) +
        ggtitle("Total interhemisperhic strength") +
        ylab("Metric value") +
        xlab("Epilepsy") +
        ylim(-5, 5)

plot_grid(p1, p2, p3, p4, p5, p6, ncol = 2, scale = 0.95)

ggsave("./figs/epilepsy.pdf",
        width = 3840,
        height = 2160,
        dpi = 450,
        units = "px",
        bg = "white"
)
