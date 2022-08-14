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
# P(healthy > injured) = 63.2 +/- 0.9%
# P(healthy < injured) = 36.8 +/- 0.9%

# compare cc -------------------------------------------------------------------
compare_normal(cc_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 57.5 +/- 0.8%
# P(healthy < injured) = 42.5 +/- 0.8%

# compare sw -------------------------------------------------------------------
compare_normal(sw_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 66.2 +/- 0.8%
# P(healthy < injured) = 33.8 +/- 0.8%

# compare mod ------------------------------------------------------------------
compare_normal(mod_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 57.88 +/- 0.8%
# P(healthy < injured) = 42.12 +/- 0.8%

# compare dv -------------------------------------------------------------------
compare_normal(dv_fit, label1 = "healthy", label2 = "injured")
# P(healthy > injured) = 90.45 +/- 0.8%
# P(healthy < injured) = 9.55 +/- 0.8%
