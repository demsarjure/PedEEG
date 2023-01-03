# Inter-hemispheric comparisons between injured subjects.

# load data and models ---------------------------------------------------------
source("./utils/normal.R")
source("data.R")

# fit --------------------------------------------------------------------------
cp_fit <- fit_normal(df_diff_injured$cp)
cc_fit <- fit_normal(df_diff_injured$cc)
sw_fit <- fit_normal(df_diff_injured$sw)
mod_fit <- fit_normal(df_diff_injured$mod)
dv_fit <- fit_normal(df_diff_injured$dv)

# compare cp -------------------------------------------------------------------
compare_normal(cp_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 28.52 +/- 1%
# P(healthy < injured) = 71.47 +/- 1%

# compare cc -------------------------------------------------------------------
compare_normal(cc_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 28.88 +/- 0.8%
# P(healthy < injured) = 71.12 +/- 0.8%

# compare sw -------------------------------------------------------------------
compare_normal(sw_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 26.88 +/- 1%
# P(healthy < injured) = 73.12 +/- 1%

# compare mod ------------------------------------------------------------------
compare_normal(mod_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 61.6 +/- 0.9%
# P(healthy < injured) = 38.4 +/- 0.9%

# compare dv -------------------------------------------------------------------
compare_normal(dv_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 79.57 +/- 0.8%
# P(healthy < injured) = 20.42 +/- 0.8%

# plot -------------------------------------------------------------------------
p1 <- plot_comparison_normal(cp_fit, ci = 0.9) +
        ggtitle("Characteristic path") +
        xlim(-0.03, 0.03) +
        xlab("Mean difference")

p2 <- plot_comparison_normal(cc_fit, ci = 0.9) +
        ggtitle("Clustering coefficient") +
        xlim(-0.03, 0.03) +
        xlab("Mean difference")

p3 <- plot_comparison_normal(sw_fit, ci = 0.1) +
        ggtitle("Small-worldness") +
        xlim(-0.03, 0.03) +
        xlab("Mean difference")

p4 <- plot_comparison_normal(mod_fit, ci = 0.1) +
        ggtitle("Modularity") +
        xlim(-0.03, 0.03) +
        xlab("Mean difference")

p5 <- plot_comparison_normal(dv_fit, ci = 0.1) +
        ggtitle("Degree variance") +
        xlim(-1, 1) +
        xlab("Mean difference")

plot_grid(p1, p2, p3, p4, p5, ncol = 5, scale = 0.95)

ggsave("./figs/inter_within.pdf",
        width = 3840,
        height = 1080,
        dpi = 350,
        units = "px",
        bg = "white")
