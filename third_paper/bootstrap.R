# bootstrapping test to see robustness of our methodlogy -----------------------

# load data and models ---------------------------------------------------------
source("./utils/normal.R")
source("data.R")

# repeat 100 times for each metric
n <- 100
n_data <- nrow(df_diff)

# set var
var <- "iq"

# results storage --------------------------------------------------------------
df_results <- NULL
robust <- TRUE

for (i in seq_len(n)) {
    df_sub <- sample(df_diff, n_data, replace = TRUE)

    diff <- df_sub[[var]]

    fit_diff <- fit_normal(diff, robust = robust)
    results <- compare_normal(
        fit = fit_diff, label1 = "control", label2 = "test"
    )
    df_results <- rbind(
        df_results,
        data.frame(
            variable = var,
            c_bigger = results$bigger_prob,
            c_bigger_se = results$bigger_se,
            c_smaller = results$smaller_prob,
            c_smaller_se = results$smaller_se
        )
    )
}

df_results
