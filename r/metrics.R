# libraries
library(ggplot2)
library(tidyverse)

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
Adf_age <- df_age %>% select(ID, Age, Sex)
df <- df %>% left_join(df_age)
df <- df %>% left_join(df_freq)
df <- df %>% left_join(df_nihs)


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

# nihs
ggplot(df, aes(x=Age, y=nihs)) +
  geom_point() +
  geom_smooth(method="lm")

# total ihs
ggplot(df, aes(x=Age, y=total_ihs)) +
  geom_point() +
  geom_smooth(method="lm")

# mean ihs
ggplot(df, aes(x=Age, y=mean_ihs)) +
  geom_point() +
  geom_smooth(method="lm")

# max ihs
ggplot(df, aes(x=Age, y=max_ihs)) +
  geom_point() +
  geom_smooth(method="lm")

