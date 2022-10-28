# libraries
library(cowplot)
library(ggplot2)
library(tidyverse)

# set datasets and bands
datasets <- c("test", "validation")
bands <- c("theta", "alpha", "beta")

# plots storages
plots <- NULL
df_thresholds <- data.frame(band = character(),
                            dataset = character(),
                            min_fc = numeric())
df_thresholds_all <- data.frame(band = character(),
                                dataset = character(),
                                fc = numeric())

# iterate over all
iteration <- 1
for (dataset in datasets) {
  for (band in bands) {
    # get csvs
    csvs <- list.files(path = paste0("../data/", dataset, "/fc_csv"),
                      pattern = band)

    # concatenate all fc data
    df <- data.frame(fc = numeric())
    n_csvs <- length(csvs)
    i_csv <- 1
    for (csv in csvs) {
      cat(paste0("\nProcessing ", csv, " [", i_csv, "/", n_csvs, "]"))
      i_csv <- i_csv + 1

      df_fc <- read.csv(paste0("../data/", dataset, "/fc_csv/", csv),
                              header = FALSE)

      n <- nrow(df_fc)
      for (i in 1:(n - 1)) {
        df_current <- data.frame(fc = as.numeric(df_fc[i, (i + 1) : n]))
        df <- df %>% add_row(df_current)
      }
    }

    # get max density and max value
    fc_seq <- seq(0, 1, by = 0.001)
    fc_hist <- hist(df$fc, breaks = fc_seq, plot = FALSE)
    min_fc <- fc_hist$breaks[which.max(fc_hist$counts)]

    # store
    df_thresholds <- df_thresholds %>%
      add_row(data.frame(band = band,
                         dataset = dataset,
                         min_fc = min_fc))

    df_thresholds_all <- df_thresholds_all %>%
      add_row(data.frame(band = band,
                         dataset = dataset,
                         fc = df$fc))

    iteration <- iteration + 1
  }
}

# store thresholds
write.table(df_thresholds, file = "../data/threshold.csv",
            sep = ",", row.names = FALSE)

# plot
ggplot(df_thresholds_all, aes(x = fc)) +
  geom_density(color = NA, fill = "grey50") +
  geom_vline(data = df_thresholds, aes(xintercept = min_fc),
             size = 1, linetype = "dashed") +
  xlim(0, 1) +
  facet_grid(dataset ~ band)
