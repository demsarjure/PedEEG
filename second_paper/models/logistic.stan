data {
  int<lower=1> n;                   // total number of data points
  vector[n] x;                      // independent variables
  array[n] int<lower=0, upper=1> y; // dependent variable
}

parameters {
  real a;              // intercept
  real b;              // slope
  real<lower=0> sigma; // stdev
}

model {
  // priors
  b ~ cauchy(0, 2.5);

  // model
  y ~ bernoulli_logit(a + x * b);
}
