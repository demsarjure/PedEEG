# libraries
library(ggplot2)
library(ggdist)
library(tidyverse)

# load the data ----------------------------------------------------------------
band <- "alpha"
source("data_test.R")
df_test <- df
source("data_validation.R")
df_validation <- df

# plot age/sex distributions ---------------------------------------------------
df_age_test <- df_test %>% select(age, sex)
df_age_test$dataset <- "test"
df_age_validation <- df_validation %>% select(age, sex)
df_age_validation$dataset <- "validation"
df_age <- add_row(df_age_test, df_age_validation)

# age to factor
df_age <- df_age %>%
  mutate(sex = replace(sex, sex == 1, "male")) %>%
  mutate(sex = replace(sex, sex == 2, "female"))

ggplot(df_age, aes(x = age, color = sex, fill = sex)) +
  geom_density(size = 1, alpha = 0.25) +
  facet_grid(dataset ~ .) +
  scale_color_brewer(type = "qual", palette = 1) +
  scale_fill_brewer(type = "qual", palette = 1) +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  xlim(5, 18)

ggsave(paste0("figs/sex_distributions.png"),
        width = 3840,
        height = 1920,
        dpi = 500,
        units = "px",
        bg = "white")

# summary
summary(filter(df_age, dataset == "test"))
summary(filter(df_age, sex == "male" & dataset == "test"))
summary(filter(df_age, sex == "female" & dataset == "test"))
summary(filter(df_age, sex == "male" & dataset == "validation"))
summary(filter(df_age, sex == "female" & dataset == "validation"))
