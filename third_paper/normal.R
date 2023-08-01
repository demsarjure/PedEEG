library(ggplot2)
library(tidyverse)

# load data and models ---------------------------------------------------------
source("./utils/normal.R")
source("data.R")

# fit --------------------------------------------------------------------------
iq_fit <- fit_normal(df_diff$iq)
iq_memory_fit <- fit_normal(df_diff$iq_memory)
iq_speed_fit <- fit_normal(df_diff$iq_speed)
visual_integration_fit <- fit_normal(df_diff$visual_integration)
hrt_fit <- fit_normal(df_diff$hrt)
cp_fit <- fit_normal(df_diff$cp)
ge_fit <- fit_normal(df_diff$ge)
mod_fit <- fit_normal(df_diff$mod)
tihs_fit <- fit_normal(df_diff$tihs)

# iq ---------------------------------------------------------------------------
compare_normal(iq_fit, label1 = "control", label2 = "test")
# P(control > test) = 100 +/- 0%
# P(control < test) = 0 +/- 0%

# iq_memory --------------------------------------------------------------------
compare_normal(iq_memory_fit, label1 = "control", label2 = "test")
# P(control > test) = 100 +/- 0%
# P(control < test) = 0 +/- 0%

# iq_speed ---------------------------------------------------------------------
compare_normal(iq_speed_fit, label1 = "control", label2 = "test")
# P(control > test) = 100 +/- 0%
# P(control < test) = 0 +/- 0%

# visual_integration -----------------------------------------------------------
compare_normal(visual_integration_fit, label1 = "control", label2 = "test")
# P(control > test) = 100 +/- 0%
# P(control < test) = 0 +/- 0%

# hrt --------------------------------------------------------------------------
compare_normal(hrt_fit, label1 = "control", label2 = "test")
# P(control > test) = 0 +/- 0%
# P(control < test) = 100 +/- 0%

# cp ---------------------------------------------------------------------------
compare_normal(cp_fit, label1 = "control", label2 = "test")
# P(control > test) = 0 +/- 0%
# P(control < test) = 100 +/- 0%

# ge ---------------------------------------------------------------------------
compare_normal(ge_fit, label1 = "control", label2 = "test")
# P(control > test) = 0 +/- 0%
# P(control < test) = 100 +/- 0%

# mod --------------------------------------------------------------------------
compare_normal(mod_fit, label1 = "control", label2 = "test")
# P(control > test) = 100 +/- 0%
# P(control < test) = 0 +/- 0%

# tihs -------------------------------------------------------------------------
compare_normal(tihs_fit, label1 = "control", label2 = "test")
# P(control > test) = 0 +/- 0%
# P(control < test) = 100 +/- 0%
