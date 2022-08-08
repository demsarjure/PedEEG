# Inter-hemispheric comparisons between the test and the control group.

# load data and models ---------------------------------------------------------
source("./utils/normal.R")
source("data.R")

# fit --------------------------------------------------------------------------
cp_h_fit <- fit_normal(df_diff_inter$cp_h)
cp_i_fit <- fit_normal(df_diff_inter$cp_i)
ge_h_fit <- fit_normal(df_diff_inter$ge_h)
ge_i_fit <- fit_normal(df_diff_inter$ge_i)
cc_h_fit <- fit_normal(df_diff_inter$cc_h)
cc_i_fit <- fit_normal(df_diff_inter$cc_i)
sw_h_fit <- fit_normal(df_diff_inter$sw_h)
sw_i_fit <- fit_normal(df_diff_inter$sw_i)
bc_h_fit <- fit_normal(df_diff_inter$bc_h)
bc_i_fit <- fit_normal(df_diff_inter$bc_i)
mod_h_fit <- fit_normal(df_diff_inter$mod_h)
mod_i_fit <- fit_normal(df_diff_inter$mod_i)
hcr_h_fit <- fit_normal(df_diff_inter$hcr_h)
hcr_i_fit <- fit_normal(df_diff_inter$hcr_i)
dv_h_fit <- fit_normal(df_diff_inter$dv_h)
dv_i_fit <- fit_normal(df_diff_inter$dv_i)

# compare cp -------------------------------------------------------------------
# healthy
compare_normal(cp_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 25 +/- 0.9%
# P(control < test) = 75 +/- 0.9%

# injured
compare_normal(cp_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 16.98 +/- 0.8%
# P(control < test) = 83.03 +/- 0.8%

# compare ge -------------------------------------------------------------------
# healthy
compare_normal(ge_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 34.45 +/- 0.9%
# P(control < test) = 65.55 +/- 0.9%

# injured
compare_normal(ge_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 23.92 +/- 0.9%
# P(control < test) = 76.08 +/- 0.9%

# compare cc -------------------------------------------------------------------
# healthy
compare_normal(cc_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 21.3 +/- 0.8%
# P(control < test) = 78.7 +/- 0.8%

# injured
compare_normal(cc_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 12.05 +/- 0.7%
# P(control < test) = 87.95 +/- 0.7%

# compare sw -------------------------------------------------------------------
# healthy
compare_normal(sw_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 27.65 +/- 0.9%
# P(control < test) = 72.35 +/- 0.9%

# injured
compare_normal(sw_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 17.72 +/- 0.7%
# P(control < test) = 82.27 +/- 0.7%

# compare bc -------------------------------------------------------------------
# healthy
compare_normal(bc_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 24.42 +/- 0.9%
# P(control < test) = 75.58 +/- 0.9%

# injured
compare_normal(bc_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 24.6 +/- 0.9%
# P(control < test) = 75.4 +/- 0.9%

# compare mod ------------------------------------------------------------------
# healthy
compare_normal(mod_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 90.7 +/- 0.6%
# P(control < test) = 9.3 +/- 0.6%

# injured
compare_normal(mod_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 82.3 +/- 0.8%
# P(control < test) = 17.7 +/- 0.8%

# compare hcr ------------------------------------------------------------------
# healthy
compare_normal(hcr_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 24.25 +/- 0.8%
# P(control < test) = 75.75 +/- 0.8%

# injured
compare_normal(hcr_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 14.45 +/- 0.7%
# P(control < test) = 85.55 +/- 0.7%

# compare dv -------------------------------------------------------------------
# healthy
compare_normal(dv_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 33.67 +/- 0.9%
# P(control < test) = 66.33 +/- 0.9%

# injured
compare_normal(dv_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 42.73 +/- 0.8%
# P(control < test) = 57.27 +/- 0.8%
