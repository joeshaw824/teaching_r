# Preparing Data for "Working with Excel in R"

# Packages --------------------------------------------------------------------------

library("tidyverse")
library("here")

# Database Connection ---------------------------------------------------------------

dbi_con <- DBI::dbConnect(
  drv = odbc::odbc(),
  dsn = "moldb")

sample_tbl <- tbl(dbi_con, dbplyr::in_catalog(catalog = "MolecularDB",
                                              schema = "dbo",
                                              table = "Samples")) |> 
  janitor::clean_names()

results_tbl <- tbl(dbi_con, 
                   dbplyr::in_catalog(
                     catalog = "MolecularDB",
                     schema = "dbo",
                     table = "ResultsAccess")) |> 
  janitor::clean_names()

# Get sample data -------------------------------------------------------------------

recent_samples <- results_tbl |> 
  # Pull out samples from the previous year as an arbitrary time-range
  filter(genodate > "2023-01-01 00:00:00" & genodate < "2023-12-31 00:00:00" &
           # NGS is test-code 19
           testtype == 19) |> 
  select(genodate, labno, test, testtype, genotype) |> 
  collect() |> 
  filter(!base::duplicated(labno))

# Restrict to only a few NGS panels
recent_samples_filter <- recent_samples |> 
  filter(test %in% c("NGS DNA QIAseq PanSolid",
                     "SSXT HS2 ICPv4", 
                     "NGS RNA QIAseq V2_ONCOGENE_FUSION_QS"))

samples_to_get <- recent_samples_filter$labno

sample_info <- sample_tbl |> 
  filter(labno %in% samples_to_get) |> 
  select(labno, i_gene_s_no, concentration, consultant_address) |>
  collect()

# Table 1
sample_results <- recent_samples_filter |> 
  select(labno, test, genotype) |> 
  filter(!labno %in% c("water", "Water", "WATER"))

# Table 2
sample_dna_concs <- sample_info |> 
  select(labno, i_gene_s_no, concentration) |> 
  rename(lab_number = labno) |> 
  filter(!duplicated(i_gene_s_no) & !is.na(i_gene_s_no)) |> 
  mutate(concentration = as.numeric(concentration))

# Table 3
sample_referrer <- sample_info |> 
  select(i_gene_s_no, consultant_address) |> 
  filter(!duplicated(i_gene_s_no) & !is.na(i_gene_s_no)) |> 
  filter(!consultant_address %in% c(NA, ""))

# Joining (demo) --------------------------------------------------------------------

# We need to identify samples which:
# - Have a DNA concentration over 50
# -	Were tested on the Inherited Cancer Panel
# -	Came from the Clatterbridge centre
# -	Have a BRCA1 or 2 variant

results_joined <- sample_results |> 
  left_join(sample_dna_concs, join_by("labno" == "lab_number")) |> 
  left_join(sample_referrer, by = "i_gene_s_no")

results_filtered <- results_joined |> 
  # Use ==
  filter(test == "SSXT HS2 ICPv4") |> 
  # Filter on a numeric
  filter(concentration > 10) |> 
  # Use grepl for pattern recognition
  filter(grepl(pattern = "BRCA", x = genotype, ignore.case = TRUE)) |> 
  filter(grepl(pattern = "clatterbridge", x = consultant_address,
               ignore.case = TRUE))

# Export data -----------------------------------------------------------------------

write.csv(sample_results, file = here::here("data/demo_2/csv_files/sample_results.csv"),
           row.names = FALSE)

write.csv(sample_dna_concs, file = here::here("data/demo_2/csv_files/sample_dna_concs.csv"),
          row.names = FALSE)

write.csv(sample_referrer, file = here::here("data/demo_2/csv_files/sample_referrer.csv"),
          row.names = FALSE)
