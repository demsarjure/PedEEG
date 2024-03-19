library(tidyverse)
library(cowplot)

# load and prep the data -------------------------------------------------------
# source data
source("data.R")

# load demographics
df_demo_control <- read.csv("../data/test/demographics_control.csv")
df_demo_test <- read.csv("../data/test/demographics_test.csv")

# load education
df_education <- read.csv("../data/test/education.csv")

# filter
df_demo_control <- df_demo_control %>%
  filter(id %in% control_ids)
df_demo_control$group <- "Control"

df_demo_test <- df_demo_test %>%
    filter(id %in% test_ids)
df_demo_test$group <- "Stroke"

# merge
df_demo <- rbind(df_demo_control, df_demo_test)

# add education
df_demo <- df_demo %>%
  left_join(df_education, by = "id")

# sec 1 is female, 0 is male
sum(df_demo_control$sex == 0)
sum(df_demo_control$sex == 1)

sum(df_demo_test$sex == 0)
sum(df_demo_test$sex == 1)

# df_demo to long
df_demo_long <- df_demo %>%
  pivot_longer(cols = c(age, sex, education))

# plot age/sex distributions ---------------------------------------------------
df_demo$Sex <- df_demo$sex
df_demo <- df_demo %>%
  mutate(Sex = replace(Sex, Sex == 0, "Male")) %>%
  mutate(Sex = replace(Sex, Sex == 1, "Female"))
df_demo$Group <- df_demo$group

p1 <- ggplot(df_demo, aes(x = age, color = Group, fill = Group)) +
  geom_density(size = 1, alpha = 0.25) +
  scale_color_brewer(type = "qual", palette = 1) +
  scale_fill_brewer(type = "qual", palette = 1) +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  xlim(5, 18) +
  facet_grid(. ~ Sex) +
  ylab("") +
  xlab("Age (years)")

# education as factors
# 1 - Elementary
# 2 - Vocational
# 3 - High
# 4 - Professional
# 5 - BSc or MSc
# 6 - PhD
df_demo$education <- factor(df_demo$education, levels = c(1, 2, 3, 4, 5, 6),
                            labels = c("Elementary", "Vocational", "High", "Professional", "BSc or MSc", "PhD"))
df_education <- df_demo %>% drop_na()

p2 <- ggplot(df_education, aes(x = education)) +
  geom_histogram(stat = "count") +
  scale_color_brewer(type = "qual", palette = 1) +
  scale_fill_brewer(type = "qual", palette = 1) +
  facet_grid(. ~ group) +
  ylab("") +
  xlab("Education")

plot_grid(p1, p2, labels = "AUTO", ncol = 1, align = "v", scale = 0.95)

ggsave(paste0("figs/demographics.png"),
        width = 1920,
        height = 1080,
        dpi = 150,
        units = "px",
        bg = "white")
