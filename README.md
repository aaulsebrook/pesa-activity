# Activity and energy expenditure predict male mating success in the polygynous pectoral sandpiper

------------------------------------------------------------------------

This is the repository for the following paper (in submission):

`Aulsebrook, Valcu, Jacques-Hamilton, Kwon, Krietsch, Santema, Delhey, Teltscher, Lesku, Kuhn, Wittenzellner & Kempenaers (In Submission) Activity and energy expenditure predict male mating success in the polygynous pectoral sandpiper.`

# Overview

------------------------------------------------------------------------

This study examines the relationship between time spent active, overall dynamic body acceleration, and male mating success in wild pectoral sandpipers.

The study includes four main analysis steps, performed in sequential order:

1. Cleaning accelerometry dataset (`clean-onboard-odba.data.R`)
2. Defining activity thresholds (`define-activity-thresholds.Rmd`)
3. Mapping male movements relative to the study site (`map-male-locations.Rmd`)
4. Statistical analyses and plotting (`stats-and-figures.Rmd`)

All data required to run these steps are provided in this repository.

In addition, the outputs of Steps 1-3 are provided in this repository. This means it is possible to reproduce these steps in any order, or skip directly to Step 4 if desired. 

## Instructions

------------------------------------------------------------------------

1.  Download or clone this repository.

2.  Install packages (see `Package management & installation`).

3.  To reproduce all analyses, run each script in the order outlined above.Alternatively, it is possible to reproduce any single step by running just one script (which then uses the intermediate outputs provided in the `outputs` folder).
    
## Package management and installation

------------------------------------------------------------------------

This project uses renv for R package management. Launch the .Rproj file, then simply run `renv::restore()` to install all of the correct packages. This requires build tools that allow compilation of packages from source (e.g. Rtools for Windows). renv will only work if the following three files are in the project: `renv/activate.R` `renv.lock`, and `.Rprofile`.

## Project structure

------------------------------------------------------------------------

-   `scripts/` contains all code for analyses
-   `data/` contains all basic data files required to reproduce the analyses
-   `outputs/` contains model results, exploratory plots, and intermediate outputs

## Dataset

------------------------------------------------------------------------

Data required to reproduce the main analyses of the study are provided in this repository.

- `capture-data.csv` contains information about each time a bird was captured in the field, including banding information and details about when data loggers were deployed
- `sighting-data.csv` contains information about each time a banded bird was resighted in the field 
- `nest-data.csv` contains information about each nest at the study site
- `gps-data.csv` contains GPS data collected by data loggers fitted to birds
- `odba-data.csv` contains overall dynamic body acceleration (ODBA) data collected by data loggers fitted to birds
- `parentage-data.csv` contains the result of a parentage analysis conducted using genetic samples from each egg/chick and each adult captured at the study site
- `labelled-acc-data.csv` contains information on behaviour time-matched to accelerometry data

More details about each file are given in the data readme, which is available in the `data/` folder.

Some larger datasets were also used for supplementary analyses and other analyses that are peripheral to the main findings of the study. These datasets are available upon request. 

## Notes

------------------------------------------------------------------------

Some parts of the analysis use parallel loops and can have high memory requirements. Use fewer parallel workers to reduce the memory footprint.

The datafile `labelled-acc-data.csv` was generated through preparatory steps that are not included in this repository. These steps were conducted in accordance with the following paper:

`Aulsebrook, A., Jacques-Hamilton, R., & Kempenaers, B (2024) Quantifying mating behaviour using accelerometry and machine learning: challenges and opportunities, Animal Behaviour (207) p55-76, https://doi.org/10.1016/j.anbehav.2023.10.013`

The analysis pipeline for the paper above is available here: https://github.com/rowanjh/behav-acc-ml/

The datafiles and scripts associated with this prepatory analysis are also available upon request.