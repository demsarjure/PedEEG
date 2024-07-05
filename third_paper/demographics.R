library(tidyverse)
library(cowplot)
library(bayesplot)
library(cmdstanr)
library(mcmcse)
library(posterior)

# load and prep the data -------------------------------------------------------
# source data
source("data.R")

# load demographics
df_demo_control <- read.csv("../data/test/demographics_control.csv")
df_demo_test <- read.csv("../data/test/demographics_test.csv")

# load education
df_education <- read.csv("../data/test/education.csv")

# filter
df_demo_control <- df_demo_control %>%
  filter(id %in% control_ids)
df_demo_control$group <- "Control"

df_demo_test <- df_demo_test %>%
    filter(id %in% test_ids)
df_demo_test$group <- "Stroke"

# merge
df_demo <- rbind(df_demo_control, df_demo_test)

# add education
df_demo <- df_demo %>%
  left_join(df_education, by = "id")

# sec 1 is female, 0 is male
sum(df_demo_control$sex == 0)
sum(df_demo_control$sex == 1)

sum(df_demo_test$sex == 0)
sum(df_demo_test$sex == 1)

# df_demo to long
df_demo_long <- df_demo %>%
  pivot_longer(cols = c(age, sex, education))

# education as factors
# 1 - Elementary/Osnovna
# 2 - Vocational/Poklicna
# 3 - High/Srednja
# 4 - Professional/Visoka
# 5 - BSc or MSc/Univerzitetna ali magisterij
# 6 - PhD/Doktorat
# english plot
df_demo$education <- factor(df_demo$education, levels = c(1, 2, 3, 4, 5, 6),
                            labels = c("Elementary", "Vocational", "High", "Professional", "BSc or MSc", "PhD"))
df_education <- df_demo %>% drop_na()

# plot age/sex distributions ---------------------------------------------------
# english plot
df_demo$Sex <- df_demo$sex
df_demo <- df_demo %>%
  mutate(Sex = replace(Sex, Sex == 0, "Male")) %>%
  mutate(Sex = replace(Sex, Sex == 1, "Female"))
df_demo$Group <- df_demo$group

p1 <- ggplot(df_demo, aes(x = age, color = Group, fill = Group)) +
  geom_density(linewidth = 1, alpha = 0.25) +
  scale_color_brewer(type = "qual", palette = 1) +
  scale_fill_brewer(type = "qual", palette = 1) +
  xlim(5, 18) +
  facet_grid(. ~ Sex) +
  ylab("Density") +
  xlab("Age (years)")

# slovenian plot
df_demo_si <- df_demo
df_demo_si$Spol <- df_demo_si$Sex
df_demo_si <- df_demo_si %>%
  mutate(Spol = replace(Spol, Spol == "Male", "Moški spol")) %>%
  mutate(Spol = replace(Spol, Spol == "Female", "Ženski spol"))
df_demo_si$Spol <- factor(df_demo_si$Spol , levels = c("Ženski spol", "Moški spol"))
df_demo_si$Skupina <- df_demo_si$group
df_demo_si <- df_demo_si %>%
  mutate(Skupina = replace(Skupina, Skupina == "Control", "Kontrolna skupina")) %>%
  mutate(Skupina = replace(Skupina, Skupina == "Stroke", "Perinatalna kap"))
df_demo_si$Skupina <- factor(df_demo_si$Skupina , levels = c("Kontrolna skupina", "Perinatalna kap"))

p1_si <- ggplot(df_demo_si, aes(x = age, color = Skupina, fill = Skupina)) +
  geom_density(linewidth = 1, alpha = 0.25) +
  scale_color_brewer(type = "qual", palette = 1) +
  scale_fill_brewer(type = "qual", palette = 1) +
  xlim(5, 18) +
  facet_grid(. ~ Spol) +
  ylab("Gostota") +
  xlab("Starost")

p2 <- ggplot(df_education, aes(x = education)) +
  geom_histogram(stat = "count") +
  scale_color_brewer(type = "qual", palette = 1) +
  scale_fill_brewer(type = "qual", palette = 1) +
  facet_grid(. ~ group) +
  ylab("Count") +
  xlab("Education")

# slovenian plot
df_education_si <- df_education
df_education_si$Skupina <- df_education_si$group
df_education_si <- df_education_si %>%
  mutate(Skupina = replace(Skupina, Skupina == "Control", "Kontrolna skupina")) %>%
  mutate(Skupina = replace(Skupina, Skupina == "Stroke", "Perinatalna kap"))
df_education_si$Izobrazba <- df_education_si$education
mapping <- c("Elementary" = "Osnovna",
             "Vocational" = "Poklicna",
             "High" = "Srednja",
             "Professional" = "VSŠ",
             "BSc or MSc" = "UNI/MAG",
             "PhD" = "Doktorat")
df_education_si <- df_education_si %>%
  mutate(Izobrazba = recode(Izobrazba, !!!mapping))

p2_si <- ggplot(df_education_si, aes(x = Izobrazba)) +
  geom_histogram(stat = "count") +
  scale_color_brewer(type = "qual", palette = 1) +
  scale_fill_brewer(type = "qual", palette = 1) +
  facet_grid(. ~ Skupina) +
  ylab("Število")

# english plot
plot_grid(p1, p2, labels = "AUTO", ncol = 1, align = "v", scale = 0.95)

ggsave(paste0("figs/demographics.png"),
        width = 1920,
        height = 1080,
        dpi = 150,
        units = "px",
        bg = "white")

# slovenian plot
plot_grid(p1_si, p2_si, labels = "AUTO", ncol = 1, align = "v", scale = 0.95)

ggsave(paste0("figs/demographics_si.png"),
        width = 1920,
        height = 1080,
        dpi = 150,
        units = "px",
        bg = "white")

# analysis ---------------------------------------------------------------------
# age
model <- cmdstan_model("./models/poisson.stan")

# control
stan_data <- list(
  n = length(df_demo_control$age),
  y = df_demo_control$age
)
fit_control <- model$sample(
  data = stan_data,
  parallel_chains = 4
)
mcmc_trace(fit_control$draws())
fit_control$summary()

# test
stan_data <- list(
  n = length(df_demo_test$age),
  y = df_demo_test$age
)
fit_test <- model$sample(
  data = stan_data,
  parallel_chains = 4
)
mcmc_trace(fit_test$draws())
fit_test$summary()

df_samples_control <- as_draws_df(fit_control$draws())
df_samples_test <- as_draws_df(fit_test$draws())

mcse(df_samples_control$lambda > df_samples_test$lambda)

# education
df_education$education_numeric <- as.numeric(df_education$education)
df_education_control <- df_education %>%
  filter(group == "Control")
df_education_test <- df_education %>%
  filter(group == "Stroke")

# control
stan_data <- list(
  n = length(df_education_control$education_numeric),
  y = df_education_control$education_numeric
)
fit_control <- model$sample(
  data = stan_data,
  parallel_chains = 4
)
mcmc_trace(fit_control$draws())
fit_control$summary()

# test
stan_data <- list(
  n = length(df_education_test$education_numeric),
  y = df_education_test$education_numeric
)
fit_test <- model$sample(
  data = stan_data,
  parallel_chains = 4
)
mcmc_trace(fit_test$draws())
fit_test$summary()

df_samples_control <- as_draws_df(fit_control$draws())
df_samples_test <- as_draws_df(fit_test$draws())

mcse(df_samples_control$lambda > df_samples_test$lambda)
