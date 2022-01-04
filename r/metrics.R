# libraries
library(ggplot2)
library(tidyverse)

# load PED data ----------------------------------------------------------------
df <- read.csv('../../csv/metrics.csv')
colnames(df) <- c('ID', 'cp', 'ge', 'cc')

# add age
df_age <- read.csv('../../csv/demographics.csv')
df_age <- df_age %>% select(ID, Age, Sex)
df <- df %>% left_join(df_age)


# OR load EEG dataset-----------------------------------------------------------
df <- read.csv('../../dataset/csv/metrics.csv')
colnames(df) <- c('ID', 'cp', 'mod')

# add age
df_age <- read.csv('../../dataset/MIPDB_PublicFile.csv')
df_age <- df_age %>% select(ID, Age, Sex)
df <- df %>% left_join(df_age)


# to long ----------------------------------------------------------------------
df <- df %>% pivot_longer(cols = cp:cc)

# plot
ggplot(df, aes(x=Age, y=value)) +
  geom_point() +
  geom_smooth(method="lm") +
  facet_grid(name ~ ., scales="free_y")
