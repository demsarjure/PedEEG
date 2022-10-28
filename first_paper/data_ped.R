# libraries
library(tidyverse)

# load test data ---------------------------------------------------------------
# metrics
columns_metrics <- c("id", "cp", "ge", "cc", "sw", "mod", "dv")
df <- read.csv(paste0("../data/test/metrics_", band, ".csv"))
colnames(df) <- columns_metrics

# inter-hemispheric metrics
columns_inter <- c(
  "id", "nihs", "tihs",
  "cp_l", "ge_l", "cc_l", "sw_l", "mod_l", "dv_l",
  "cp_r", "ge_r", "cc_r", "sw_r", "mod_r", "dv_r"
)
df_ihs <- read.csv(paste0("../data/test/metrics_inter_", band, ".csv"))
colnames(df_ihs) <- columns_inter
df <- df %>% left_join(df_ihs)

# frequency metrics only for alfa
if (band == "alpha") {
  columns_freq <- c("id", "ap")
  df_freq <- read.csv(paste0("../data/test/metrics_freq.csv"))
  colnames(df_freq) <- columns_freq
  df <- df %>% left_join(df_freq)
}

# add age
df_age <- read.csv("../data/test/demographics_control.csv")
df_age <- df_age %>% select(id, age, sex)
df <- df %>% left_join(df_age)

# drop nas
df <- df %>% drop_na()

# remove participants with a lot of bad electrodes
#df <- df %>% filter(!id %in% c("PED_13", "PED_14", "PED_16"))

# remove participants that were recorded after the first papser
#df <- df %>% filter(!id %in% c("PED_26", "PED_27"))

# # exploratory plot
# df_s <- df %>%
#     select(id, cp, ge, cc, sw, tihs, ap, age, sex) %>%
#     pivot_longer(c("cp", "ge", "cc", "sw", "tihs", "ap"), names_to = "variable")

# df_s$sex <- factor(df_s$sex)

# ggplot(df_s, aes(x = age, y = value, color = sex)) +
#     geom_point(shape = 16) +
#     geom_smooth(method = "lm") +
#     facet_wrap(variable ~ ., ncol = 2, scales = "free_y") +
#     scale_color_brewer(type = "qual", palette = 3)
