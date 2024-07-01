# Working with multiple Excels in R - live script

# Load our packages
library(tidyverse)
library(readxl)
library(here)

# Read in an Excel files

results_table <- read_excel(path = here("data/demo_2/results_and_dna_concs.xlsx"),
                            sheet = "results",
                            col_types = c("text", "text", "text"))

dna_concs_table <- read_excel(path = here("data/demo_2/results_and_dna_concs.xlsx"),
                              sheet = "dna_concs",
                              col_types = c("text", "text", "numeric"))

referrers_table <- read_excel(path = here("data/demo_2/referrers.xlsx"),
                              sheet = "referrers",
                              col_types = c("text", "text"))

# Join the tables together

# left_join: join tables together based on an identifier column
# table x on the left
# table y on the right

joined_table <- results_table |> 
  left_join(dna_concs_table, 
            # Join by labno, but in the second table it's written "lab_number"
            join_by("labno" == "lab_number")) |> 
  left_join(referrers_table,
            by = "i_gene_s_no")

# Filter our big table

filtered_table <- joined_table |> 
  # We need samples that:
  filter(
    # Were tested on the Inherited Cancer Panel (SSXT HS2 ICPv4)
    test == "SSXT HS2 ICPv4" &
      # Have a DNA concentration over 50 ng/ul
      concentration > 50 &
      # Have a BRCA1 or BRCA2 variant
      # grepl looks for a pattern and pulls out that pattern
      grepl(pattern = "BRCA", x = genotype, ignore.case = TRUE) &
      # Came from the Clatterbridge Centre
      grepl(pattern = "clatter", x = consultant_address, ignore.case = TRUE))

# Save the file as a csv
write.csv(joined_table, file = here("outputs/joined_table.csv"),
          row.names = FALSE)
