install.packages("rcdk")
install.packages("readr")
library(rcdk)
library(readr)

# Read CSV file
data <- read_csv("path/to/your/data.csv")

# Define function and calculate molecular masses
calculate_molecular_mass <- function(smiles) {
  mol <- parse.smiles(smiles)[[1]]
  if (!is.null(mol)) {
    return(get.mol2formula(mol)@mass)
  } else {
    return(NA)
  }
}

data$Molecular_Mass <- sapply(data$SMILES, calculate_molecular_mass)

# Save results
write_csv(data, "compounds_with_molecular_masses.csv")

