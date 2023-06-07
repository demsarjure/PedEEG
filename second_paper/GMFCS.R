# Global metrics comparisons between the test and the control group.
library(cowplot)

# load data and models ---------------------------------------------------------
source("data.R")
source("./utils/simple_linear.R")

# linear -----------------------------------------------------------------------
# cp
cp_fit <- fit_simple_linear(df_diff$cp, df_diff$GMFCS)
compare_simple_linear(cp_fit)
# P(b > 0) = 61.15 +/- 0.8%
# P(b < 0) = 38.85 +/- 0.8%

# cc
cc_fit <- fit_simple_linear(df_diff$cc, df_diff$GMFCS)
compare_simple_linear(cc_fit)
# P(b > 0) = 53.47 +/- 0.8%
# P(b < 0) = 46.52 +/- 0.8%

# sw
sw_fit <- fit_simple_linear(df_diff$sw, df_diff$GMFCS)
compare_simple_linear(sw_fit)
# P(b > 0) = 64.05 +/- 0.8%
# P(b < 0) = 35.95 +/- 0.8%

# mod
mod_fit <- fit_simple_linear(df_diff$mod, df_diff$GMFCS)
compare_simple_linear(mod_fit)
# P(b > 0) = 81.17 +/- 0.7%
# P(b < 0) = 18.82 +/- 0.7%

# dv
dv_fit <- fit_simple_linear(df_diff$dv, df_diff$GMFCS)
compare_simple_linear(dv_fit)
# P(b > 0) = 78.83 +/- 0.7%
# P(b < 0) = 21.18 +/- 0.7%

# tihs
tihs_fit <- fit_simple_linear(df_diff$tihs, df_diff$GMFCS)
compare_simple_linear(tihs_fit)
# P(b > 0) = 66.92 +/- 0.7%
# P(b < 0) = 33.07 +/- 0.7%
