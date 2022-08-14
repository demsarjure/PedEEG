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
# healthy
compare_normal(cp_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 4.55 +/- 0.4%
# P(control < test) = 95.45 +/- 0.4%

# injured
compare_normal(cp_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 8.77 +/- 0.6%
# P(control < test) = 91.22 +/- 0.6%

# compare cc -------------------------------------------------------------------
# healthy
compare_normal(cc_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 7.18 +/- 0.6%
# P(control < test) = 92.83 +/- 0.6%

# injured
compare_normal(cc_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 11.82 +/- 0.7%
# P(control < test) = 88.17 +/- 0.7%

# compare sw -------------------------------------------------------------------
# healthy
compare_normal(sw_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 4.1 +/- 0.4%
# P(control < test) = 95.9 +/- 0.4%

# injured
compare_normal(sw_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 8.18 +/- 0.6%
# P(control < test) = 91.83 +/- 0.6%

# compare mod ------------------------------------------------------------------
# healthy
compare_normal(mod_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 64.6 +/- 0.9%
# P(control < test) = 35.4 +/- 0.9%

# injured
compare_normal(mod_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 81.92 +/- 0.8%
# P(control < test) = 18.08 +/- 0.8%

# compare dv -------------------------------------------------------------------
# healthy
compare_normal(dv_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 2.62 +/- 0.4%
# P(control < test) = 97.38 +/- 0.4%

# injured
compare_normal(dv_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 5.8 +/- 0.6%
# P(control < test) = 94.2 +/- 0.6%
