# libraries
library(cmdstanr)
library(ggplot2)
library(ggdist)
library(bayesplot)
library(posterior)
library(tidyverse)
library(mcmcse)


# load EEG dataset ----------------------------------------------------------
df <- read.csv('../../dataset/csv/metrics.csv')
colnames(df) <- c('ID', 'cp', 'ge', 'cc', 'sw')

df_freq <- read.csv('../../dataset/csv/metrics_freq.csv')
colnames(df_freq) <- c('ID', 'psd', 'ap_naive', 'ap')

df_nihs <- read.csv('../../dataset/csv/metrics_inter.csv')
colnames(df_nihs) <- c('ID', 'nihs', 'total_ihs', 'mean_ihs', 'max_ihs')

# add age
df_age <- read.csv('../../dataset/MIPDB_PublicFile.csv')
df_age <- df_age %>% select(ID, Age, Sex)
df <- df %>% left_join(df_age)
df <- df %>% left_join(df_freq)
df <- df %>% left_join(df_nihs)


# split into male and female ---------------------------------------------------
df_m <- df %>% filter(Sex == 1)
df_f <- df %>% filter(Sex == 2)


# compile the model ------------------------------------------------------------
model <- cmdstan_model("normal.stan")


# characteristic path ----------------------------------------------------------
# prep the data
stan_data_m <- list(n=nrow(df_m), y=df_m$cp)
stan_data_f <- list(n=nrow(df_f), y=df_f$cp)

# fit male
fit_cp_m <- model$sample(
  data = stan_data_m,
  parallel_chains = 4,
  seed = 1
)

# traceplot
mcmc_trace(fit_cp_m$draws())

# summary
fit_cp_m$summary()

# extract
df_cp_m <- as_draws_df(fit_cp_m$draws())

# fit
fit_cp_f <- model$sample(
  data = stan_data_f,
  parallel_chains = 4,
  seed = 1
)

# traceplot
mcmc_trace(fit_cp_f$draws())

# summary
fit_cp_f$summary()

# extract
df_cp_f <- as_draws_df(fit_cp_f$draws())

# compare
mcse(df_cp_m$mu > df_cp_f$mu)
mcse(df_cp_f$mu > df_cp_m$mu)

# merge
df_stats <- data.frame(Value = df_cp_m$mu,
                       Sex = "M",
                       Metric = "Characteristic path")

df_stats <- df_stats %>%
  add_row(data.frame(Value = df_cp_f$mu,
                     Sex = "F",
                     Metric = "Characteristic path"))


# global efficiency ------------------------------------------------------------
# prep the data
stan_data_m <- list(n=nrow(df_m), y=df_m$ge)
stan_data_f <- list(n=nrow(df_f), y=df_f$ge)

# fit male
fit_ge_m <- model$sample(
  data = stan_data_m,
  parallel_chains = 4,
  seed = 1
)

# traceplot
mcmc_trace(fit_ge_m$draws())

# summary
fit_ge_m$summary()

# extract
df_ge_m <- as_draws_df(fit_ge_m$draws())

# fit
fit_ge_f <- model$sample(
  data = stan_data_f,
  parallel_chains = 4,
  seed = 1
)

# traceplot
mcmc_trace(fit_ge_f$draws())

# summary
fit_ge_f$summary()

# extract
df_ge_f <- as_draws_df(fit_ge_f$draws())

# compare
mcse(df_ge_m$mu > df_ge_f$mu)
mcse(df_ge_f$mu > df_ge_m$mu)

# merge
df_stats <- df_stats %>%
  add_row(data.frame(Value = df_ge_m$mu,
                     Sex = "M",
                     Metric = "Global efficiency"))

df_stats <- df_stats %>%
  add_row(data.frame(Value = df_ge_f$mu,
                     Sex = "F",
                     Metric = "Global efficiency"))


# clustering coefficient -------------------------------------------------------
# prep the data
stan_data_m <- list(n=nrow(df_m), y=df_m$cc)
stan_data_f <- list(n=nrow(df_f), y=df_f$cc)

# fit male
fit_cc_m <- model$sample(
  data = stan_data_m,
  parallel_chains = 4,
  seed = 1
)

# traceplot
mcmc_trace(fit_cc_m$draws())

# summary
fit_cc_m$summary()

# extract
df_cc_m <- as_draws_df(fit_cc_m$draws())

# fit
fit_cc_f <- model$sample(
  data = stan_data_f,
  parallel_chains = 4,
  seed = 1
)

# traceplot
mcmc_trace(fit_cc_f$draws())

# summary
fit_cc_f$summary()

# extract
df_cc_f <- as_draws_df(fit_cc_f$draws())

# compare
mcse(df_cc_m$mu > df_cc_f$mu)
mcse(df_cc_f$mu > df_cc_m$mu)

# merge
df_stats <- df_stats %>%
  add_row(data.frame(Value = df_cc_m$mu,
                     Sex = "M",
                     Metric = "Clustering coefficient"))

df_stats <- df_stats %>%
  add_row(data.frame(Value = df_cc_f$mu,
                     Sex = "F",
                     Metric = "Clustering coefficient"))


# small worldness --------------------------------------------------------------
# prep the data
stan_data_m <- list(n=nrow(df_m), y=df_m$sw)
stan_data_f <- list(n=nrow(df_f), y=df_f$sw)

# fit male
fit_sw_m <- model$sample(
  data = stan_data_m,
  parallel_chains = 4,
  seed = 1
)

# traceplot
mcmc_trace(fit_sw_m$draws())

# summary
fit_sw_m$summary()

# extract
df_sw_m <- as_draws_df(fit_sw_m$draws())

# fit
fit_sw_f <- model$sample(
  data = stan_data_f,
  parallel_chains = 4,
  seed = 1
)

# traceplot
mcmc_trace(fit_sw_f$draws())

# summary
fit_sw_f$summary()

# extract
df_sw_f <- as_draws_df(fit_sw_f$draws())

# compare
mcse(df_sw_m$mu > df_sw_f$mu)
mcse(df_sw_f$mu > df_sw_m$mu)

# merge
df_stats <- df_stats %>%
  add_row(data.frame(Value = df_sw_m$mu,
                     Sex = "M",
                     Metric = "Small worldness"))

df_stats <- df_stats %>%
  add_row(data.frame(Value = df_sw_f$mu,
                     Sex = "F",
                     Metric = "Small worldness"))


# alpha peak -------------------------------------------------------------------
# prep the data
df_ap_filter_m <- df_m %>% filter(df_m != -1)
df_ap_filter_f <- df_f %>% filter(df_f != -1)
stan_data_m <- list(n=nrow(df_ap_filter_m), y=df_ap_filter_m$ap)
stan_data_f <- list(n=nrow(df_ap_filter_f), y=df_ap_filter_f$ap)

# fit male
fit_ap_m <- model$sample(
  data = stan_data_m,
  parallel_chains = 4,
  seed = 1
)

# traceplot
mcmc_trace(fit_ap_m$draws())

# summary
fit_ap_m$summary()

# extract
df_ap_m <- as_draws_df(fit_ap_m$draws())

# fit
fit_ap_f <- model$sample(
  data = stan_data_f,
  parallel_chains = 4,
  seed = 1
)

# traceplot
mcmc_trace(fit_ap_f$draws())

# summary
fit_ap_f$summary()

# extract
df_ap_f <- as_draws_df(fit_ap_f$draws())

# compare
mcse(df_ap_m$mu > df_ap_f$mu)
mcse(df_ap_f$mu > df_ap_m$mu)

# merge
df_stats <- df_stats %>%
  add_row(data.frame(Value = df_ap_m$mu,
                     Sex = "M",
                     Metric = "Individual alpha frequency"))

df_stats <- df_stats %>%
  add_row(data.frame(Value = df_ap_f$mu,
                     Sex = "F",
                     Metric = "Individual alpha frequency"))


# interhemispheric strength ----------------------------------------------------
# prep the data
stan_data_m <- list(n=nrow(df_m), y=df_m$total_ihs)
stan_data_f <- list(n=nrow(df_f), y=df_f$total_ihs)

# fit male
fit_tihs_m <- model$sample(
  data = stan_data_m,
  parallel_chains = 4,
  seed = 1
)

# traceplot
mcmc_trace(fit_tihs_m$draws())

# summary
fit_tihs_m$summary()

# extract
df_tihs_m <- as_draws_df(fit_tihs_m$draws())

# fit
fit_tihs_f <- model$sample(
  data = stan_data_f,
  parallel_chains = 4,
  seed = 1
)

# traceplot
mcmc_trace(fit_tihs_f$draws())

# summary
fit_tihs_f$summary()

# extract
df_tihs_f <- as_draws_df(fit_tihs_f$draws())

# compare
mcse(df_tihs_m$mu > df_tihs_f$mu)
mcse(df_tihs_f$mu > df_tihs_m$mu)

# merge
df_stats <- df_stats %>%
  add_row(data.frame(Value = df_tihs_m$mu,
                     Sex = "M",
                     Metric = "Interhemispheric strength"))

df_stats <- df_stats %>%
  add_row(data.frame(Value = df_tihs_f$mu,
                     Sex = "F",
                     Metric = "Interhemispheric strength"))


# plot -------------------------------------------------------------------------
# factors
df_stats$Metric <- as.factor(df_stats$Metric)
levels(df_stats$Metric) <- c("Characteristic path", "Global efficiency", "Clustering coefficient", "Small worldness", "Individual alpha frequency", "Interhemispheric strength")

ggplot(data = df_stats, aes(x = Value, y = Sex)) +
  stat_pointinterval(fill="skyblue", alpha = 0.75, .width = c(.5, .95)) +
  facet_wrap(. ~ Metric, scales = "free", ncol = 3) +
  theme(panel.spacing = unit(2, "lines"))
