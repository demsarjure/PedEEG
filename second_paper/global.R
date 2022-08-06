# Script for global metrics comparisons between the test and the control group

# libraries
library(tidyverse)

# load data and models ---------------------------------------------------------
source("./utils/normal.R")

columns <- c("ID", "cp", "ge", "cc", "sw", "as", "bc", "dd")

df_control <- read.csv("../data/ped/metrics_laplace.csv")
colnames(df_control) <- columns

df_test <- read.csv("../data/ped/metrics_T_laplace.csv")
colnames(df_test) <- columns


# compare cp -------------------------------------------------------------------
# control
cp_control <- fit_normal(df_control$cp)

# test
cp_test <- fit_normal(df_test$cp)

# compare
compare_normal(cp_control, "Control", cp_test, "Test")
# --------------------------------------------------
# P(Control > Test) = 21.68 +/- 0.7%
# P(Control < Test) = 78.33 +/- 0.7%
# --------------------------------------------------


# compare ge -------------------------------------------------------------------
# control
ge_control <- fit_normal(df_control$ge)

# test
ge_test <- fit_normal(df_test$ge)

# compare
compare_normal(ge_control, "Control", ge_test, "Test")
# --------------------------------------------------
# Control > Test: 0.34025 +/- 0.00846696721336751
# Control < Test: 0.65975 +/- 0.00846696721336751
# --------------------------------------------------


# compare cc -------------------------------------------------------------------
# control
cc_control <- fit_normal(df_control$cc)

# test
cc_test <- fit_normal(df_test$cc)

# compare
compare_normal(cc_control, "Control", cc_test, "Test")
# --------------------------------------------------
# Control > Test: 0.20575 +/- 0.00703263779587425
# Control < Test: 0.79425 +/- 0.00703263779587425
# --------------------------------------------------


# compare sw -------------------------------------------------------------------
# control
sw_control <- fit_normal(df_control$sw)

# test
sw_test <- fit_normal(df_test$sw)

# compare
compare_normal(sw_control, "Control", sw_test, "Test")
# --------------------------------------------------
# Control > Test: 0.23225 +/- 0.00713606059817744
# Control < Test: 0.76775 +/- 0.00713606059817744
# --------------------------------------------------


# compare as -------------------------------------------------------------------
# control
as_control <- fit_normal(df_control$as)

# test
as_test <- fit_normal(df_test$as)

# compare
compare_normal(as_control, "Control", as_test, "Test")
# --------------------------------------------------
# Control > Test: 0.214 +/- 0.00673294109180718
# Control < Test: 0.7855 +/- 0.00673958790455676
# --------------------------------------------------


# compare bc -------------------------------------------------------------------
# control
bc_control <- fit_normal(df_control$bc)

# test
bc_test <- fit_normal(df_test$bc)

# compare
compare_normal(bc_control, "Control", bc_test, "Test")
# --------------------------------------------------
# Control > Test: 0.02625 +/- 0.00302598557779062
# Control < Test: 0.97375 +/- 0.00302598557779063
# --------------------------------------------------


# compare dd -------------------------------------------------------------------
# control
dd_control <- fit_normal(df_control$dd)

# test
dd_test <- fit_normal(df_test$dd)

# compare
compare_normal(dd_control, "Control", dd_test, "Test")
# --------------------------------------------------
# Control > Test: 0.217 +/- 0.00713809782439887
# Control < Test: 0.783 +/- 0.00713809782439887
# --------------------------------------------------
