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
# P(control > test) = 33.77 +/- 0.9%
# P(control < test) = 66.22 +/- 0.9%

# injured
compare_normal(cp_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 28.05 +/- 0.9%
# P(control < test) = 71.95 +/- 0.9%

# compare ge -------------------------------------------------------------------
# healthy
compare_normal(ge_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 35.12 +/- 1%
# P(control < test) = 64.88 +/- 1%

# injured
compare_normal(ge_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 37.48 +/- 0.9%
# P(control < test) = 62.52 +/- 0.9%

# compare cc -------------------------------------------------------------------
# healthy
compare_normal(cc_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 34.17 +/- 0.9%
# P(control < test) = 65.83 +/- 0.9%

# injured
compare_normal(cc_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 25.07 +/- 0.8%
# P(control < test) = 74.92 +/- 0.8%

# compare sw -------------------------------------------------------------------
# healthy
compare_normal(sw_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 34.88 +/- 0.9%
# P(control < test) = 65.12 +/- 0.9%

# injured
compare_normal(sw_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 32.38 +/- 0.9%
# P(control < test) = 67.62 +/- 0.9%

# compare bc -------------------------------------------------------------------
# healthy
compare_normal(bc_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 56.77 +/- 0.8%
# P(control < test) = 43.23 +/- 0.8%

# injured
compare_normal(bc_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 52.25 +/- 1%
# P(control < test) = 47.75 +/- 1%

# compare mod ------------------------------------------------------------------
# healthy
compare_normal(mod_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 62.4 +/- 0.9%
# P(control < test) = 37.6 +/- 0.9%

# injured
compare_normal(mod_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 45.55 +/- 0.9%
# P(control < test) = 54.45 +/- 0.9%

# compare hcr ------------------------------------------------------------------
# healthy
compare_normal(hcr_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 46.92 +/- 0.8%
# P(control < test) = 53.08 +/- 0.8%

# injured
compare_normal(hcr_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 0.92 +/- 0.2%
# P(control < test) = 99.08 +/- 0.2%

# compare dv -------------------------------------------------------------------
# healthy
compare_normal(dv_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 47.93 +/- 0.8%
# P(control < test) = 52.08 +/- 0.8%

# injured
compare_normal(dv_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 32.4 +/- 1%
# P(control < test) = 67.6 +/- 1%
