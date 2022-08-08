# Global metrics comparisons between the test and the control group.

# load data and models ---------------------------------------------------------
source("./utils/normal.R")
source("data.R")

# fit --------------------------------------------------------------------------
cp_fit <- fit_normal(df_diff$cp)
ge_fit <- fit_normal(df_diff$ge)
cc_fit <- fit_normal(df_diff$cc)
sw_fit <- fit_normal(df_diff$sw)
bc_fit <- fit_normal(df_diff$bc)
mod_fit <- fit_normal(df_diff$mod)
hcr_fit <- fit_normal(df_diff$hcr)
dv_fit <- fit_normal(df_diff$dv)

df_non_na <- df_diff %>% drop_na()
ap_fit <- fit_normal(df_non_na$ap)

normalized_ihs_fit <- fit_normal(df_diff$normalized_ihs)
total_ihs_fit <- fit_normal(df_diff$total_ihs)

# compare cp -------------------------------------------------------------------
compare_normal(cp_fit, label1 = "control", label2 = "test")
# P(control > test) = 29.9 +/- 1%
# P(control < test) = 70.1 +/- 1%

# compare ge -------------------------------------------------------------------
compare_normal(ge_fit, label1 = "control", label2 = "test")
# P(control > test) = 41.52 +/- 0.9%
# P(control < test) = 58.48 +/- 0.9%

# compare cc -------------------------------------------------------------------
compare_normal(cc_fit, label1 = "control", label2 = "test")
# P(control > test) = 27.15 +/- 0.8%
# P(control < test) = 72.85 +/- 0.8%

# compare sw -------------------------------------------------------------------
compare_normal(sw_fit, label1 = "control", label2 = "test")
# P(control > test) = 36.98 +/- 0.8%
# P(control < test) = 63.02 +/- 0.8%

# compare bc -------------------------------------------------------------------
compare_normal(bc_fit, label1 = "control", label2 = "test")
# P(control > test) = 31.05 +/- 0.8%
# P(control < test) = 68.95 +/- 0.8%

# compare mod ------------------------------------------------------------------
compare_normal(mod_fit, label1 = "control", label2 = "test")
# P(control > test) = 57.45 +/- 0.9%
# P(control < test) = 42.55 +/- 0.9%

# compare hcr ------------------------------------------------------------------
compare_normal(hcr_fit, label1 = "control", label2 = "test")
# P(control > test) = 4.72 +/- 0.4%
# P(control < test) = 95.28 +/- 0.4%

# compare dv -------------------------------------------------------------------
compare_normal(dv_fit, label1 = "control", label2 = "test")
# P(control > test) = 43.12 +/- 0.9%
# P(control < test) = 56.88 +/- 0.9%

# compare ap -------------------------------------------------------------------
compare_normal(ap_fit, label1 = "control", label2 = "test")
# P(control > test) = 91.83 +/- 0.8%
# P(control < test) = 8.18 +/- 0.8%

# compare normalized_ihs -------------------------------------------------------
compare_normal(normalized_ihs_fit, label1 = "control", label2 = "test")
# P(control > test) = 60.82 +/- 0.8%
# P(control < test) = 39.17 +/- 0.8%

# compare total_ihs ------------------------------------------------------------
compare_normal(total_ihs_fit, label1 = "control", label2 = "test")
# P(control > test) = 29.42 +/- 0.9%
# P(control < test) = 70.58 +/- 0.9%
