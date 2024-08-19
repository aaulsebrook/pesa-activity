# ~~~~~ SCRIPT OVERVIEW --------------------------------------------------------
#' This script accompanies the manuscript: Aulsebrook, Valcu, Jacques-Hamilton, Kwon, Krietsch, Santema, Delhey, Teltscher, Lesku, Kuhn, Wittenzellner & Kempenaers (In Submission) Activity and energy expenditure predict male mating success in the polygynous pectoral sandpiper.
#'
#' Purpose: 
#' This script cleans ODBA data collected on-board DEBUT NANO (Druid Technology)
#' data loggers, ready for analysis. 
#'
#' Code maintainers: Anne Aulsebrook
#' Code contributors: Anne Aulsebrook, Rowan Jacques-Hamilton
#' github.com/aaulsebrook/pesa_activity
#'
#' Inputs:
#' - Raw ODBA data (odba-data; csv)
#' - Capture records (capture-data; csv)
#' 
#' Outputs:
#' - Cleaned ODBA data (mean_ODBA_10min-intervals_onboard; csv)
#'
#' Overview:
#' In this script, the following functions are performed on raw ODBA data:
#' 1. Tidying of column names
#' 2. Exclusion of duplicate data (same values for same timestamp)
#' 3. Exclusion of data intervals with high overlap with other data intervals
#' 4. Exclusion of specific birds (trial recording, bird that was predated)
#' 5. Exclude data when tag not on bird
#' 6. Convert units to g

# ~~~~~ PREPARE WORKSPACE ------------------------------------------------------

# ---- Load packages ----
library(dplyr)
library(fasttime)
library(glue)
library(here)
library(lubridate) # for manipulating timezones

# ---- Import helper functions ----
source(here("scripts","general-helper-functions.R"))

# ---- Import and format data
all_odba <- read.csv(here("data","odba-data.csv"))
all_odba <- all_odba %>%
  mutate(window_end_utc = acc_to_posix(window_end_utc))

captures <- read.csv(here("data","capture-data.csv"))

# ---- Set output directory
output_dir <- here("outputs","processed-data")

if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

# ---- Define parameters ----
window_length = 10 # window length in minutes

# ~~~~~ EXCLUDE DUPLICATES -----------------------------------------------------
odba <- unique(all_odba, by=c("tag_ID","window_end_utc","mean_ODBA"))

# ~~~~~ EXCLUDE OVERLAPPING INTERVALS ------------------------------------------
accepted_overlap_secs = window_length*0.4*60 # 40% overlap with previous window

odba <- odba %>%
  arrange(tag_ID, window_end_utc) %>%
  mutate(prev_tag=lag(tag_ID))

odba$latency <- c(0,diff(odba$window_end_utc))

clean_odba <- odba %>%
  filter(latency>=window_length*60-accepted_overlap_secs | tag_ID!=prev_tag)

# ~~~~~ EXCLUDE SPECIFIC BIRDS -------------------------------------------------

clean_odba <- clean_odba %>%
  filter(!colour_combo %in% colour_combos_to_exclude)

# ~~~~~ EXCLUDE DATA WHEN TAG NOT ON BIRD --------------------------------------

clean_odba_sub <- left_join(clean_odba, captures, join_by('tag_ID','bird_ID', 'colour_combo')) %>%
  mutate(released_dt_utc=dt_to_acc(local_dt_to_posix(paste(date, released)))) %>%
  filter((window_end_utc-10*60)>=released_dt_utc)

# ~~~~~ CONVERT UNITS TO G --------------------------------------
clean_odba_sub$mean_ODBA = clean_odba_sub$mean_ODBA/10000

# ~~~~~ TIDY AND SAVE DATA -----------------------------------------------------
tidy_odba <- clean_odba_sub %>%
  select(tag_ID, colour_combo, bird_ID, window_end_utc, mean_ODBA)

write.csv(tidy_odba, 
          file=here(output_dir,
                    glue("mean_ODBA_{window_length}min-intervals_onboard.csv")),
          row.names = FALSE)
