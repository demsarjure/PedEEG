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
matrix_plot("../data/ped/fc_csv/PED_01.csv", legend = TRUE)

ggsave(paste0("./figs/fc_plot.png"),
       width = 1100,
       height = 900,
       dpi = 200,
       units = "px",
       bg = "white")
