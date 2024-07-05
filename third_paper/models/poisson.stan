data {
  int<lower=0> n;
  array[n] int<lower=0> y;
}

parameters {
  real<lower = 0> lambda;
}

model {
  y ~ poisson(lambda);
}
