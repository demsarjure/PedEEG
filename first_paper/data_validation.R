# libraries
library(tidyverse)

# load validation dataset ------------------------------------------------------
# metrics
df <- read.csv(paste0("../data/validation/metrics_", band, ".csv"))
colnames(df) <- c("id", "cp", "ge", "cc", "sw")

# inter-hemispheric metrics
df_ihs <- read.csv(paste0("../data/validation/metrics_inter_", band, ".csv"))
colnames(df_ihs) <- c("id", "nihs", "tihs")
df <- df %>% left_join(df_ihs)

# frequency metrics only for alfa
if (band == "alpha") {
  df_freq <- read.csv(paste0("../data/validation/metrics_freq.csv"))
  colnames(df_freq) <- c("id", "ap")
  df <- df %>% left_join(df_freq)
}

# add age
df_age <- read.csv("../data/validation/MIPDB_PublicFile.csv")
df_age <- df_age %>% select(ID, Age, Sex)
colnames(df_age) <- c("id", "age", "sex")
df <- df %>% left_join(df_age)

# drop nas
df <- df %>% drop_na()

# exploratory plot
# df_s <- df %>%
#     select(id, cp, ge, cc, sw, tihs, ap, age, sex) %>%
#     pivot_longer(c("cp", "ge", "cc", "sw", "tihs", "ap"), names_to = "variable")

# df_s$sex <- factor(df_s$sex)

# ggplot(df_s, aes(x = age, y = value, color = sex)) +
#     geom_point(shape = 16) +
#     geom_smooth(method = "lm") +
#     facet_wrap(variable ~ ., ncol = 2, scales = "free_y") +
#     scale_color_brewer(type = "qual", palette = 3)
