# Global metrics comparisons between the test and the control group.
library(cowplot)

# load data and models ---------------------------------------------------------
source("data.R")
source("./utils/logistic.R")

# linear -----------------------------------------------------------------------
# cp
cp_fit <- fit_logistic(df_diff$cp, df_diff$epilepsy)
compare_logistic(cp_fit)
# P(b > 0) = 32.57 +/- 0.9%
# P(b < 0) = 67.42 +/- 0.9%

# cc
cc_fit <- fit_logistic(df_diff$cc, df_diff$epilepsy)
compare_logistic(cc_fit)
# P(b > 0) = 28.4 +/- 0.9%
# P(b < 0) = 71.6 +/- 0.9%

# sw
sw_fit <- fit_logistic(df_diff$sw, df_diff$epilepsy)
compare_logistic(sw_fit)
# P(b > 0) = 39.85 +/- 0.8%
# P(b < 0) = 60.15 +/- 0.8%

# mod
mod_fit <- fit_logistic(df_diff$mod, df_diff$epilepsy)
compare_logistic(mod_fit)
# P(b > 0) = 64.22 +/- 0.9%
# P(b < 0) = 35.77 +/- 0.9%

# dv
dv_fit <- fit_logistic(df_diff$dv, df_diff$epilepsy)
compare_logistic(dv_fit)
# P(b > 0) = 40.6 +/- 1%
# P(b < 0) = 59.4 +/- 1%

# tihs
tihs_fit <- fit_logistic(df_diff$tihs, df_diff$epilepsy)
compare_logistic(tihs_fit)
# P(b > 0) = 23.65 +/- 0.8%
# P(b < 0) = 76.35 +/- 0.8%
