# load EEG dataset -------------------------------------------------------------
dataset <- "dataset"

# metrics
df <- read.csv(paste0("../data/dataset/metrics_", band, ".csv"))
colnames(df) <- c("id", "cp", "ge", "cc", "sw")

# inter-hemispheric metrics
df_ihs <- read.csv(paste0("../data/dataset/metrics_inter_", band, ".csv"))
colnames(df_ihs) <- c("id", "nihs", "tihs")
df <- df %>% left_join(df_ihs)

# frequency metrics only for alfa
if (band == "alpha") {
  df_freq <- read.csv(paste0("../data/dataset/metrics_freq.csv"))
  colnames(df_freq) <- c("id", "ap")
  df <- df %>% left_join(df_freq)
}

# add age
df_age <- read.csv("../../dataset/MIPDB_PublicFile.csv")
df_age <- df_age %>% select(ID, Age, Sex)
colnames(df_age) <- c("id", "age", "sex")
df <- df %>% left_join(df_age)

# drop nas
df <- df %>% drop_na()
