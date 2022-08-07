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
# P(control > test) = 31.85 +/- 1%
# P(control < test) = 68.15 +/- 1%

# injured
cp_i_fit <- fit_normal(df_diff_inter$cp_i)
compare_normal(cp_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 16.3 +/- 0.9%
# P(control < test) = 83.7 +/- 0.9%

# compare ge -------------------------------------------------------------------
# healthy
ge_h_fit <- fit_normal(df_diff_inter$ge_h)
compare_normal(ge_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 36.18 +/- 1%
# P(control < test) = 63.82 +/- 1%

# injured
ge_i_fit <- fit_normal(df_diff_inter$ge_i)
compare_normal(ge_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 37.25 +/- 0.8%
# P(control < test) = 62.75 +/- 0.8%

# compare cc -------------------------------------------------------------------
# healthy
cc_h_fit <- fit_normal(df_diff_inter$cc_h)
compare_normal(cc_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 26.15 +/- 0.9%
# P(control < test) = 73.85 +/- 0.9%

# injured
cc_i_fit <- fit_normal(df_diff_inter$cc_i)
compare_normal(cc_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 11.92 +/- 0.7%
# P(control < test) = 88.08 +/- 0.7%

# compare sw -------------------------------------------------------------------
# healthy
sw_h_fit <- fit_normal(df_diff_inter$sw_h)
compare_normal(sw_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 98.1 +/- 0.4%
# P(control < test) = 1.9 +/- 0.4%

# injured
sw_i_fit <- fit_normal(df_diff_inter$sw_i)
compare_normal(sw_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 43.9 +/- 0.8%
# P(control < test) = 56.1 +/- 0.8%

# compare bc -------------------------------------------------------------------
# healthy
bc_h_fit <- fit_normal(df_diff_inter$bc_h)
compare_normal(bc_h_fit, label1 = "control", label2 = "test")
# P(control > test) = 88.38 +/- 0.7%
# P(control < test) = 11.62 +/- 0.7%

# injured
bc_i_fit <- fit_normal(df_diff_inter$bc_i)
compare_normal(bc_i_fit, label1 = "control", label2 = "test")
# P(control > test) = 46.83 +/- 0.8%
# P(control < test) = 53.17 +/- 0.8%
