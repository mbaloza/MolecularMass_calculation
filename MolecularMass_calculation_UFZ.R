
# Script: Molecular Mass calculation in a Chemical Dataset
# Author: Marwa Baloza
# Description: This script calculates molecular masses from SMILES, retrieves missing SMILES from PubChem,
#              and updates the dataset with the new data.

# Load necessary libraries
install.packages("rcdk")
install.packages("readr")
install.packages("dplyr")
install.packages("webchem")

library(rcdk)
library(readr)
library(dplyr)
library(webchem)

# Main script

# Step 1: Load the initial dataset
file_path1 <- "UFZWANATARG_11082019.csv"
data <- read_csv(file_path1)

# Check column names
print(colnames(data))

# Step 2: Calculate molecular masses

# Function to calculate molecular mass from SMILES
calculate_molecular_mass <- function(smiles) {
  if (is.na(smiles) {
    return(NA)
  }
  molecule <- parse.smiles(smiles)[[1]]
  if (is.null(molecule)) {
    return(NA)
  }
  return(get.mol2formula(molecule, charge = 0)@mass)
}

# Apply the function to the SMILES column
data$Molecular_Mass <- sapply(data$SMILES, calculate_molecular_mass)

# Print the resulting data with molecular masses
print(data[, c("Name", "Molecular_Mass(g/mol)")])


# Step 3: Save the dataset with molecular masses
output_path1 <- "UFZWANATARG_MolecularMass.csv"
write_csv(data, output_path1)

# Step 4: Identify and save rows with missing molecular masses
missing_molecular_mass <- data[is.na(data$Molecular_Mass), ]

# Print the rows with missing Molecular_Mass values
print(missing_molecular_mass)

#10 compounds have missing MM values

output_path2 <- "missing_molecular_mass.csv"
write_csv(missing_molecular_mass, output_path2)


# Step 5: Update missing SMILES in the missing molecular mass dataset
df <- read_csv(output_path2)
df <- update_missing_smiles(df)

# Step 6: Save the updated dataset with missing SMILES
output_path3 <- "Updated_SMILES.csv"
write_csv(df, output_path3)

# Check if SMILES column exists
if (!"SMILES" %in% colnames(df)) {
  stop("No SMILES column found in the dataset.")
}


# Function to retrieve SMILES from PubChem using compound name
get_smiles_pubchem <- function(name) {
  tryCatch({
    cid_result <- get_cid(name)
    
    if (nrow(cid_result) == 0) return(NA)  # If no CID found
    
    cid <- as.character(cid_result$cid[1])  # Extract first CID
    
    smiles_data <- pc_prop(cid, properties = "CanonicalSMILES")
    smiles_only <- as.character(smiles_data$CanonicalSMILES[1])  # Extract only SMILES string
    return(smiles_only)
  }, error = function(e) {
    return(NA)
  })
}


# Find missing SMILES
missing_smiles_index <- which(is.na(df$SMILES) | df$SMILES == "")

# Retrieve SMILES for missing values
df$SMILES[missing_smiles_index] <- sapply(df$Name[missing_smiles_index], get_smiles_pubchem)

print(df[is.na(df$SMILES) | df$SMILES == "", ])

# Tolyltriazole   
# Tricresylphosphate        
# Spinosad 


# Function to update missing SMILES in a dataset
update_missing_smiles <- function(df) {
  missing_smiles_index <- which(is.na(df$SMILES) | df$SMILES == "")
  df$SMILES[missing_smiles_index] <- sapply(df$Name[missing_smiles_index], get_smiles_pubchem)
  return(df)
}

# Step 7: Calculate molecular masses for the updated SMILES dataset
MM <- read_csv(output_path3)
MM$Molecular_Mass <- sapply(MM$SMILES, calculate_molecular_mass)

# Step 8: Save the final updated dataset
output_path4 <- "Updated_SMILES_with_Molecular_Mass.csv"
write_csv(MM, output_path4)

# Step 9: Merge the original dataset with the updated dataset
data1 <- read_csv(output_path1)
data2 <- read_csv(output_path4)
updated_data <- merge_and_update_datasets(data1, data2)

# Function to merge two datasets and update missing values
merge_and_update_datasets <- function(data1, data2) {
  updated_data <- left_join(data1, data2, by = "Name")
  updated_data <- updated_data %>%
    mutate(
      SMILES = ifelse(is.na(SMILES.x) | SMILES.x == "", SMILES.y, SMILES.x),
      Molecular_Mass = ifelse(is.na(Molecular_Mass.x), Molecular_Mass.y, Molecular_Mass.x)
    ) %>%
    select(-ends_with(".y"), -SMILES.x, -Molecular_Mass.x)  # Remove temporary columns
  colnames(updated_data) <- gsub(".x", "", colnames(updated_data))  # Rename columns
  return(updated_data)
}


# Step 10: Save the final compiled dataset
output_path5 <- "Updated_UFZWANATARG_MolecularMass.csv"
write_csv(updated_data, output_path5)

print("Script execution complete. All datasets have been updated and saved.")
