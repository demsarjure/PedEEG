# Global metrics comparisons between the test and the control group.
library(tidyverse)
library(ggplot2)

# load data and models ---------------------------------------------------------
source("data.R")

# global tests -----------------------------------------------------------------
source("./utils/normal.R")
p_c <- fit_normal(df_control_filter$cp)
cp_t <- fit_normal(df_test_filter$cp)
compare_two_normal(cp_c, "Control", cp_t, "Test")

sw_c <- fit_normal(df_control_filter$sw)
sw_t <- fit_normal(df_test_filter$sw)
compare_two_normal(sw_c, "Control", sw_t, "Test")

mod_c <- fit_normal(df_control_filter$mod)
mod_t <- fit_normal(df_test_filter$mod)
compare_two_normal(mod_c, "Control", mod_t, "Test")

dv_c <- fit_normal(df_control_filter$dv)
dv_t <- fit_normal(df_test_filter$dv)
compare_two_normal(dv_c, "Control", dv_t, "Test")

ihs_c <- fit_normal(df_control_filter$nihs)
ihs_t <- fit_normal(df_test_filter$nihs)
compare_two_normal(ihs_c, "Control", ihs_t, "Test")

ihs_c <- fit_normal(df_control_filter$tihs)
ihs_t <- fit_normal(df_test_filter$tihs)
compare_two_normal(ihs_c, "Control", ihs_t, "Test")
