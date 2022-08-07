# load libraries
library(ggplot2)
library(cowplot)
library(data.table)
library(tidyverse)

# matrix plot function
matrix_plot <- function(filename, title = "", legend = FALSE) {
  # connectivity matrix
  c <- read.table(filename, header = FALSE, sep = ",")

  n <- length(c)

  # reshape data
  c <- c %>%
    rownames_to_column("Var1") %>%
    gather(Var2, value, -Var1) %>%
    mutate(
      Var1 = factor(Var1, levels = 1:n),
      Var2 = factor(gsub("V", "", Var2), levels = 1:n)
    )

  # plot
  plot <- ggplot(c, aes(Var1, Var2)) +
    geom_tile(aes(fill = value)) +
    scale_fill_gradient2(low = "white", high = "darkblue", guide = "colorbar") +
    theme_minimal() +
    theme(axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
          axis.text.x = element_blank(), axis.text.y = element_blank(),
          legend.title = element_blank(),
          panel.border = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          text = element_text(size = 18)) +
    xlab("") +
    ylab("") +
    ggtitle(title) +
    theme(plot.title = element_text(hjust = 0.5))

  if (!legend) {
    plot <- plot + theme(legend.position = "none")
  }

  plot
}

# connectome plots
matrix_plot("../data/ped/fc/PED_05.csv")
matrix_plot("../data/ped/fc/PED_14.csv")
matrix_plot("../data/ped/fc/PED_03.csv")
matrix_plot("../data/ped/fc/PED_13.csv")
matrix_plot("../data/ped/fc/PED_15.csv")
matrix_plot("../data/ped/fc/PED_16.csv")
matrix_plot("../data/ped/fc/PED_17.csv")

p1 <- matrix_plot("../data/ped/fc/PED_13.csv", title = "7 years old")
p2 <- matrix_plot("../data/ped/fc/PED_11.csv", title = "12 years old")
p3 <- matrix_plot("../data/ped/fc/PED_19.csv", title = "17 years old")

plot_grid(p1, p2, p3, ncol = 3, scale = 0.95) +
  theme(plot.background = element_rect(fill = "white", color = NA))

ggsave(paste0("fc_plot.png"),
       width = 3840,
       height = 1400,
       dpi = 300,
       units = "px")
