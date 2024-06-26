# Introduction to R Demonstration

# Load the tidyverse (which includes dplyr and ggplot2)
library(tidyverse)

# R Basics

# Comments

1947 * 48964

1 + 1

2486 * 4375 / 28

joe <- 1

1 + joe

# |> 
# <-
# ==

library(tidyverse)

# Read data into R
data <- read_csv("C:/Users/joseph.shaw2/Documents/r_demo_data/dna_extraction_table.csv")

# <- means "this thing is this"
# |>  means "take this thing and then do something to it"

data_cobas <- data |> 
  filter(dna_extraction_method == "COBAS")

data_with_qc <- data |> 
  # mutate means "make a new column"
  mutate(quality_check = if_else(dna_concentration > 50, "Pass", "Fail"))

# Make plots

joe_plot <- ggplot(data_with_qc, aes(x = dna_extraction_method, y = , fill = quality_check)) +
  geom_bar(position = "dodge") +
  facet_wrap(~quality_check) +
  labs(x = "DNA extraction method", y = "Number of samples",
       title = "Joe's awesome plot")

ggsave("C:/Users/joseph.shaw2/Pictures/joe_plot.png", joe_plot)



# Dot
ggplot(data, aes(x = method_name, y = dna_concentration)) +
  geom_point()

# Jitter
ggplot(data, aes(x = method_name, y = dna_concentration)) +
  geom_jitter(shape = 21)

# Boxplot
ggplot(data, aes(x = method_name, y = dna_concentration)) +
  geom_boxplot()

ggplot(data, aes(x = reorder(method_name, desc(dna_concentration)), 
                 y = dna_concentration)) +
  geom_boxplot()

# Violinplot
ggplot(data, aes(x = reorder(method_name, desc(dna_concentration)), 
                 y = dna_concentration)) +
  geom_violin()

# Stacked bar
ggplot(data_mod, aes(x = method_name, y = , fill = qc_check)) +
  geom_bar()

# Side-by-side bar
ggplot(data_mod, aes(x = method_name, y = , fill = qc_check)) +
  geom_bar(position = "dodge")

# Dot with colour
ggplot(data_mod, aes(x = method_name, y = dna_concentration)) +
  geom_jitter(aes(colour = qc_check)) +
  ylim(0, 250) +
  geom_hline(yintercept = 10, linetype = "dashed")

# Dot with colour
my_plot <- ggplot(data_mod, aes(x = qc_check, y = dna_concentration,
                                colour = qc_check)) +
  geom_boxplot() +
  geom_hline(yintercept = 100, linetype = "dashed")+
  facet_wrap(~method_name) +
  theme_bw() +
  labs(title = "My amazing plot", 
       x = "QC Check", y = "DNA concentration (ng/ul)",
       subtitle = "R is just the best") +
  theme(legend.position = "bottom")

ggsave("C:/Users/joseph.shaw2/Pictures/my_plot.png", my_plot)
