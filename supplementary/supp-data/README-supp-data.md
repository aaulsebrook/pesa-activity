# Table of Contents

1.  [Overview](#overview) 

2.  [ODBA-data](#ODBA-data)

3.  [tag_6O_scaling_factors](#tag_6O_scaling_factors)

# Overview {#overview}

This readme describes the supplementary dataset for a paper currently in submission.

The supplementary dataset includes 3 files, described further below.

## Leg bands and colour combinations

Many of the files refer to a colour combination (colour_combo). This refers to the combination of coloured leg bands used to identify the bird from a distance. The leg bands that were used were:

   - M = metal band
   - DG = dark green
   - DB = dark blue
   - PI = pink
   - PU = purple
   - O = orange
   - R = red
   - Y = yellow
   - W = white
   
## Dates and times

All dates are in the format dd/mm/yyyy. Raw data files contain dates and times with different time zones, depending on the source of the data (e.g. ODBA data is in UTC timezone, but field sightings are in Alaskan timezone). It is therefore important to note the time zone of all dates and times and handle them appropriately during analyses.

------------------------------------------------------------------------

# ODBA-data {#ODBA-data}

------------------------------------------------------------------------

There are two supplementary .csv files containing data based on raw accelerometry data collected by the Debut NANO devices (Druid Technology) attached to pectoral sandpipers:

- ODBA-and-activity_10min-intervals_rawbased.csv
- ODBA-and-activity_1min-intervals_rawbased.csv

The data were summarised at either 1 minute or 10 minute intervals (as per file names). Each row represents an interval of data (1 or 10 minutes). These data have already been "cleaned" and processed, following the same steps used to clean and process other ODBA data (odba-data.csv) used for the main analyses in the manuscript.

| Column              | Description                                                     |
|---------------------|-----------------------------------------------------------------|
| tag_ID              | ID number of data logger (tag)                                  |
| colour_combo        | coloured leg bands used to identify bird                        |
| bird_ID             | ID on metal leg band of bird                                    |
| window_end_utc      | recording interval end time (UTC timezone)                      |
| mean_ODBA           | mean overall dynamic body acceleration                          |
| mean_scaled_ODBA    | mean scaled ODBA*                                               |
| n_windows_threshold | number of data intervals used to calculate activity threshold** |
| separation_used     | mean overall dynamic body acceleration                          |
| activity_threshold  | ODBA value above which bird is considered "active"              |
| threshold_comment   | any comments about the activity threshold                       |
| active              | whether bird is "active" or "inactive" at this timepoint        |

* see below ()
** see script: "scripts/define-activity-thresholds.R" 

These files are used to determine the extent to different methods to define activity influenced key results of the paper (Figure S5).

------------------------------------------------------------------------

# tag_6O_scaling_factors {#tag_6O_scaling_factors}

------------------------------------------------------------------------

This datafile (tag_6O_scaling_factors.csv) contains a scaling factor for each accelerometry axis (x, y and z) for each tag ID. These scaling values were obtained according to the 6-orientation method described by Garde et al. 2022 (doi: 10.1111/2041-210X.13804). 

| Column           | Description                                  |
|------------------|----------------------------------------------|
| tag_ID           | ID number of data logger (tag)               |
| x_scaling_factor | scaling factor to apply to x-axis            |
| y_scaling_factor | scaling factor to apply to y-axis            |
| z_scaling_factor | scaling factor to apply to z-axis            |

The R Notebook showing how these values were calculated, and with further explanations of the method, can be found in 'supplementary/supp-preprocessing/scaling_nano_6O-method.html'. Only the .html file for this Notebook is provided because the raw data files used to determine these values are very large and peripheral to the scope of the paper; however, these files and the original scripts are available upon request. 

This datafile is used to assess whether calibration of data loggers (or lack thereof) might influenced key findings in the paper (Figure S3). 
