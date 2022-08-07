# Inter-hemispheric comparisons between the test and the control group.

# libraries
library(tidyverse)

# load data and models ---------------------------------------------------------
source("./utils/normal.R")
source("data.R")

# compare cp -------------------------------------------------------------------
# healthy
cp_h_fit <- fit_normal(df_diff_inter$cp_h)
compare_normal(cp_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 30.95 +/- 0.9%
# P(control < test) = 69.05 +/- 0.9%

# injured
cp_i_fit <- fit_normal(df_diff_inter$cp_i)
compare_normal(cp_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 13.1 +/- 0.8%
# P(control < test) = 86.9 +/- 0.8%

# compare ge -------------------------------------------------------------------
# healthy
ge_h_fit <- fit_normal(df_diff_inter$ge_h)
compare_normal(ge_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 32.73 +/- 0.9%
# P(control < test) = 67.27 +/- 0.9%

# injured
ge_i_fit <- fit_normal(df_diff_inter$ge_i)
compare_normal(ge_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 33.15 +/- 0.8%
# P(control < test) = 66.85 +/- 0.8%

# compare cc -------------------------------------------------------------------
# healthy
cc_h_fit <- fit_normal(df_diff_inter$cc_h)
compare_normal(cc_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 25.05 +/- 1%
# P(control < test) = 74.95 +/- 1%

# injured
cc_i_fit <- fit_normal(df_diff_inter$cc_i)
compare_normal(cc_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 10.17 +/- 0.7%
# P(control < test) = 89.83 +/- 0.7%

# compare sw -------------------------------------------------------------------
# healthy
sw_h_fit <- fit_normal(df_diff_inter$sw_h)
compare_normal(sw_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 96.33 +/- 0.4%
# P(control < test) = 3.67 +/- 0.4%

# injured
sw_i_fit <- fit_normal(df_diff_inter$sw_i)
compare_normal(sw_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 34.55 +/- 0.9%
# P(control < test) = 65.45 +/- 0.9%

# compare bc -------------------------------------------------------------------
# healthy
bc_h_fit <- fit_normal(df_diff_inter$bc_h)
compare_normal(bc_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 43.48 +/- 1%
# P(control < test) = 56.53 +/- 1%

# injured
bc_i_fit <- fit_normal(df_diff_inter$bc_i)
compare_normal(bc_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 44.35 +/- 0.9%
# P(control < test) = 55.65 +/- 0.9%
