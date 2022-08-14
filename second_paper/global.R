# Global metrics comparisons between the test and the control group.

# load data and models ---------------------------------------------------------
source("./utils/normal.R")
source("data.R")

# fit --------------------------------------------------------------------------
cp_fit <- fit_normal(df_diff$cp)
cc_fit <- fit_normal(df_diff$cc)
sw_fit <- fit_normal(df_diff$sw)
mod_fit <- fit_normal(df_diff$mod)
dv_fit <- fit_normal(df_diff$dv)
nihs_fit <- fit_normal(df_diff$nihs)
tihs_fit <- fit_normal(df_diff$tihs)

# compare cp -------------------------------------------------------------------
compare_normal(cp_fit, label1 = "control", label2 = "test")
# P(control > test) = 7.82 +/- 0.5%
# P(control < test) = 92.17 +/- 0.5%

# compare cc -------------------------------------------------------------------
compare_normal(cc_fit, label1 = "control", label2 = "test")
# P(control > test) = 10.38 +/- 0.7%
# P(control < test) = 89.62 +/- 0.7%

# compare sw -------------------------------------------------------------------
compare_normal(sw_fit, label1 = "control", label2 = "test")
# P(control > test) = 7.4 +/- 0.5%
# P(control < test) = 92.6 +/- 0.5%

# compare mod ------------------------------------------------------------------
compare_normal(mod_fit, label1 = "control", label2 = "test")
# P(control > test) = 82.03 +/- 0.8%
# P(control < test) = 17.97 +/- 0.8%

# compare dv -------------------------------------------------------------------
compare_normal(dv_fit, label1 = "control", label2 = "test")
# P(control > test) = 5.03 +/- 0.4%
# P(control < test) = 94.97 +/- 0.4%

# compare nihs -------------------------------------------------------
compare_normal(nihs_fit, label1 = "control", label2 = "test")
# P(control > test) = 76.98 +/- 0.7%
# P(control < test) = 23.03 +/- 0.7%

# compare tihs ------------------------------------------------------------
compare_normal(tihs_fit, label1 = "control", label2 = "test")
# P(control > test) = 9.4 +/- 0.7%
# P(control < test) = 90.6 +/- 0.7%
