# libraries
library(cmdstanr)
library(ggplot2)
library(ggdist)
library(cowplot)
library(bayesplot)
library(posterior)
library(tidyverse)
library(mcmcse)


# load PED data ----------------------------------------------------------------
df <- read.csv('../../csv/metrics.csv')
colnames(df) <- c('ID', 'cp', 'ge', 'cc', 'sw')

df_freq <- read.csv('../../csv/metrics_freq.csv')
colnames(df_freq) <- c('ID', 'psd', 'ap_naive', 'ap')

df_nihs <- read.csv('../../csv/metrics_inter.csv')
colnames(df_nihs) <- c('ID', 'nihs', 'total_ihs', 'mean_ihs', 'max_ihs')

# add age
df_age <- read.csv('../../csv/demographics.csv')
df_age <- df_age %>% select(ID, Age, Sex)
df <- df %>% left_join(df_age)
df <- df %>% left_join(df_freq)
df <- df %>% left_join(df_nihs)


# OR load EEG dataset ----------------------------------------------------------
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


# compile the model ------------------------------------------------------------
model <- cmdstan_model("linear_robust.stan")


# characteristic path ----------------------------------------------------------
# prep the data
stan_data <- list(n=nrow(df), x=df$Age, y=df$cp)

# fit
fit_cp <- model$sample(
  data = stan_data,
  parallel_chains = 4
)

# traceplot
mcmc_trace(fit_cp$draws())

# summary
fit_cp$summary()

# extract
df_cp <- as_draws_df(fit_cp$draws())
mcse(df_cp$b > 0)

# plot
df_plot = tibble(
    .draw = df_cp$.draw,
    intercept = df_cp$a,
    slope = df_cp$b,
    x = list(5:18),
    y = map2(intercept, slope, ~ .x + .y * 5:18)
)
df_plot <- df_plot %>% unnest(c(x, y))

p1 <- ggplot(data=df_plot, aes(x = x, y = y)) +
  stat_lineribbon(.width = c(.95), alpha = 0.5, size = 1) +
  geom_point(data = df, aes(x = Age, y = cp), color = "grey25", alpha = 0.5, shape = 16) +
  scale_fill_manual(values = c("grey75")) +
  ggtitle("Characteristic path") +
  xlab("Age") +
  ylab("Value") +
  theme(legend.position = "none")


# global efficiency coefficient ------------------------------------------------
# prep the data
stan_data <- list(n=nrow(df), x=df$Age, y=df$ge)

# fit
fit_ge <- model$sample(
  data = stan_data,
  parallel_chains = 4
)

# traceplot
mcmc_trace(fit_ge$draws())

# summary
fit_ge$summary()

# extract
df_ge <- as_draws_df(fit_ge$draws())
mcse(df_ge$b > 0)

# plot
df_plot = tibble(
  .draw = df_ge$.draw,
  intercept = df_ge$a,
  slope = df_ge$b,
  x = list(5:18),
  y = map2(intercept, slope, ~ .x + .y * 5:18)
)
df_plot <- df_plot %>% unnest(c(x, y))

p2 <- ggplot(data=df_plot, aes(x = x, y = y)) +
  stat_lineribbon(.width = c(.95), alpha = 0.5, size = 1) +
  geom_point(data = df, aes(x = Age, y = ge), color = "grey25", alpha = 0.5, shape = 16) +
  scale_fill_manual(values = c("grey75")) +
  ggtitle("Global efficiency") +
  xlab("Age") +
  ylab("Value") +
  theme(legend.position = "none")


# clustering coefficient -------------------------------------------------------
# prep the data
stan_data <- list(n=nrow(df), x=df$Age, y=df$cc)

# fit
fit_cc <- model$sample(
  data = stan_data,
  parallel_chains = 4
)

# traceplot
mcmc_trace(fit_cc$draws())

# summary
fit_cc$summary()

# extract
df_cc <- as_draws_df(fit_cc$draws())
mcse(df_cc$b > 0)

# plot
df_plot = tibble(
  .draw = df_cc$.draw,
  intercept = df_cc$a,
  slope = df_cc$b,
  x = list(5:18),
  y = map2(intercept, slope, ~ .x + .y * 5:18)
)
df_plot <- df_plot %>% unnest(c(x, y))

p3 <- ggplot(data=df_plot, aes(x = x, y = y)) +
  stat_lineribbon(.width = c(.95), alpha = 0.5, size = 1) +
  geom_point(data = df, aes(x = Age, y = cc), color = "grey25", alpha = 0.5, shape = 16) +
  scale_fill_manual(values = c("grey75")) +
  ggtitle("Clustering coefficient") +
  xlab("Age") +
  ylab("Value") +
  theme(legend.position = "none")


# small worldness --------------------------------------------------------------
# prep the data
stan_data <- list(n=nrow(df), x=df$Age, y=df$sw)

# fit
fit_sw <- model$sample(
  data = stan_data,
  parallel_chains = 4
)

# traceplot
mcmc_trace(fit_sw$draws())

# summary
fit_sw$summary()

# extract
df_sw <- as_draws_df(fit_sw$draws())
mcse(df_sw$b > 0)

# plot
df_plot = tibble(
  .draw = df_sw$.draw,
  intercept = df_sw$a,
  slope = df_sw$b,
  x = list(5:18),
  y = map2(intercept, slope, ~ .x + .y * 5:18)
)
df_plot <- df_plot %>% unnest(c(x, y))

p4 <- ggplot(data=df_plot, aes(x = x, y = y)) +
  stat_lineribbon(.width = c(.95), alpha = 0.5, size = 1) +
  geom_point(data = df, aes(x = Age, y = sw), color = "grey25", alpha = 0.5, shape = 16) +
  scale_fill_manual(values = c("grey75")) +
  ggtitle("Small worldness") +
  xlab("Age") +
  ylab("Value") +
  theme(legend.position = "none")


# alpha peak -------------------------------------------------------------------
# prep the data
df_ap_plot <- df %>% filter(ap != -1)
stan_data <- list(n=nrow(df_ap_plot), x=df_ap_plot$Age, y=df_ap_plot$ap)

# fit
fit_ap <- model$sample(
  data = stan_data,
  parallel_chains = 4
)

# traceplot
mcmc_trace(fit_ap$draws())

# summary
fit_ap$summary()

# extract
df_ap <- as_draws_df(fit_ap$draws())
mcse(df_ap$b > 0)

# plot
df_plot = tibble(
  .draw = df_ap$.draw,
  intercept = df_ap$a,
  slope = df_ap$b,
  x = list(5:18),
  y = map2(intercept, slope, ~ .x + .y * 5:18)
)
df_plot <- df_plot %>% unnest(c(x, y))

# df_ap_plot
p5 <- ggplot(data=df_plot, aes(x = x, y = y)) +
  stat_lineribbon(.width = c(.95), alpha = 0.5, size = 1) +
  geom_point(data = df_ap_plot, aes(x = Age, y = ap), color = "grey25", alpha = 0.5, shape = 16) +
  scale_fill_manual(values = c("grey75")) +
  ggtitle("Individual alpha frequency") +
  xlab("Age") +
  ylab("Value") +
  theme(legend.position = "none")

# mcse
df_5 <- df_plot %>% filter(x == 5)
mcse(df_5$y)
quantile(df_5$y, probs = c(0.025, 0.975))

df_18 <- df_plot %>% filter(x == 18)
mcse(df_18$y)
quantile(df_18$y, probs = c(0.025, 0.975))


# interhemispheric strength ----------------------------------------------------
# prep the data
stan_data <- list(n=nrow(df), x=df$Age, y=df$total_ihs)

# fit
fit_tihs <- model$sample(
  data = stan_data,
  parallel_chains = 4
)

# traceplot
mcmc_trace(fit_tihs$draws())

# summary
fit_tihs$summary()

# extract
df_tihs <- as_draws_df(fit_tihs$draws())
mcse(df_tihs$b > 0)

# plot
df_plot = tibble(
  .draw = df_tihs$.draw,
  intercept = df_tihs$a,
  slope = df_tihs$b,
  x = list(5:18),
  y = map2(intercept, slope, ~ .x + .y * 5:18)
)
df_plot <- df_plot %>% unnest(c(x, y))

p6 <- ggplot(data=df_plot, aes(x = x, y = y)) +
  stat_lineribbon(.width = c(.95), alpha = 0.5, size = 1) +
  geom_point(data = df, aes(x = Age, y = total_ihs), color = "grey25", alpha = 0.5, shape = 16) +
  scale_fill_manual(values = c("grey75")) +
  ggtitle("Interhemispheric strength") +
  xlab("Age") +
  ylab("Value") +
  theme(legend.position = "none")


# plot -------------------------------------------------------------------------
plot_grid(p1, p2, p3, p4, p5, p6, scale = 0.95)