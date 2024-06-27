# Demo 2

# Packages --------------------------------------------------------------------------

library(tidyverse)
library(readxl)

# Load packages ---------------------------------------------------------------------

data_folder <- "C:/Users/joseph.shaw2/Documents/teaching_r/data/demo_2/"

sample_results <- read_excel(path = paste0(data_folder, "results_and_dna_concs.xlsx"),
                             sheet = "results",
                             col_types = c("text", "text", "text"))

sample_dna_concs <- read_excel(path = paste0(data_folder, "results_and_dna_concs.xlsx"),
                               sheet = "dna_concs",
                               col_types = c("text", "text", "numeric"))

sample_referrers <- read_excel(path = paste0(data_folder, "referrers.xlsx"),
                               col_types = c("text", "text"))

# Join data -------------------------------------------------------------------------

results_joined <- sample_results |> 
  left_join(sample_dna_concs, join_by("labno" == "lab_number")) |> 
  left_join(sample_referrers, by = "i_gene_s_no")

# Filter data -----------------------------------------------------------------------

results_filtered <- results_joined |> 
  # Use ==
  filter(test == "SSXT HS2 ICPv4") |> 
  # Filter on a numeric
  filter(concentration > 10) |> 
  # Use grepl for pattern recognition
  filter(grepl(pattern = "BRCA", x = genotype, ignore.case = TRUE)) |> 
  filter(grepl(pattern = "clatterbridge", x = consultant_address,
               ignore.case = TRUE))

# Export joined data ----------------------------------------------------------------

write.csv(results_joined, file = here::here("outputs/results_joined.csv"),
          row.names = FALSE)
