# helper function for loading data
library(tidyverse)

# load all data ----------------------------------------------------------------
columns_metrics <- c("id", "cp", "ge", "cc", "sw", "mod", "dv")
columns_inter <- c(
  "id", "nihs", "tihs",
  "cp_l", "ge_l", "cc_l", "sw_l", "mod_l", "dv_l",
  "cp_r", "ge_r", "cc_r", "sw_r", "mod_r", "dv_r"
)

df_control <- read.csv("../data/test/metrics_alpha.csv")
colnames(df_control) <- columns_metrics

df_control_inter <- read.csv("../data/test/metrics_inter_alpha.csv")
colnames(df_control_inter) <- columns_inter

df_test <- read.csv("../data/test/metrics_T_alpha.csv")
colnames(df_test) <- columns_metrics

df_test_inter <- read.csv("../data/test/metrics_inter_T_alpha.csv")
colnames(df_test_inter) <- columns_inter

df_pairs <- read.csv("../data/test/pairs.csv")

df_psych <- read.csv("../data/psych/psych.csv")

# merge
df_control <- df_control %>%
  inner_join(df_control_inter) %>%
  inner_join(df_psych)

df_test <- df_test %>%
  inner_join(df_test_inter) %>%
  inner_join(df_psych)

# filter out test participants that do not match the criteria
remove_ids <- c(
  "PED_T_02",
  "PED_T_09",
  "PED_T_12",
  "PED_T_13",
  "PED_T_15",
  "PED_T_25"
)

df_pairs <- df_pairs %>%
  filter(!id_test %in% remove_ids)

df_test <- df_test %>%
  filter(!id %in% remove_ids)

# variables of interest
demo_vars <- c("id")

neural_vars <- c(
  "cp",
  "cc",
  "mod",
  "sw",
  "tihs"
)

behavior_vars <- c(
  "iq",
  "iq_memory",
  "iq_speed",
  "visual_motor",
  "visual",
  "motor",
  "omissions",
  "comissions",
  "perservation"
)

all_vars <- c(neural_vars, behavior_vars)

df_control <- df_control %>%
  select(all_of(c(demo_vars, all_vars)))

df_test <- df_test %>%
  select(all_of(c(demo_vars, all_vars)))

# compute pairwise differences -------------------------------------------------
df_diff <- data.frame(
  cp = numeric(),
  cc = numeric(),
  mod = numeric(),
  sw = numeric(),
  tihs = numeric(),
  iq = numeric(),
  iq_memory = numeric(),
  iq_speed = numeric(),
  visual_motor = numeric(),
  visual = numeric(),
  motor = numeric(),
  omissions = numeric(),
  comissions = numeric(),
  perservation = numeric()
)

for (i in seq_len(nrow(df_pairs))) {
  p <- df_pairs[i, ]
  c <- df_control %>% filter(id == p$id_control)
  t <- df_test %>% filter(id == p$id_test)

  if (nrow(c) > 0 && nrow(t) > 0) {
    df_diff <- df_diff %>% add_row(data.frame(
      cp = c$cp - t$cp,
      cc = c$cc - t$cc,
      mod = c$mod - t$mod,
      sw = c$sw - t$sw,
      tihs = c$tihs - t$tihs,
      iq = c$iq - t$iq,
      iq_memory = c$iq_memory - t$iq_memory,
      iq_speed = c$iq_speed - t$iq_speed,
      visual_motor = c$visual_motor - t$visual_motor,
      visual = c$visual - t$visual,
      motor = c$motor - t$motor,
      omissions = c$omissions - t$omissions,
      comissions = c$comissions - t$comissions,
      perservation = c$perservation - t$perservation
    ))
  }
}

# remove demographic vars ------------------------------------------------------
df_test <- df_test %>%
  select(-all_of(demo_vars))

df_control <- df_control %>%
  select(-all_of(demo_vars))
