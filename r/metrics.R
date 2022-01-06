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
colnames(df) <- c('ID', 'cp', 'ge', 'cc')

df_freq <- read.csv('../../dataset/csv/metrics_freq.csv')
colnames(df_freq) <- c('ID', 'psd', 'ap_naive', 'ap')

# add age
df_age <- read.csv('../../dataset/MIPDB_PublicFile.csv')
df_age <- df_age %>% select(ID, Age, Sex)
df <- df %>% left_join(df_age)
df <- df %>% left_join(df_freq)

# plot -------------------------------------------------------------------------

# filter AP
df <- df %>% filter(ap != -1)

ggplot(df, aes(x=Age, y=ap)) +
  geom_jitter() +
  geom_smooth(method="lm")
