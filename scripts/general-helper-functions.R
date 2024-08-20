# ~~~~~ SCRIPT OVERVIEW --------------------------------------------------------
#'
#' Purpose: 
#' This script creates common functions that are used by multiple scripts
#'
#' Overview:
#' Main functions include: 
#' * date/time handling functions (to deal with multiple timezones)
#' * list of birds to exclude from analyses
#'
#' Date Created: 2022-03-22

# ~~~~~ Time handling functions ------------------------------------------------

acc_to_posix <- function(dt){
  # Converts character datetime used in accelerometer datasets to posix (UTC timezone)
  # Requires package fasttime
  # Note that fasttime package sometimes does weird things when timezone is not UTC
  posix_dt = fastPOSIXct(dt, tz="UTC")
  return(posix_dt)
}

local_dt_to_posix <- function(dt){
  # Converts character datetime from local observations and records to posix (Alaska timezone)
  # UTC and Alaska should be 8 hours apart
  posix_dt = as.POSIXct(dt, format="%Y-%m-%d %H:%M:%OS", tz="US/Alaska")
  return(posix_dt)
}

local_date_to_posix <- function(date){
  # Converts character date from local observations and records to date (Alaska timezone)
  # UTC and Alaska should be 8 hours apart
  posix_date = as.POSIXct(date, format="%Y-%m-%d", tz="US/Alaska")
  return(posix_date)
}

dt_to_local <- function(posix_dt){
  # Converts posix datetime from another timezone to Alaskan timezone
  with_tz(posix_dt, tzone = "US/Alaska")
}

dt_to_acc <- function(posix_dt){
  # Converts posix datetime from another timezone to accelerometer (UTC) timezone
  with_tz(posix_dt, tzone = "UTC")
}

# ~~~~~ Miscellaneous ----------------------------------------------------------

# exclude bird that died and the 1-hour recording
colour_combos_to_exclude <- c("O,Y,PI", "PI,DG,O")
