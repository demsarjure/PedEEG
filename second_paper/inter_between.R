# Inter-hemispheric comparisons between the test and the control group.

# load data and models ---------------------------------------------------------
source("./utils/normal.R")
source("data.R")

# fit --------------------------------------------------------------------------
cp_h_fit <- fit_normal(df_diff_inter$cp_h)
cp_i_fit <- fit_normal(df_diff_inter$cp_i)
cc_h_fit <- fit_normal(df_diff_inter$cc_h)
cc_i_fit <- fit_normal(df_diff_inter$cc_i)
sw_h_fit <- fit_normal(df_diff_inter$sw_h)
sw_i_fit <- fit_normal(df_diff_inter$sw_i)
mod_h_fit <- fit_normal(df_diff_inter$mod_h)
mod_i_fit <- fit_normal(df_diff_inter$mod_i)
dv_h_fit <- fit_normal(df_diff_inter$dv_h)
dv_i_fit <- fit_normal(df_diff_inter$dv_i)

# compare cp -------------------------------------------------------------------
# C
compare_normal(cp_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 2.28 +/- 0.3%
# P(control < test) = 97.72 +/- 0.3%

# I
compare_normal(cp_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 2.02 +/- 0.3%
# P(control < test) = 97.97 +/- 0.3%

# compare cc -------------------------------------------------------------------
# C
compare_normal(cc_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 2.38 +/- 0.3%
# P(control < test) = 97.62 +/- 0.3%

# I
compare_normal(cc_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 2.05 +/- 0.3%
# P(control < test) = 97.95 +/- 0.3%

# compare sw -------------------------------------------------------------------
# C
compare_normal(sw_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 2.4 +/- 0.3%
# P(control < test) = 97.6 +/- 0.3%

# I
compare_normal(sw_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 1.7 +/- 0.3%
# P(control < test) = 98.3 +/- 0.3%

# compare mod ------------------------------------------------------------------
# C
compare_normal(mod_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 86.17 +/- 0.6%
# P(control < test) = 13.83 +/- 0.6%

# I
compare_normal(mod_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 99.65 +/- 0.1%
# P(control < test) = 0.35 +/- 0.1%

# compare dv -------------------------------------------------------------------
# C
compare_normal(dv_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 2.85 +/- 0.3%
# P(control < test) = 97.15 +/- 0.3%

# I
compare_normal(dv_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 0.2 +/- 0.1%
# P(control < test) = 99.8 +/- 0.1%

# plot -------------------------------------------------------------------------
# note we are using 0.3 and 0.8 CI because for visualizing 0.5 and 0.9 CI
# as our tests are one tailed
p1 <- plot_comparison_two_normal_constant(cp_h_fit, "C",
                                          cp_i_fit, "I",
                                          ci = c(0.3, 0.8)) +
        ggtitle("Characteristic path") +
        xlim(-0.1, 0.1) +
        xlab("Mean difference")

p2 <- plot_comparison_two_normal_constant(cc_h_fit, "C",
                                          cc_i_fit, "I",
                                          ci = c(0.3, 0.8)) +
        ggtitle("Clustering coefficient") +
        xlim(-0.1, 0.1) +
        xlab("Mean difference")

p3 <- plot_comparison_two_normal_constant(sw_h_fit, "C",
                                          sw_i_fit, "I",
                                          ci = c(0.3, 0.8)) +
        ggtitle("Small-worldness") +
        xlim(-0.1, 0.1) +
        xlab("Mean difference")

p4 <- plot_comparison_two_normal_constant(mod_h_fit, "C",
                                          mod_i_fit, "I",
                                          ci = c(0.3, 0.8)) +
        ggtitle("Modularity") +
        xlim(-0.1, 0.1) +
        xlab("Mean difference")

p5 <- plot_comparison_two_normal_constant(dv_h_fit, "C",
                                          dv_i_fit, "I",
                                          ci = c(0.3, 0.8)) +
        ggtitle("Degree variance") +
        xlim(-1.5, 1.5) +
        xlab("Mean difference")

plot_grid(p1, p2, p3, p4, p5, ncol = 5, scale = 0.95)

ggsave("./figs/inter_between.pdf",
        width = 3840,
        height = 1080,
        dpi = 350,
        units = "px",
        bg = "white")
