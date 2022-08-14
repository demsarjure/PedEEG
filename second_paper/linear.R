# Global metrics comparisons between the test and the control group.

# load data and models ---------------------------------------------------------
source("data.R")
source("./utils/simple_linear.R")

# linear -----------------------------------------------------------------------
# cp
fit_cp <- fit_simple_linear(df_diff$volume, df_diff$cp)
compare_simple_linear(fit_cp)
# P(β > 0) = 78.05 +/- 0.8%
# P(β < 0) = 21.95 +/- 0.8%

# cc
fit_cc <- fit_simple_linear(df_diff$volume, df_diff$cc)
compare_simple_linear(fit_cc)
# P(β > 0) = 68.5 +/- 0.8%
# P(β < 0) = 31.5 +/- 0.8%

# sw
fit_sw <- fit_simple_linear(df_diff$volume, df_diff$sw)
compare_simple_linear(fit_sw)
# P(β > 0) = 81.62 +/- 0.8%
# P(β < 0) = 18.38 +/- 0.8%

# mod
fit_mod <- fit_simple_linear(df_diff$volume, df_diff$mod)
compare_simple_linear(fit_mod)
# P(β > 0) = 81.27 +/- 0.8%
# P(β < 0) = 18.73 +/- 0.8%

# dv
fit_dv <- fit_simple_linear(df_diff$volume, df_diff$dv)
compare_simple_linear(fit_dv)
# P(β > 0) = 85.67 +/- 0.7%
# P(β < 0) = 14.32 +/- 0.7%

# nihs
fit_nihs <- fit_simple_linear(df_diff$volume, df_diff$nihs)
compare_simple_linear(fit_nihs)
# P(β > 0) = 45.45 +/- 0.9%
# P(β < 0) = 54.55 +/- 0.9%

# tihs
fit_tihs <- fit_simple_linear(df_diff$volume, df_diff$tihs)
compare_simple_linear(fit_tihs)
# P(β > 0) = 71.95 +/- 1%
# P(β < 0) = 28.05 +/- 1%
