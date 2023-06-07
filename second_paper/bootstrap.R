# bootstrapping test to see robustness of our methodlogy -----------------------

# load data and models ---------------------------------------------------------
source("./utils/normal.R")
source("data.R")

# repeat 10 times for each metric
n <- 10
n_data <- nrow(df_diff)

# cp
for (i in seq_len(n)) {
    # subset 40 rows with replacemnt
    df_sub <- sample(df_diff, n_data, replace = TRUE)
    cp_fit <- fit_normal(df_sub$cp)
    compare_normal(cp_fit, label1 = "control", label2 = "test")
}

# cc
for (i in seq_len(n)) {
    # subset 40 rows with replacemnt
    df_sub <- sample(df_diff, n_data, replace = TRUE)
    cc_fit <- fit_normal(df_diff$cc)
    compare_normal(cc_fit, label1 = "control", label2 = "test")
}

# sw
for (i in seq_len(n)) {
    # subset 40 rows with replacemnt
    df_sub <- sample(df_diff, n_data, replace = TRUE)
    sw_fit <- fit_normal(df_diff$sw)
    compare_normal(sw_fit, label1 = "control", label2 = "test")
}

# mod
for (i in seq_len(n)) {
    # subset 40 rows with replacemnt
    df_sub <- sample(df_diff, n_data, replace = TRUE)
    mod_fit <- fit_normal(df_diff$mod)
    compare_normal(mod_fit, label1 = "control", label2 = "test")
}

# dv
for (i in seq_len(n)) {
    # subset 40 rows with replacemnt
    df_sub <- sample(df_diff, n_data, replace = TRUE)
    dv_fit <- fit_normal(df_diff$dv)
    compare_normal(dv_fit, label1 = "control", label2 = "test")
}

# tihs
for (i in seq_len(n)) {
    # subset 40 rows with replacemnt
    df_sub <- sample(df_diff, n_data, replace = TRUE)
    tihs_fit <- fit_normal(df_diff$tihs)
    compare_normal(tihs_fit, label1 = "control", label2 = "test")
}
