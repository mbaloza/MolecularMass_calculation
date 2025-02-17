# Molecular Mass Calculation

This script calculates molecular masses from SMILES, retrieving missing SMILES from PubChem, and merging datasets.

## Dependencies
- R packages: `rcdk`, `readr`, `dplyr`, `webchem`

## Usage
1. Install the required R packages.
2. Run the script `MolecularMass_calculation_UFZ.R`.
4. Input the paths to your datasets when prompted.

## Output
- `UFZWANATARG_MolecularMass.csv`: Dataset with calculated molecular masses.
- `missing_molecular_mass.csv`: Rows with missing molecular masses.
- `Updated_SMILES.csv`: Dataset with updated SMILES.
- `Updated_SMILES_with_Molecular_Mass.csv`: Dataset with updated SMILES and molecular masses.
- `Updated_UFZWANATARG_MolecularMass.csv`: Final compiled dataset.

## Author
Marwa Baloza
