# Global metrics comparisons between the test and the control group.
library(cowplot)

# load data and models ---------------------------------------------------------
source("data.R")
source("./utils/simple_linear.R")

# linear -----------------------------------------------------------------------
# cp
cp_fit <- fit_simple_linear(df_diff$cp, df_diff$cognitive)
compare_simple_linear(cp_fit)
# P(b > 0) = 53.08 +/- 0.7%
# P(b < 0) = 46.92 +/- 0.7%

# cc
cc_fit <- fit_simple_linear(df_diff$cc, df_diff$cognitive)
compare_simple_linear(cc_fit)
# P(b > 0) = 54.93 +/- 0.8%
# P(b < 0) = 45.07 +/- 0.8%

# sw
sw_fit <- fit_simple_linear(df_diff$sw, df_diff$cognitive)
compare_simple_linear(sw_fit)
# P(b > 0) = 50.4 +/- 0.8%
# P(b < 0) = 49.6 +/- 0.8%

# mod
mod_fit <- fit_simple_linear(df_diff$mod, df_diff$cognitive)
compare_simple_linear(mod_fit)
# P(b > 0) = 45.4 +/- 0.8%
# P(b < 0) = 54.6 +/- 0.8%

# dv
dv_fit <- fit_simple_linear(df_diff$dv, df_diff$cognitive)
compare_simple_linear(dv_fit)
# P(b > 0) = 29.68 +/- 0.8%
# P(b < 0) = 70.33 +/- 0.8%

# tihs
tihs_fit <- fit_simple_linear(df_diff$tihs, df_diff$cognitive)
compare_simple_linear(tihs_fit)
# P(b > 0) = 52.6 +/- 0.8%
# P(b < 0) = 47.4 +/- 0.8%
