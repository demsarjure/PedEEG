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
# P(control > test) = 4.55 +/- 0.4%
# P(control < test) = 95.45 +/- 0.4%

# I
compare_normal(cp_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 8.77 +/- 0.6%
# P(control < test) = 91.22 +/- 0.6%

# compare cc -------------------------------------------------------------------
# C
compare_normal(cc_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 7.18 +/- 0.6%
# P(control < test) = 92.83 +/- 0.6%

# I
compare_normal(cc_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 11.82 +/- 0.7%
# P(control < test) = 88.17 +/- 0.7%

# compare sw -------------------------------------------------------------------
# C
compare_normal(sw_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 4.1 +/- 0.4%
# P(control < test) = 95.9 +/- 0.4%

# I
compare_normal(sw_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 8.18 +/- 0.6%
# P(control < test) = 91.83 +/- 0.6%

# compare mod ------------------------------------------------------------------
# C
compare_normal(mod_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 64.6 +/- 0.9%
# P(control < test) = 35.4 +/- 0.9%

# I
compare_normal(mod_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 81.92 +/- 0.8%
# P(control < test) = 18.08 +/- 0.8%

# compare dv -------------------------------------------------------------------
# C
compare_normal(dv_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 2.62 +/- 0.4%
# P(control < test) = 97.38 +/- 0.4%

# I
compare_normal(dv_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 5.8 +/- 0.6%
# P(control < test) = 94.2 +/- 0.6%

# plot -------------------------------------------------------------------------
# note we are using 0.3 and 0.8 CI because for visaulizing 0.5 and 0.9 CI
# as our tests are one tailed
p1 <- plot_comparison_normal(cp_h_fit, "C",
                             cp_i_fit, "I",
                             ci = c(0.3, 0.8)) +
        ggtitle("Characteristic path") +
        xlim(-0.04, 0.04) +
        xlab("Mean difference")

p2 <- plot_comparison_normal(cc_h_fit, "C",
                             cc_i_fit, "I",
                             ci = c(0.3, 0.8)) +
        ggtitle("Clustering coefficient") +
        xlim(-0.03, 0.03) +
        xlab("Mean difference")

p3 <- plot_comparison_normal(sw_h_fit, "C",
                             sw_i_fit, "I",
                             ci = c(0.3, 0.8)) +
        ggtitle("Small-worldness") +
        xlim(-0.03, 0.03) +
        xlab("Mean difference")

p4 <- plot_comparison_normal(mod_h_fit, "C",
                             mod_i_fit, "I",
                             ci = c(0.3, 0.8)) +
        ggtitle("Modularity") +
        xlim(-0.02, 0.02) +
        xlab("Mean difference")

p5 <- plot_comparison_normal(dv_h_fit, "C",
                             dv_i_fit, "I",
                             ci = c(0.3, 0.8)) +
        ggtitle("Degree variance") +
        xlim(-0.5, 0.5) +
        xlab("Mean difference")

plot_grid(p1, p2, p3, p4, p5, ncol = 5)

ggsave("./figs/inter_between.tiff",
       width = 1920,
       height = 540,
       dpi = 150,
       units = "px",
       bg = "white")



