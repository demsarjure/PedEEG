data {
  int<lower=1> n;
  vector[n] age;
  vector[n] sex;
  vector[n] y;
}

parameters {
  real a;
  real b_age;
  real b_sex;
  real<lower=0> sigma;
}

model {
  // priors
  b_age ~ cauchy(0, 2.5);
  b_sex ~ cauchy(0, 2.5);

  // model
  for (i in 1:n) {
    y[i] ~ cauchy(a + age[i] * b_age + sex[i] * b_sex, sigma);
  }
}
