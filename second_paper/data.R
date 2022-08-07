# helper function for loading data

# load all data ----------------------------------------------------------------
columns_metrics <- c("ID", "cp", "ge", "cc", "sw", "bc")
columns_freq <- c("ID", "psd", "ap_naive", "ap")
columns_inter <- c("ID", "normalized_ihs", "total_ihs",
                   "cp_l", "ge_l", "cc_l", "sw_l", "bc_l",
                   "cp_r", "ge_r", "cc_r", "sw_r", "bc_r")

df_control <- read.csv("../data/ped/metrics_laplace.csv")
colnames(df_control) <- columns_metrics

df_control_freq <- read.csv("../data/ped/metrics_freq_laplace.csv")
colnames(df_control_freq) <- columns_freq

df_control_inter <- read.csv("../data/ped/metrics_inter_laplace.csv")
colnames(df_control_inter) <- columns_inter

df_control <- df_control %>%
  inner_join(df_control_freq) %>%
  inner_join(df_control_inter)

df_test <- read.csv("../data/ped/metrics_T_laplace.csv")
colnames(df_test) <- columns_metrics

df_test_freq <- read.csv("../data/ped/metrics_freq_T_laplace.csv")
colnames(df_test_freq) <- columns_freq

df_test_inter <- read.csv("../data/ped/metrics_inter_T_laplace.csv")
colnames(df_test_inter) <- columns_inter

df_test <- df_test %>%
  inner_join(df_test_freq) %>%
  inner_join(df_test_inter)

df_pairs <- read.csv("../data/ped/pairs_volumes.csv")

# compute global pairwise differences ------------------------------------------
df_diff <- data.frame(
  ID = character(),
  volume = numeric(),
  cp = numeric(),
  ge = numeric(),
  cc = numeric(),
  sw = numeric(),
  bc = numeric(),
  ap = numeric(),
  normalized_ihs = numeric(),
  total_ihs = numeric()
)

for (i in seq_len(nrow(df_pairs))) {
  p <- df_pairs[i, ]
  c <- df_control %>% filter(ID == p$control)
  t <- df_test %>% filter(ID == p$test)

  df_diff <- df_diff %>% add_row(data.frame(
    ID = t$ID,
    volume = p$volume,
    cp = c$cp - t$cp,
    ge = c$ge - t$ge,
    cc = c$cc - t$cc,
    sw = c$sw - t$sw,
    bc = c$bc - t$bc,
    ap = c$ap_naive - t$ap_naive,
    normalized_ihs = c$normalized_ihs - t$normalized_ihs,
    total_ihs = c$total_ihs - t$total_ihs
  ))
}

# compute inter-hemispheric pairwise differences -------------------------------
# _h means healthy
# _i means injured
df_diff_inter <- data.frame(
  ID = character(),
  volume = numeric(),
  cp_h = numeric(),
  cp_i = numeric(),
  ge_h = numeric(),
  ge_i = numeric(),
  cc_h = numeric(),
  cc_i = numeric(),
  sw_h = numeric(),
  sw_i = numeric(),
  bc_h = numeric(),
  bc_i = numeric()
)

for (i in seq_len(nrow(df_pairs))) {
  p <- df_pairs[i, ]
  c <- df_control %>% filter(ID == p$control)
  t <- df_test %>% filter(ID == p$test)

  # if the lesion was in the left hemisphere
  if (p$location == "l") {
    df_diff_inter <- df_diff_inter %>% add_row(data.frame(
      ID = t$ID,
      volume = p$volume,
      cp_h = c$cp_r - t$cp_r,
      cp_i = c$cp_l - t$cp_l,
      ge_h = c$ge_r - t$ge_r,
      ge_i = c$ge_l - t$ge_l,
      cc_h = c$cc_r - t$cc_r,
      cc_i = c$cc_l - t$cc_l,
      sw_h = c$sw_r - t$sw_r,
      sw_i = c$sw_l - t$sw_l,
      bc_h = c$bc_r - t$bc_r,
      bc_i = c$bc_l - t$bc_l
    ))
  }
  # if the lesion was in the right hemisphere
  else if (p$location == "r") {
    df_diff_inter <- df_diff_inter %>% add_row(data.frame(
      ID = t$ID,
      volume = p$volume,
      cp_h = c$cp_l - t$cp_l,
      cp_i = c$cp_r - t$cp_r,
      ge_h = c$ge_l - t$ge_l,
      ge_i = c$ge_r - t$ge_r,
      cc_h = c$cc_l - t$cc_l,
      cc_i = c$cc_r - t$cc_r,
      sw_h = c$sw_l - t$sw_l,
      sw_i = c$sw_r - t$sw_r,
      bc_h = c$bc_l - t$bc_l,
      bc_i = c$bc_r - t$bc_r
    ))
  }
}
