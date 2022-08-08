# Inter-hemispheric comparisons between the test and the control group.

# load data and models ---------------------------------------------------------
source("./utils/normal.R")
source("data.R")

# fit --------------------------------------------------------------------------
cp_h_fit <- fit_normal(df_diff_injured$cp)
ge_fit <- fit_normal(df_diff_injured$ge)
cc_fit <- fit_normal(df_diff_injured$cc)
sw_fit <- fit_normal(df_diff_injured$sw)
bc_fit <- fit_normal(df_diff_injured$bc)
mod_fit <- fit_normal(df_diff_injured$mod)
hcr_fit <- fit_normal(df_diff_injured$hcr)
dv_fit <- fit_normal(df_diff_injured$dv)

# compare cp -------------------------------------------------------------------
compare_normal(cp_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 19.02 +/- 0.8%
# P(healthy < injured) = 80.97 +/- 0.8%

# compare ge -------------------------------------------------------------------
compare_normal(ge_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 66.85 +/- 1%
# P(healthy < injured) = 33.15 +/- 1%

# compare cc -------------------------------------------------------------------
compare_normal(cc_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 59.42 +/- 0.8%
# P(healthy < injured) = 40.58 +/- 0.8%

# compare sw -------------------------------------------------------------------
compare_normal(sw_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 66.03 +/- 0.8%
# P(healthy < injured) = 33.98 +/- 0.8%

# compare bc -------------------------------------------------------------------
compare_normal(bc_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 56.35 +/- 0.9%
# P(healthy < injured) = 43.65 +/- 0.9%

# compare mod ------------------------------------------------------------------
compare_normal(mod_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 56.95 +/- 0.8%
# P(healthy < injured) = 43.05 +/- 0.8%

# compare hcr ------------------------------------------------------------------
compare_normal(hcr_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 45.9 +/- 0.8%
# P(healthy < injured) = 54.1 +/- 0.8%

# compare dv -------------------------------------------------------------------
compare_normal(dv_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 90.85 +/- 0.8%
# P(healthy < injured) = 9.15 +/- 0.8%
