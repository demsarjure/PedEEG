# helper function for loading data
library(tidyverse)

# load data --------------------------------------------------------------------
df_demo_c <- read.csv("../data/test/demographics_control.csv")
df_demo_t <- read.csv("../data/test/demographics_test_volume.csv")

# pair controls and tests ------------------------------------------------------
n_t <- nrow(df_demo_t)
n_c <- nrow(df_demo_c)

df_pairs <- data.frame(id_test = character(),
                       id_control = character(),
                       age_diff = numeric())

max_diff <- 1

for (i in 1:n_t) {
  t <- df_demo_t[i, ]

  df_diff <- data.frame(id = character(), age_diff = numeric())
  for (j in 1:n_c) {
    c <- df_demo_c[j, ]

    # add only same sex
    if (c$sex == t$sex) {
      df_diff <- df_diff %>%
        add_row(data.frame(id = c$id, age_diff = abs(c$age - t$age)))
    }
  }

  df_match <- df_diff %>%
    filter(age_diff <= max_diff)

  df_pairs <- df_pairs %>%
    add_row(data.frame(id_test = t$id,
                       id_control = df_match$id,
                       age_diff = df_match$age_diff))
}

write.table(df_pairs,
            file = "../data/test/pairs.csv",
            row.names = FALSE,
            sep = ",")
