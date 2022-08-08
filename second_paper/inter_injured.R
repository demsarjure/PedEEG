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
# P(control > test) = 29.9 +/- 1%
# P(control < test) = 70.1 +/- 1%

# compare ge -------------------------------------------------------------------
compare_normal(ge_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 77.42 +/- 0.8%
# P(healthy < injured) = 22.58 +/- 0.8%

# compare cc -------------------------------------------------------------------
compare_normal(cc_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 60.52 +/- 0.8%
# P(healthy < injured) = 39.48 +/- 0.8%

# compare sw -------------------------------------------------------------------
compare_normal(sw_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 74.2 +/- 0.8%
# P(healthy < injured) = 25.8 +/- 0.8%

# compare bc -------------------------------------------------------------------
compare_normal(bc_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 65.72 +/- 0.9%
# P(healthy < injured) = 34.27 +/- 0.9%

# compare mod ------------------------------------------------------------------
compare_normal(mod_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 47.85 +/- 0.9%
# P(healthy < injured) = 52.15 +/- 0.9%

# compare hcr ------------------------------------------------------------------
compare_normal(hcr_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 16.8 +/- 0.7%
# P(healthy < injured) = 83.2 +/- 0.7%

# compare dv -------------------------------------------------------------------
compare_normal(dv_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 62.2 +/- 0.9%
# P(healthy < injured) = 37.8 +/- 0.9%
