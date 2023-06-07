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

df_control <- df_control %>%
  inner_join(df_control_inter)

df_test <- read.csv("../data/test/metrics_T_alpha.csv")
colnames(df_test) <- columns_metrics

df_test_inter <- read.csv("../data/test/metrics_inter_T_alpha.csv")
colnames(df_test_inter) <- columns_inter

df_test <- df_test %>%
  inner_join(df_test_inter)

df_pairs <- read.csv("../data/test/pairs.csv")

df_demo_test <- read.csv("../data/test/demographics_test_volume.csv")

# filter
df_test_filter <- df_test %>%
  filter(id %in% df_pairs$id_test)

df_control_filter <- df_control %>%
  filter(id %in% df_pairs$id_control)

# compute global pairwise differences ------------------------------------------
df_diff <- data.frame(
  id = character(),
  volume = numeric(),
  GMFCS = numeric(),
  cognitive = numeric(),
  epilepsy = numeric(),
  cp = numeric(),
  cc = numeric(),
  sw = numeric(),
  mod = numeric(),
  dv = numeric(),
  tihs = numeric()
)

for (i in seq_len(nrow(df_pairs))) {
  p <- df_pairs[i, ]
  d <- df_demo_test %>% filter(id == p$id_test)
  c <- df_control %>% filter(id == p$id_control)
  t <- df_test %>% filter(id == p$id_test)

  df_diff <- df_diff %>% add_row(data.frame(
    id = t$id,
    volume = d$volume,
    GMFCS = d$GMFCS,
    cognitive = d$cognitive,
    epilepsy = d$epilepsy,
    cp = c$cp - t$cp,
    cc = c$cc - t$cc,
    sw = c$sw - t$sw,
    mod = c$mod - t$mod,
    dv = c$dv - t$dv,
    tihs = c$tihs - t$tihs
  ))
}

# compute inter-hemispheric pairwise differences -------------------------------
# _h means healthy
# _i means injured
df_diff_inter <- data.frame(
  id = character(),
  volume = numeric(),
  GMFCS = numeric(),
  cognitive = numeric(),
  epilepsy = numeric(),
  cp_h = numeric(),
  cp_i = numeric(),
  cc_h = numeric(),
  cc_i = numeric(),
  sw_h = numeric(),
  sw_i = numeric(),
  mod_h = numeric(),
  mod_i = numeric(),
  dv_h = numeric(),
  dv_i = numeric()
)

for (i in seq_len(nrow(df_pairs))) {
  p <- df_pairs[i, ]
  d <- df_demo_test %>% filter(id == p$id_test)
  c <- df_control %>% filter(id == p$id_control)
  t <- df_test %>% filter(id == p$id_test)

  # if the lesion was in the left hemisphere
  if (d$location == "l") {
    df_diff_inter <- df_diff_inter %>% add_row(data.frame(
      id = t$id,
      volume = d$volume,
      GMFCS = d$GMFCS,
      cognitive = d$cognitive,
      epilepsy = d$epilepsy,
      cp_h = c$cp_r - t$cp_r,
      cp_i = c$cp_l - t$cp_l,
      cc_h = c$cc_r - t$cc_r,
      cc_i = c$cc_l - t$cc_l,
      sw_h = c$sw_r - t$sw_r,
      sw_i = c$sw_l - t$sw_l,
      mod_h = c$mod_r - t$mod_r,
      mod_i = c$mod_l - t$mod_l,
      dv_h = c$dv_r - t$dv_r,
      dv_i = c$dv_l - t$dv_l
    ))
  }
  # if the lesion was in the right hemisphere
  else if (d$location == "r") {
    df_diff_inter <- df_diff_inter %>% add_row(data.frame(
      id = t$id,
      volume = d$volume,
      GMFCS = d$GMFCS,
      cognitive = d$cognitive,
      epilepsy = d$epilepsy,
      cp_h = c$cp_l - t$cp_l,
      cp_i = c$cp_r - t$cp_r,
      cc_h = c$cc_l - t$cc_l,
      cc_i = c$cc_r - t$cc_r,
      sw_h = c$sw_l - t$sw_l,
      sw_i = c$sw_r - t$sw_r,
      mod_h = c$mod_l - t$mod_l,
      mod_i = c$mod_r - t$mod_r,
      dv_h = c$dv_l - t$dv_l,
      dv_i = c$dv_r - t$dv_r
    ))
  }
}

# compute inter-hemispheric within subject differences -------------------------
df_diff_injured <- data.frame(
  id = character(),
  volume = numeric(),
  GMFCS = numeric(),
  cognitive = numeric(),
  epilepsy = numeric(),
  cp = numeric(),
  cc = numeric(),
  sw = numeric(),
  mod = numeric(),
  dv = numeric()
)

for (i in seq_len(nrow(df_test_filter))) {
  t <- df_test_filter[i, ]
  d <- df_demo_test %>% filter(id == t$id)

  # if the lesion was in the left hemisphere
  if (d$location == "l") {
    df_diff_injured <- df_diff_injured %>% add_row(data.frame(
      id = t$id,
      volume = d$volume,
      GMFCS = d$GMFCS,
      cognitive = d$cognitive,
      epilepsy = d$epilepsy,
      cp = t$cp_r - t$cp_l,
      cc = t$cc_r - t$cc_l,
      sw = t$sw_r - t$sw_l,
      mod = t$mod_r - t$mod_l,
      dv = t$dv_r - t$dv_l
    ))
  }
  # if the lesion was in the right hemisphere
  else if (d$location == "r") {
    df_diff_injured <- df_diff_injured %>% add_row(data.frame(
      id = t$id,
      volume = d$volume,
      GMFCS = d$GMFCS,
      cognitive = d$cognitive,
      epilepsy = d$epilepsy,
      cp = t$cp_l - t$cp_r,
      cc = t$cc_l - t$cc_r,
      sw = t$sw_l - t$sw_r,
      mod = t$mod_l - t$mod_r,
      dv = t$dv_l - t$dv_r
    ))
  }
}
