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
# P(control > test) = 8.28 +/- 0.6%
# P(control < test) = 91.72 +/- 0.6%

# I
compare_normal(cp_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 8.6 +/- 0.7%
# P(control < test) = 91.4 +/- 0.7%

# compare cc -------------------------------------------------------------------
# C
compare_normal(cc_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 9.6 +/- 0.6%
# P(control < test) = 90.4 +/- 0.6%

# I
compare_normal(cc_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 9.47 +/- 0.6%
# P(control < test) = 90.53 +/- 0.6%

# compare sw -------------------------------------------------------------------
# C
compare_normal(sw_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 7.27 +/- 0.6% 
# P(control < test) = 92.73 +/- 0.6%

# I
compare_normal(sw_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 6.38 +/- 0.5%
# P(control < test) = 93.62 +/- 0.5%

# compare mod ------------------------------------------------------------------
# C
compare_normal(mod_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 74.55 +/- 0.9%
# P(control < test) = 25.45 +/- 0.9%

# I
compare_normal(mod_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 98.9 +/- 0.2%
# P(control < test) = 1.1 +/- 0.2%

# compare dv -------------------------------------------------------------------
# C
compare_normal(dv_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 10.25 +/- 0.7%
# P(control < test) = 89.75 +/- 0.7%

# I
compare_normal(dv_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 2.12 +/- 0.3%
# P(control < test) = 97.88 +/- 0.3%

# plot -------------------------------------------------------------------------
# note we are using 0.3 and 0.8 CI because for visualizing 0.5 and 0.9 CI
# as our tests are one tailed
p1 <- plot_comparison_two_normal_constant(cp_h_fit, "C",
                                          cp_i_fit, "I",
                                          ci = c(0.3, 0.8)) +
        ggtitle("Characteristic path") +
        xlim(-0.07, 0.07) +
        xlab("Mean difference")

p2 <- plot_comparison_two_normal_constant(cc_h_fit, "C",
                                          cc_i_fit, "I",
                                          ci = c(0.3, 0.8)) +
        ggtitle("Clustering coefficient") +
        xlim(-0.07, 0.07) +
        xlab("Mean difference")

p3 <- plot_comparison_two_normal_constant(sw_h_fit, "C",
                                          sw_i_fit, "I",
                                          ci = c(0.3, 0.8)) +
        ggtitle("Small-worldness") +
        xlim(-0.07, 0.07) +
        xlab("Mean difference")

p4 <- plot_comparison_two_normal_constant(mod_h_fit, "C",
                                          mod_i_fit, "I",
                                          ci = c(0.3, 0.8)) +
        ggtitle("Modularity") +
        xlim(-0.07, 0.07) +
        xlab("Mean difference")

p5 <- plot_comparison_two_normal_constant(dv_h_fit, "C",
                                          dv_i_fit, "I",
                                          ci = c(0.3, 0.8)) +
        ggtitle("Degree variance") +
        xlim(-1, 1) +
        xlab("Mean difference")
p5

plot_grid(p1, p2, p3, p4, p5, ncol = 5)

ggsave("./figs/inter_between.tiff",
       width = 1920,
       height = 540,
       dpi = 150,
       units = "px",
       bg = "white")
