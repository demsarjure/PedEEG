library(ggplot2)
library(tidyverse)

source("data.R")
source("./utils/normal.R")
source("./utils/simple_linear.R")

# neural variables
# cp
# mod
# tihs

# behavior variables
# iq
# iq_memory
# iq_speed
# visual_integration
# hrt
# motor_coordination
# d
# omissions
# comissions
# perservation

# diff neural measure vs behavior ----------------------------------------------
neural <- as.numeric(scale(df_diff$tihs))
behavior <- as.numeric(scale(df_diff$perservation))

# higher tihs is larger perservation
# higher tihs is larger omissions

linear_fit <- fit_simple_linear(neural, behavior, robust = TRUE)
compare_simple_linear(linear_fit)
plot_simple_linear(linear_fit, min_x = -3, max_x = 3)

# all data ---------------------------------------------------------------------
df_analysis <- data.frame(
    control = as.factor(df_all$control),
    neural = scale(df_all$tihs),
    behavior = scale(df_all$perservation)
) %>% drop_na()

linear_fit <- fit_simple_linear(
    df_analysis$neural,
    df_analysis$behavior,
    robust = TRUE
)
compare_simple_linear(linear_fit)
plot_simple_linear(linear_fit, min_x = -3, max_x = 3)

# test group only --------------------------------------------------------------
df_analysis <- data.frame(
    neural = scale(df_test$tihs),
    behavior = scale(df_test$perservation)
) %>% drop_na()

linear_fit <- fit_simple_linear(
    df_analysis$neural,
    df_analysis$behavior,
    robust = TRUE
)
compare_simple_linear(linear_fit)
plot_simple_linear(linear_fit, min_x = -3, max_x = 3)

# diff control vs test ---------------------------------------------------------
diff_fit <- fit_normal(df_diff$perservation)
compare_normal(diff_fit, label1 = "control", label2 = "test")
plot_comparison_normal(diff_fit)

# normal control vs test -------------------------------------------------------
control_fit <- fit_normal(df_control$perservation)
test_fit <- fit_normal(df_test$perservation)
compare_two_normal(
    fit1 = control_fit,
    label1 = "control",
    fit2 = test_fit,
    label2 = "test"
)
plot_comparison_two_normal(
    fit1 = control_fit,
    label1 = "control",
    fit2 = test_fit,
    label2 = "test"
)
