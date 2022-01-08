# libraries
library(ggplot2)
library(tidyverse)

# load PED data ----------------------------------------------------------------
df <- read.csv('../../csv/metrics.csv')
colnames(df) <- c('ID', 'cp', 'ge', 'cc', 'mod', 'sw')

df_freq <- read.csv('../../csv/metrics_freq.csv')
colnames(df_freq) <- c('ID', 'psd', 'ap_naive', 'ap')

# add age
df_age <- read.csv('../../csv/demographics.csv')
df_age <- df_age %>% select(ID, Age, Sex)
df <- df %>% left_join(df_age)
df <- df %>% left_join(df_freq)


# OR load EEG dataset-----------------------------------------------------------
df <- read.csv('../../dataset/csv/metrics.csv')
colnames(df) <- c('ID', 'cp', 'ge', 'cc', 'mod', 'sw')

df_freq <- read.csv('../../dataset/csv/metrics_freq.csv')
colnames(df_freq) <- c('ID', 'psd', 'ap_naive', 'ap')

# add age
df_age <- read.csv('../../dataset/MIPDB_PublicFile.csv')
df_age <- df_age %>% select(ID, Age, Sex)
df <- df %>% left_join(df_age)
df <- df %>% left_join(df_freq)

# plot -------------------------------------------------------------------------

# cp
ggplot(df, aes(x=Age, y=cp)) +
  geom_point() +
  geom_smooth(method="lm")

# ge
ggplot(df, aes(x=Age, y=ge)) +
  geom_point() +
  geom_smooth(method="lm")

# cc
ggplot(df, aes(x=Age, y=cc)) +
  geom_point() +
  geom_smooth(method="lm")

# mod
ggplot(df, aes(x=Age, y=mod)) +
  geom_point() +
  geom_smooth(method="lm")

# sw
ggplot(df, aes(x=Age, y=sw)) +
  geom_point() +
  geom_smooth(method="lm")

# psd
ggplot(df, aes(x=Age, y=psd)) +
  geom_point() +
  geom_smooth(method="lm")

# ap
df_ap <- df %>% filter(ap != -1)
ggplot(df_ap, aes(x=Age, y=ap)) +
  geom_point() +
  geom_smooth(method="lm")
