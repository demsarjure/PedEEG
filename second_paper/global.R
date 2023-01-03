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
tihs_fit <- fit_normal(df_diff$tihs)

# compare cp -------------------------------------------------------------------
compare_normal(cp_fit, label1 = "control", label2 = "test")
# P(control > test) = 1.55 +/- 0.3%
# P(control < test) = 98.45 +/- 0.3%

# compare cc -------------------------------------------------------------------
compare_normal(cc_fit, label1 = "control", label2 = "test")
# P(control > test) = 1.82 +/- 0.3% 
# P(control < test) = 98.17 +/- 0.3%

# compare sw -------------------------------------------------------------------
compare_normal(sw_fit, label1 = "control", label2 = "test")
# P(control > test) = 1.57 +/- 0.3%
# P(control < test) = 98.42 +/- 0.3%

# compare mod ------------------------------------------------------------------
compare_normal(mod_fit, label1 = "control", label2 = "test")
# P(control > test) = 95.1 +/- 0.5%
# P(control < test) = 4.9 +/- 0.5%

# compare dv -------------------------------------------------------------------
compare_normal(dv_fit, label1 = "control", label2 = "test")
# P(control > test) = 2.12 +/- 0.3%
# P(control < test) = 97.88 +/- 0.3%

# compare tihs -----------------------------------------------------------------
compare_normal(tihs_fit, label1 = "control", label2 = "test")
# P(control > test) = 2.45 +/- 0.3% 
# P(control < test) = 97.55 +/- 0.3%

# plot -------------------------------------------------------------------------
p1 <- plot_comparison_normal(cp_fit, ci = 0.9) +
        ggtitle("Characteristic path") +
        xlim(-0.1, 0.1) +
        xlab("Mean difference")

p2 <- plot_comparison_normal(cc_fit, ci = 0.9) +
        ggtitle("Clustering coefficient") +
        xlim(-0.1, 0.1) +
        xlab("Mean difference")

p3 <- plot_comparison_normal(sw_fit, ci = 0.9) +
        ggtitle("Small-worldness") +
        xlim(-0.1, 0.1) +
        xlab("Mean difference")

p4 <- plot_comparison_normal(mod_fit, ci = 0.1) +
        ggtitle("Modularity") +
        xlim(-0.1, 0.1) +
        xlab("Mean difference")

p5 <- plot_comparison_normal(dv_fit, ci = 0.9) +
        ggtitle("Degree variance") +
        xlim(-7, 7) +
        xlab("Mean difference")

p6 <- plot_comparison_normal(dv_fit, ci = 0.9) +
        ggtitle("Total interhemisperhic strength") +
        xlim(-7, 7) +
        xlab("Mean difference")

plot_grid(p1, p2, p3, p4, p5, p6, ncol = 2, scale = 0.95)

ggsave("./figs/global.pdf",
        width = 3840,
        height = 2160,
        dpi = 450,
        units = "px",
        bg = "white")
