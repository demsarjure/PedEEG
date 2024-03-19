library(tidyverse)

# source data
source("data.R")
test_ids
control_ids

# load demographics
df_demo_control <- read.csv("../data/test/demographics_control.csv")
df_demo_test <- read.csv("../data/test/demographics_test.csv")

# filter
df_demo_control <- df_demo_control %>%
  filter(id %in% control_ids)

df_demo_test <- df_demo_test %>%
    filter(id %in% test_ids)

# sec 1 is female, 0 is male
sum(df_demo_control$sex == 0)
sum(df_demo_control$sex == 1)

sum(df_demo_test$sex == 0)
sum(df_demo_test$sex == 1)
