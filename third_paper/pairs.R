library(tidyverse)

# load data --------------------------------------------------------------------
source("data.R")

# create a pairs table
test_participants <- unique(df_pairs$id_test)

df_pairs_summary <- NULL
for (tp in test_participants) {
    df_tp <- df_pairs %>%
        filter(id_test == tp)

    df_pairs_summary <- rbind(
        df_pairs_summary,
        data.frame(
            test = tp,
            control = paste(df_tp$id_control, collapse = ", ")
        )
    )
}

# save to pairs_summary.csv
write.table(
    df_pairs_summary,
    file = "pairs_summary.csv",
    sep = ",",
    row.names = FALSE
)
