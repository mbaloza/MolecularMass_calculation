# Chemical Dataset Updater

This script updates a chemical dataset by calculating molecular masses from SMILES, retrieving missing SMILES from PubChem, and merging datasets.

## Dependencies
- R packages: `rcdk`, `readr`, `dplyr`, `webchem`

## Usage
1. Clone the repository.
2. Install the required R packages.
3. Run the script `update_chemical_dataset.R`.
4. Input the paths to your datasets when prompted.

## Output
- `UFZWANATARG_MolecularMass.csv`: Dataset with calculated molecular masses.
- `missing_molecular_mass.csv`: Rows with missing molecular masses.
- `Updated_SMILES.csv`: Dataset with updated SMILES.
- `Updated_SMILES_with_Molecular_Mass.csv`: Dataset with updated SMILES and molecular masses.
- `Updated_UFZWANATARG_MolecularMass.csv`: Final compiled dataset.

## Author
Marwa Baloza
