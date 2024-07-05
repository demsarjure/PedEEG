# influence of confounding factors on variables --------------------------------

# load data and models ---------------------------------------------------------
source("./utils/normal.R")
source("./utils/simple_linear.R")
source("data.R")

# set var
var <- "omissions"
diff <- df_diff[[var]]

# set NA education to 0
df_control_demo$education[is.na(df_control_demo$education)] <- 0
df_test_demo$education[is.na(df_test_demo$education)] <- 0

# drop na
df_control_demo <- drop_na(df_control_demo)
df_test_demo <- drop_na(df_test_demo)

# normal model -----------------------------------------------------------------
robust <- TRUE

fit_diff <- fit_normal(diff, robust = robust)
results_normal <- compare_normal(
    fit = fit_diff, label1 = "control", label2 = "test"
)

# complex model ----------------------------------------------------------------
# predictors: age, education
model <- cmdstan_model("./models/multiple_linear.stan")

# target variable
y <- c(df_control_demo[[var]], df_test_demo[[var]])

# independetent variables
X <- cbind(
    c(df_control_demo$age, df_test_demo$age),
    c(df_control_demo$education, df_test_demo$education),
    c(rep(0, nrow(df_control_demo)), rep(1, nrow(df_test_demo)))
)

# fit
stan_data <- list(
  n = length(y),
  m = ncol(X),
  X = X,
  y = y
)
fit <- model$sample(
  data = stan_data,
  parallel_chains = 4
)

mcmc_trace(fit$draws())
fit$summary()
df_samples <- as_draws_df(fit$draws())
colnames(df_samples) <- c("lp__", "a", "b_age", "b_education", "b_group", "sigma")

# influence of age
mcse(df_samples$b_age > 0)

# influence of education
mcse(df_samples$b_education > 0)

# positive difference (positive beta means stroke has a higher metric)
mcse(df_samples$b_group > 0)
