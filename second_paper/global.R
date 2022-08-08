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
# P(control > test) = 19.55 +/- 0.9%
# P(control < test) = 80.45 +/- 0.9%

# compare ge -------------------------------------------------------------------
compare_normal(ge_fit, label1 = "control", label2 = "test")
# P(control > test) = 32.6 +/- 0.9%
# P(control < test) = 67.4 +/- 0.9%

# compare cc -------------------------------------------------------------------
compare_normal(cc_fit, label1 = "control", label2 = "test")
# P(control > test) = 16.78 +/- 0.8%
# P(control < test) = 83.23 +/- 0.8%

# compare sw -------------------------------------------------------------------
compare_normal(sw_fit, label1 = "control", label2 = "test")
# P(control > test) = 23.12 +/- 0.9%
# P(control < test) = 76.88 +/- 0.9%

# compare bc -------------------------------------------------------------------
compare_normal(bc_fit, label1 = "control", label2 = "test")
# P(control > test) = 16.2 +/- 0.9%
# P(control < test) = 83.8 +/- 0.9%

# compare mod ------------------------------------------------------------------
compare_normal(mod_fit, label1 = "control", label2 = "test")
# P(control > test) = 92.47 +/- 0.5%
# P(control < test) = 7.52 +/- 0.5%

# compare hcr ------------------------------------------------------------------
compare_normal(hcr_fit, label1 = "control", label2 = "test")
# P(control > test) = 13.25 +/- 0.7%
# P(control < test) = 86.75 +/- 0.7%

# compare dv -------------------------------------------------------------------
compare_normal(dv_fit, label1 = "control", label2 = "test")
# P(control > test) = 41.1 +/- 0.8%
# P(control < test) = 58.9 +/- 0.8%

# compare ap -------------------------------------------------------------------
compare_normal(ap_fit, label1 = "control", label2 = "test")
# P(control > test) = 90.75 +/- 0.7%
# P(control < test) = 9.25 +/- 0.7%

# compare normalized_ihs -------------------------------------------------------
compare_normal(normalized_ihs_fit, label1 = "control", label2 = "test")
# P(control > test) = 71.83 +/- 0.8%
# P(control < test) = 28.18 +/- 0.8%

# compare total_ihs ------------------------------------------------------------
compare_normal(total_ihs_fit, label1 = "control", label2 = "test")
# P(control > test) = 21.62 +/- 0.9%
# P(control < test) = 78.38 +/- 0.9%
