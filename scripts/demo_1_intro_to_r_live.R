# Demo script for Introduction to R

# Load the "tidyverse" package
library(tidyverse)

# Read in our data
data <- read_csv("C:/Users/joseph.shaw2/Documents/r_demo_data/dna_extraction_table.csv")

# <- this is the assignment operator. 
# It means "this equals this".

# |> this is the pipe operator (use control+shift+m as a shortcut)
# |> means "take this thing and do something to it"

# Filter the data to have only COBAS samples
data_cobas <- data |> 
  filter(dna_extraction_method == "COBAS")

# Make a new column called "quality_check"
# mutate means "make a new column"
data_qc <- data |> 
  mutate(quality_check = ifelse(dna_concentration > 100, "Pass", "Fail"))

# Make a plot
# aes stands for "aesthetic"
# geom means "geometric layer"
joe_plot <- ggplot(data_qc, aes(x = dna_extraction_method, y = ,
                    fill = quality_check)) +
  geom_bar(position = "dodge") +
  labs(x = "DNA Extraction Method", y = "Number of samples",
       title = "Joe's awesome plot") +
  theme_bw()

# Save the plot in this filepath
ggsave("C:/Users/joseph.shaw2/Pictures/my_plot.png", joe_plot)










