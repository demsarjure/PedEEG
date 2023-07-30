library(ggplot2)
library(tidyverse)

# psych data
df_psych <- read_csv("../data/psych/psych.csv")

# neural data
column_metrics <- c("id", "cp", "ge", "cc", "sw", "mod", "dv")
df_neuro_control <- read_csv("../data/test/metrics_alpha.csv")
colnames(df_neuro_control) <- column_metrics
df_neuro_test <- read_csv("../data/test/metrics_T_alpha.csv")
colnames(df_neuro_test) <- column_metrics
df_neuro <- rbind(df_neuro_control, df_neuro_test)

# inter hemispheric data
columns_inter <- c(
    "id", "nihs", "tihs",
    "cp_l", "ge_l", "cc_l", "sw_l", "mod_l", "dv_l",
    "cp_r", "ge_r", "cc_r", "sw_r", "mod_r", "dv_r"
)
df_inter_control <- read_csv("../data/test/metrics_inter_alpha.csv")
colnames(df_inter_control) <- columns_inter
df_inter_test <- read_csv("../data/test/metrics_inter_T_alpha.csv")
colnames(df_inter_test) <- columns_inter
df_inter <- rbind(df_inter_control, df_inter_test)

# all data
df <- df_psych %>%
    left_join(df_neuro) %>%
    left_join(df_inter)

# exploratory plots
ggplot(df, aes(x = cp, y = iq, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = ge, y = iq, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = cc, y = iq, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = sw, y = iq, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = mod, y = iq, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm") +
    facet_grid(~control)

ggplot(df, aes(x = dv, y = iq, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = cp, y = iq_memory, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = ge, y = iq_memory, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = cc, y = iq_memory, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = sw, y = iq_memory, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = mod, y = iq_memory, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = dv, y = iq_memory, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = cp, y = iq_speed, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = ge, y = iq_speed, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = cc, y = iq_speed, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = sw, y = iq_speed, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = mod, y = iq_speed, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

ggplot(df, aes(x = dv, y = iq_speed, color = control)) +
    geom_point(shape = 16) +
    geom_smooth(method = "lm")

# modularity and iq
source("./utils/simple_linear.R")
mod <- as.numeric(scale(df$mod))
iq <- as.numeric(scale(df$iq))
iq_memory <- as.numeric(scale(df$iq_memory))
iq_speed <- as.numeric(scale(df$iq_speed))

mod_iq_fit <- fit_simple_linear(mod, iq, robust = TRUE)
compare_simple_linear(mod_iq_fit)

mod_iq_memory_fit <- fit_simple_linear(mod, iq_memory, robust = TRUE)
compare_simple_linear(mod_iq_memory_fit)

mod_iq_speed_fit <- fit_simple_linear(mod, iq_speed, robust = TRUE)
compare_simple_linear(mod_iq_speed_fit)

source("./utils/normal.R")
iq_control <- fit_normal(filter(df, control == 1)$iq, robust = TRUE)
iq_test <- fit_normal(filter(df, control == 0)$iq, robust = TRUE)
compare_two_normal(iq_control, label1 = "control", iq_test, label2 = "test")

mod_control <- fit_normal(filter(df, control == 1)$mod, robust = TRUE)
mod_test <- fit_normal(filter(df, control == 0)$mod, robust = TRUE)
compare_two_normal(mod_control, label1 = "control", mod_test, label2 = "test")

# visual_integration
source("./utils/normal.R")
vis_control <- fit_normal(filter(df, control == 1)$visual_integration, robust = TRUE)
vis_test <- fit_normal(filter(df, control == 0)$visual_integration, robust = TRUE)
compare_two_normal(vis_control, label1 = "control", vis_test, label2 = "test")

tihs_control <- fit_normal(filter(df, control == 1)$tihs, robust = TRUE)
tihs_test <- fit_normal(filter(df, control == 0)$tihs, robust = TRUE)
compare_two_normal(tihs_control, label1 = "control", tihs_test, label2 = "test")

source("./utils/simple_linear.R")
tihs <- as.numeric(scale(df$tihs))
vis <- as.numeric(scale(df$visual_integration))

tihs_vis_fit <- fit_simple_linear(tihs, vis, robust = TRUE)
compare_simple_linear(tihs_vis_fit)
