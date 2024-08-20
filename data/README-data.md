# Table of Contents

1.  [Overview](#overview) 

2.  [capture-data](#capture-data)

3.  [sighting-data](#sighting-data)

4.  [nest-data](#nest-data)

5.  [odba-data](#odba-data)

6.  [gps-data](#gps-data)

7.  [parentage-data](#parentage-data)

8.  [labelled-acc-data](#labelled-acc-data)

# Overview {#overview}

This readme describes the dataset for a paper currently in submission.

The dataset includes 7 files, described further below.

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

# capture-data {#capture-data}

------------------------------------------------------------------------

This .csv file contains data from each time a pectoral sandpiper was captured during the 2022 breeding season. Each row represents a single capture event. Data were recorded at the time of capture. Dates and times are in local time (Alaska Time Zone). Sex was based on size, behaviour and plumage characteristics. 

| Column       | Description                                |
|--------------|--------------------------------------------|
| species      | species code (PESA = pectoral sandpiper)   |
| sex          | m = male and f = female                    |
| date         | date of capture                            |
| cap_start    | approximate time capture attempt began     |
| caught       | approximate time of capture                |
| released     | approximate time of capture                |
| form_id      | ID of raw datasheet (for internal use)     |
| author       | initials of person who measured tarsus     |
| gps_id       | GPS used to record time and location       |
| gps_point    | Point number used for time and location    |
| bird_ID      | ID on metal leg band                       |
| UL           | bands on upper left leg (top to bottom)*   |
| UR           | bands on upper right leg (top to bottom)*  |
| LL           | bands on lower left leg (top to bottom)*   |
| LR           | bands on upper right leg (top to bottom)*  |
| harness      | size of harness used to attach data logger |
| tag_action   | tag (data logger) put "on" or taken "off"  |
| recapture    | first capture = 0, recapture = 1           |
| capture_meth | method: N = mistnet, T = walk-in trap      |
| tarsus       | tarsus length in mm                        |
| total_head   | total head length in mm                    |
| wing         | wing length in mm                          |
| body_mass    | body mass in g                             |
| nest         | ID of nest (if caught at nest)             |
| colour_combo | coloured leg bands used for identification |
| tag_ID       | ID number of data logger (tag)             |

------------------------------------------------------------------------

# sighting-data {#sighting-data}

------------------------------------------------------------------------

This .csv file contains data from each time a pectoral sandpiper with leg bands was re-sighted at the study site during the 2022 breeding season. Each row represents a single re-sighting. Data were recorded at the time of the sighting. Dates and times are in local time (Alaska Time Zone). Sex is the sex recorded when first captured.

| Column       | Description                                |
|--------------|--------------------------------------------|
| species      | species code (PESA = pectoral sandpiper)   |
| sex          | m = male and f = female                    |
| author       | initials of the observer                   |
| colour_combo | coloured leg bands used for identification |
| datetime     | date and time of the observation           |
| lat          | latitude (WSG84 coordinate system)         |
| lon          | longitude (WSG84 coordinate system)        |

------------------------------------------------------------------------

# nest-data {#nest-data}

------------------------------------------------------------------------

This .csv file contains data on each nest that was found at the study site during the 2022 breeding season. Each row represents a unique nest. We estimated the likely hatch date based on floatation of the eggs. Hatch date is the date the eggs hatched in an incubator. Some eggs were predated before they could be floated and not all eggs hatched in the incubator. Pectoral sandpipers usually lay 4 eggs per clutch but some females either laid less than 4 eggs or had some eggs predated. The maximum number of clutches per female at the study site was 1.

| Column           | Description                                  |
|------------------|----------------------------------------------|
| nest             | nest ID (unique code for each nest)          |
| first_clutchsize | number of eggs in nest when nest found       |
| max_clutchsize   | maximum number of eggs ever observed in nest |
| date_found       | date when nest was first found               |
| est_hatch_date   | estimated hatch date                         |
| hatch_date       | observed hatch date                          |
| lat              | latitude (WSG84 coordinate system)           |
| lon              | longitude (WSG84 coordinate system)          |

------------------------------------------------------------------------

# odba-data {#odba-data}

------------------------------------------------------------------------

This .csv file contains accelerometry data summarised on-board the Debut NANO devices (Druid Technology) attached to pectoral sandpipers. The data were summarised at 10 minute intervals. Each row represents 10 minutes of data (summarised) collected by one device.  These data have not been "cleaned" and include some duplicated or erroneous data and data collected when the device was not on the bird. There is a script for cleaning this dataset ("clean-onboard-odba-data.R").

| Column           | Description                                  |
|------------------|----------------------------------------------|
| tag_ID           | ID number of data logger (tag)               |
| bird_ID          | ID on metal leg band of bird                 |
| colour_combo     | coloured leg bands used to identify bird     |
| mean_ODBA        | mean overall dynamic body acceleration       |
| window_end_utc   | recording interval end time (UTC timezone)   |

------------------------------------------------------------------------

# gps-data {#gps-data}

------------------------------------------------------------------------

This .csv file contains GPS data collected by the Debut NANO devices (Druid Technology) attached to pectoral sandpipers. Each row represents one data point collected by one device. The recording interval for GPS data varied depending on the battery level (more frequent when battery level higher). These data have not been "cleaned" and include some nonsense values and data collected when the device was not on the bird. These are cleaned in scripts before the data is used.

| Column           | Description                                  |
|------------------|----------------------------------------------|
| tag_ID           | ID number of data logger (tag)               |
| lat              | latitude                                     |
| lon              | longitude                                    |
| ele              | elevation (m)                                |
| pk               | internal reference code for MPIO database    |
| datetime         | date and time of datapoint (Alaska timezone) |

------------------------------------------------------------------------

# parentage-data {#parentage-data}

------------------------------------------------------------------------

This .csv file contains the results of a parentage analysis conducted for eggs/chicks and adults sampled during the 2022 breeding season. Parentage analysis was conducted in Cervus 3.0 using genetic data collected from blood or tissue samples. The incubating female caught at the nest was included as the known mother and all males that were sampled in 2022 (n=136) were included as candidate fathers. We were not always able to catch the female at the nest, so some mothers are unknown. Each row shows the results for one egg/chick. 

| Column           | Description                                  |
|------------------|----------------------------------------------|
| ID               | unique ID of egg/chick                       |
| EggID            | unique ID of egg (even if sampled as chick)  |
| Sex              | F = female, M = male (based on genetics)     |
| Nest             | ID of nest that the egg/chick was from       |
| ID mother        | bird ID (ID on metal leg band) of mother     |
| ID father        | bird ID of assigned father                   |
| F_mismatch       | number of mismatches with mother (blank = 0) |
| M_mismatch       | number of mismatches with father (blank = 0) |
| Comments         | comments about parentage analysis results    |

------------------------------------------------------------------------

# labelled-acc-data {#labelled-acc-data}

------------------------------------------------------------------------

This .csv file contains accelerometry data labelled with behavioural observations of 10 focal males. Each row represents a 10-minute interval or "window" of data recorded for one individual.

To synchronise behavioural observations with accelerometry data, we marked the exact timing of distinct behavioural transitions in each video (e.g. rest following by flying), detected corresponding patterns in raw tri-axial accelerometry data, then applied a time adjustment to the behavioural data to match the accelerometry data. We chose to use raw tri-axial accelerometry data for this component of the analysis because we could be more confident that observations and accelerometry were correctly matched. 

The definition of walking included any locomotion along the ground that involved leg movements but not flapping.

| Column               | Description                                              |
|----------------------|----------------------------------------------------------|
| window_start_UTC     | date time when window started (UTC timezone)             |
| window_end_UTC       | date time when window ended (UTC timezone)               |
| tag_ID               | ID of data logger (tag)                                  |
| bird_ID              | ID on metal leg band of bird                             |
| colour_combo         | coloured leg bands used to identify bird                 |
| window_ID            | ID number of window                                      |
| observation_ID       | unique ID for behavioural observation                    |
| win_in_segment       | consecutive number of window within observation          |
| beh_walk             | Proportion of time spent walking                         |
| beh_rest             | Proportion of time spent resting                         |
| beh_unknown          | Proportion of time where behaviour unknown               |
| beh_fly              | Proportion of time spent flying                          |
| beh_other            | Proportion of time spent on another category of behaviour|
| beh_preen            | Proportion of time spent preening                        |
| n_raw_acc_datapoints | number of raw accelerometry datapoints within window     |
| expected_n           | expected number of datapoints (based on window duration) |
| mean_ODBA            | Mean overall dynamic body acceleration                   |
| modal_behaviour      | Behaviour that comprised largest proportion of window    |
| mixed_behaviour      | 0 = not mixed (one behaviour), 1 = mixed (multiple behs) |

