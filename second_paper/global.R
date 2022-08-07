# Global metrics comparisons between the test and the control group.

# libraries
library(tidyverse)

# load data and models ---------------------------------------------------------
source("./utils/normal.R")
source("data.R")

# compare cp -------------------------------------------------------------------
cp_fit <- fit_normal(df_diff$cp)
compare_normal(cp_fit, label1 = "control", label2 = "test")
# P(control > test) = 15.82 +/- 0.8%
# P(control < test) = 84.17 +/- 0.8%

# compare ge -------------------------------------------------------------------
ge_fit <- fit_normal(df_diff$ge)
compare_normal(ge_fit, label1 = "control", label2 = "test")
# P(control > test) = 28.82 +/- 0.9%
# P(control < test) = 71.17 +/- 0.9%

# compare cc -------------------------------------------------------------------
cc_fit <- fit_normal(df_diff$cc)
compare_normal(cc_fit, label1 = "control", label2 = "test")
# P(control > test) = 11.12 +/- 0.7%
# P(control < test) = 88.88 +/- 0.7%

# compare sw -------------------------------------------------------------------
sw_fit <- fit_normal(df_diff$sw)
compare_normal(sw_fit, label1 = "control", label2 = "test")
# P(control > test) = 23.1 +/- 0.8%
# P(control < test) = 76.9 +/- 0.8%

# compare bc -------------------------------------------------------------------
bc_fit <- fit_normal(df_diff$bc)
compare_normal(bc_fit, label1 = "control", label2 = "test")
# P(control > test) = 9.4 +/- 0.7%
# P(control < test) = 90.6 +/- 0.7%

# compare ap -------------------------------------------------------------------
ap_fit <- fit_normal(df_diff$ap)
compare_normal(ap_fit, label1 = "control", label2 = "test")
# P(control > test) = 99.12 +/- 0.2%
# P(control < test) = 0.88 +/- 0.2%

# compare normalized_ihs -------------------------------------------------------
normalized_ihs_fit <- fit_normal(df_diff$normalized_ihs)
compare_normal(normalized_ihs_fit, label1 = "control", label2 = "test")
# P(control > test) = 83.45 +/- 0.8%
# P(control < test) = 16.55 +/- 0.8%

# compare total_ihs -------------------------------------------------------
total_ihs_fit <- fit_normal(df_diff$total_ihs)
compare_normal(total_ihs_fit, label1 = "control", label2 = "test")
# P(control > test) = 18.52 +/- 0.9%
# P(control < test) = 81.47 +/- 0.9%
