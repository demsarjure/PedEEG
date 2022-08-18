# Global metrics comparisons between the test and the control group.

library(cowplot)

# load data and models ---------------------------------------------------------
source("./utils/normal.R")
source("data.R")

# fit --------------------------------------------------------------------------
cp_fit <- fit_normal(df_diff$cp)
cc_fit <- fit_normal(df_diff$cc)
sw_fit <- fit_normal(df_diff$sw)
mod_fit <- fit_normal(df_diff$mod)
dv_fit <- fit_normal(df_diff$dv)
nihs_fit <- fit_normal(df_diff$nihs)
tihs_fit <- fit_normal(df_diff$tihs)

# compare cp -------------------------------------------------------------------
compare_normal(cp_fit, label1 = "control", label2 = "test")
# P(control > test) = 7.82 +/- 0.5%
# P(control < test) = 92.17 +/- 0.5%

# compare cc -------------------------------------------------------------------
compare_normal(cc_fit, label1 = "control", label2 = "test")
# P(control > test) = 10.38 +/- 0.7%
# P(control < test) = 89.62 +/- 0.7%

# compare sw -------------------------------------------------------------------
compare_normal(sw_fit, label1 = "control", label2 = "test")
# P(control > test) = 7.4 +/- 0.5%
# P(control < test) = 92.6 +/- 0.5%

# compare mod ------------------------------------------------------------------
compare_normal(mod_fit, label1 = "control", label2 = "test")
# P(control > test) = 82.03 +/- 0.8%
# P(control < test) = 17.97 +/- 0.8%

# compare dv -------------------------------------------------------------------
compare_normal(dv_fit, label1 = "control", label2 = "test")
# P(control > test) = 5.03 +/- 0.4%
# P(control < test) = 94.97 +/- 0.4%

# compare tihs -----------------------------------------------------------------
compare_normal(tihs_fit, label1 = "control", label2 = "test")
# P(control > test) = 9.4 +/- 0.7%
# P(control < test) = 90.6 +/- 0.7%

# plot -------------------------------------------------------------------------
p1 <- plot_comparison_normal(cp_fit, ci = 0.9) +
        ggtitle("Characteristic path") +
        xlim(-0.06, 0.06) +
        xlab("Mean difference")

p2 <- plot_comparison_normal(cc_fit, ci = 0.9) +
        ggtitle("Clustering coefficient") +
        xlim(-0.06, 0.06) +
        xlab("Mean difference")

p3 <- plot_comparison_normal(sw_fit, ci = 0.9) +
        ggtitle("Small-worldness") +
        xlim(-0.04, 0.04) +
        xlab("Mean difference")

p4 <- plot_comparison_normal(mod_fit, ci = 0.1) +
        ggtitle("Modularity") +
        xlim(-0.04, 0.04) +
        xlab("Mean difference")

p5 <- plot_comparison_normal(dv_fit, ci = 0.9) +
        ggtitle("Degree variance") +
        xlim(-5, 5) +
        xlab("Mean difference")

p6 <- plot_comparison_normal(dv_fit, ci = 0.9) +
        ggtitle("Total interhemisperhic strength") +
        xlim(-5, 5) +
        xlab("Mean difference")

plot_grid(p1, p2, p3, p4, p5, p6, ncol = 2, scale = 0.95)
