library(ggplot2)
library(tidyverse)

# load data and models ---------------------------------------------------------
source("./utils/simple_linear.R")
source("data.R")

# modularity and iq ------------------------------------------------------------
mod <- as.numeric(scale(df_diff$mod))
iq <- as.numeric(scale(df_diff$iq))
mod_iq_fit <- fit_simple_linear(mod, iq, robust = TRUE)
compare_simple_linear(mod_iq_fit)
# P(b > 0) = 100 +/- 0%
# P(b < 0) = 0 +/- 0%

# modularity and iq_memory -----------------------------------------------------
mod <- as.numeric(scale(df_diff$mod))
iq_memory <- as.numeric(scale(df_diff$iq_memory))
mod_iq_memory_fit <- fit_simple_linear(mod, iq_memory, robust = TRUE)
compare_simple_linear(mod_iq_memory_fit)
# P(b > 0) = 98.15 +/- 0.3%
# P(b < 0) = 1.85 +/- 0.3%

# modularity and iq_speed ------------------------------------------------------
mod <- as.numeric(scale(df_diff$mod))
iq_speed <- as.numeric(scale(df_diff$iq_speed))
mod_iq_speed_fit <- fit_simple_linear(mod, iq_speed, robust = TRUE)
compare_simple_linear(mod_iq_speed_fit)
# P(b > 0) = 99.67 +/- 0.1%
# P(b < 0) = 0.32 +/- 0.1%

# tihs and vis -----------------------------------------------------------------
tihs <- as.numeric(scale(df_diff$tihs))
vis <- as.numeric(scale(df_diff$vis))
tihs_vis_fit <- fit_simple_linear(tihs, vis, robust = TRUE)
compare_simple_linear(tihs_vis_fit)
# P(b > 0) = 37.4 +/- 0.8%
# P(b < 0) = 62.6 +/- 0.8%

# ge and iq --------------------------------------------------------------------
ge <- as.numeric(scale(df_diff$ge))
iq <- as.numeric(scale(df_diff$iq))
ge_iq_fit <- fit_simple_linear(ge, iq, robust = TRUE)
compare_simple_linear(ge_iq_fit)
# P(b > 0) = 61.65 +/- 0.8%
# P(b < 0) = 38.35 +/- 0.8%

# ge and iq_memory -------------------------------------------------------------
ge <- as.numeric(scale(df_diff$ge))
iq_memory <- as.numeric(scale(df_diff$iq_memory))
ge_iq_memory_fit <- fit_simple_linear(ge, iq_memory, robust = TRUE)
compare_simple_linear(ge_iq_memory_fit)
# P(b > 0) = 56.25 +/- 0.8%
# P(b < 0) = 43.75 +/- 0.8%

# ge and iq_speed --------------------------------------------------------------
ge <- as.numeric(scale(df_diff$ge))
iq_speed <- as.numeric(scale(df_diff$iq_speed))
ge_iq_speed_fit <- fit_simple_linear(ge, iq_speed, robust = TRUE)
compare_simple_linear(ge_iq_speed_fit)
# P(b > 0) = 96.62 +/- 0.4%
# P(b < 0) = 3.38 +/- 0.4%

# tihs and hrt -----------------------------------------------------------------
tihs <- as.numeric(scale(df_diff$tihs))
hrt <- as.numeric(scale(df_diff$hrt))
tihs_hrt_fit <- fit_simple_linear(tihs, hrt, robust = TRUE)
compare_simple_linear(tihs_hrt_fit)
# P(b > 0) = 75.85 +/- 0.7%
# P(b < 0) = 24.15 +/- 0.7%
