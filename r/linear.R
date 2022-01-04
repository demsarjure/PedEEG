# libraries
library(cmdstanr)
library(ggplot2)
library(bayesplot)
library(posterior)
library(tidyverse)
library(mcmcse)

# load PED data ----------------------------------------------------------------
df <- read.csv('../../csv/metrics.csv')
colnames(df) <- c('ID', 'cp', 'ge', 'cc')

# add age
df_age <- read.csv('../../csv/demographics.csv')
df_age <- df_age %>% select(ID, Age, Sex)
df <- df %>% left_join(df_age)


# OR load EEG dataset-----------------------------------------------------------
df <- read.csv('../../dataset/csv/metrics.csv')
colnames(df) <- c('ID', 'cp', 'ge', 'cc')

# add age
df_age <- read.csv('../../dataset/MIPDB_PublicFile.csv')
df_age <- df_age %>% select(ID, Age, Sex)
df <- df %>% left_join(df_age)


# compile the model ------------------------------------------------------------
#model <- cmdstan_model("linear.stan")
model <- cmdstan_model("linear_robust.stan")

# characteristic path ----------------------------------------------------------
# prep the data
stan_data <- list(n=nrow(df), x=df$Age, y=df$cp)

# fit
fit_cp <- model$sample(
  data = stan_data,
  parallel_chains = 4,
  seed = 1
)

# traceplot
mcmc_trace(fit_cp$draws())

# summary
fit_cp$summary()

# extract
df_cp <- as_draws_df(fit_cp$draws())
mcse(df_cp$b > 0)

# visualize data points and regression lines
# plot only 100 random regression lines
df_cp_100 <- data.frame(alpha=df_cp$a, beta=df_cp$b)
df_cp_100 <- sample_n(df_cp_100, 100)

# plot
ggplot() + 
  geom_point(data=df,
             aes(x=Age, y=cp),
             alpha=0.2, size=3, shape=16) +
  geom_abline(data = df_cp_100,
              aes(slope=beta, intercept=alpha),
              color="skyblue", alpha=0.2, size=1) +
  theme_minimal()


# global efficiency coefficient ------------------------------------------------
# prep the data
stan_data <- list(n=nrow(df), x=df$Age, y=df$ge)

# fit
fit_ge <- model$sample(
  data = stan_data,
  parallel_chains = 4,
  seed = 1
)

# traceplot
mcmc_trace(fit_ge$draws())

# summary
fit_ge$summary()

# extract
df_ge <- as_draws_df(fit_ge$draws())
mcse(df_ge$b > 0)

# visualize data points and regression lines
# plot only 100 random regression lines
df_ge_100 <- data.frame(alpha=df_ge$a, beta=df_ge$b)
df_ge_100 <- sample_n(df_ge_100, 100)

# plot
ggplot() + 
  geom_point(data=df,
             aes(x=Age, y=cp),
             alpha=0.2, size=3, shape=16) +
  geom_abline(data = df_ge_100,
              aes(slope=beta, intercept=alpha),
              color="skyblue", alpha=0.2, size=1) +
  theme_minimal()


# clustering coefficient -------------------------------------------------------
# prep the data
stan_data <- list(n=nrow(df), x=df$Age, y=df$cc)

# fit
fit_cc <- model$sample(
  data = stan_data,
  parallel_chains = 4,
  seed = 1
)

# traceplot
mcmc_trace(fit_cc$draws())

# summary
fit_cc$summary()

# extract
df_cc <- as_draws_df(fit_cc$draws())
mcse(df_cc$b > 0)

# visualize data points and regression lines
# plot only 100 random regression lines
df_cc_100 <- data.frame(alpha=df_cc$a, beta=df_cc$b)
df_cc_100 <- sample_n(df_cc_100, 100)

# plot
ggplot() + 
  geom_point(data=df,
             aes(x=Age, y=cp),
             alpha=0.2, size=3, shape=16) +
  geom_abline(data = df_cc_100,
              aes(slope=beta, intercept=alpha),
              color="skyblue", alpha=0.2, size=1) +
  theme_minimal()
