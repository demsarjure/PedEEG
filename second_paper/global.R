# Global metrics comparisons between the test and the control group.

# libraries
library(tidyverse)

# load data and models ---------------------------------------------------------
source("./utils/normal.R")
source("data.R")

# compare cp -------------------------------------------------------------------
cp_fit <- fit_normal(df_diff$cp)
compare_normal(cp_fit, label1 = "control", label2 = "test")
# P(control > test) = 16.8 +/- 0.9%
# P(control < test) = 83.2 +/- 0.9%

# compare ge -------------------------------------------------------------------
ge_fit <- fit_normal(df_diff$ge)
compare_normal(ge_fit, label1 = "control", label2 = "test")
# P(control > test) = 30.28 +/- 0.9%
# P(control < test) = 69.73 +/- 0.9%

# compare cc -------------------------------------------------------------------
cc_fit <- fit_normal(df_diff$cc)
compare_normal(cc_fit, label1 = "control", label2 = "test")
# P(control > test) = 13.65 +/- 0.8%
# P(control < test) = 86.35 +/- 0.8%

# compare sw -------------------------------------------------------------------
sw_fit <- fit_normal(df_diff$sw)
compare_normal(sw_fit, label1 = "control", label2 = "test")
# P(control > test) = 20.75 +/- 0.9%
# P(control < test) = 79.25 +/- 0.9%

# compare bc -------------------------------------------------------------------
bc_fit <- fit_normal(df_diff$bc)
compare_normal(bc_fit, label1 = "control", label2 = "test")
# P(control > test) = 16.9 +/- 0.8%
# P(control < test) = 83.1 +/- 0.8%

# compare ap -------------------------------------------------------------------
ap_fit <- fit_normal(df_diff$ap)
compare_normal(ap_fit, label1 = "control", label2 = "test")
# P(control > test) = 98.7 +/- 0.2%
# P(control < test) = 1.3 +/- 0.2%

# compare normalized_ihs -------------------------------------------------------
normalized_ihs_fit <- fit_normal(df_diff$normalized_ihs)
compare_normal(normalized_ihs_fit, label1 = "control", label2 = "test")
# P(control > test) = 71.45 +/- 0.9%
# P(control < test) = 28.55 +/- 0.9%

# compare total_ihs -------------------------------------------------------
total_ihs_fit <- fit_normal(df_diff$total_ihs)
compare_normal(total_ihs_fit, label1 = "control", label2 = "test")
# P(control > test) = 19.35 +/- 0.8%
# P(control < test) = 80.65 +/- 0.8%
