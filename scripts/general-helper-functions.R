# ~~~~~ SCRIPT OVERVIEW --------------------------------------------------------
## Manuscript in progress
##
## Purpose: 
## This script creates common functions that are used by multiple scripts
##
## Overview:
## Main functions include: 
## * date/time handling functions
## 
## Code maintainers: Anne Aulsebrook
## github.com/aaulsebrook/pesa_acc_beh
##
## Date Created: 2022-03-22

# ~~~~~ Time handling functions ------------------------------------------------
#===USED===#
acc_to_posix <- function(dt){
  # Converts character datetime in ACC_NANO database to posix (UTC timezone)
  # Requires package fasttime
  # Note that fasttime package sometimes does weird things when timezone is not UTC
  posix_dt = fastPOSIXct(dt, tz="UTC")
  return(posix_dt)
}

#===USED===#
odba_to_posix <- function(dt){
  # Converts character datetime in GPS_TAG and ODBA_TAG databases to posix (CET timezone)
  # Requires package fasttime
  # UTC and CET should be 2 hours apart
  # CET and Alaska should be 10 hours apart
  posix_dt = as.POSIXct(dt, format="%Y-%m-%d %H:%M:%OS", tz="CET")
  return(posix_dt)
}

#===USED===#
local_dt_to_posix <- function(dt){
  # Converts character datetime from local observations and records to posix (Alaska timezone)
  # UTC and Alaska should be 8 hours apart
  posix_dt = as.POSIXct(dt, format="%Y-%m-%d %H:%M:%OS", tz="US/Alaska")
  return(posix_dt)
}

#===USED===#
local_date_to_posix <- function(date){
  # Converts character date from local observations and records to date (Alaska timezone)
  # UTC and Alaska should be 8 hours apart
  posix_date = as.POSIXct(date, format="%Y-%m-%d", tz="US/Alaska")
  return(posix_date)
}

dt_to_local <- function(posix_dt){
  with_tz(posix_dt, tzone = "US/Alaska")
}

#===USED===#
dt_to_acc <- function(posix_dt){
  with_tz(posix_dt, tzone = "UTC")
}

#===USED===#
#' Round fractional seconds and print
#' 
#' Due to floating point precision and the way that print methods round down
#' fractional seconds, datetimes can get messed up when converted from POSIXct 
#' to character (e.g. when exporting to csv). See more detail in this thread
#' https://stackoverflow.com/questions/7726034/how-r-formats-posixct-with-fractional-seconds
#' This function is still buggy sometimes but is an improvement.
#' 
#' @param x (POSIXct) a vector of datetime values to round.
#' @param digits number of decimal places to be used.
prtime <- function(x, digits=0) {
  x2 <- round(unclass(x), digits)
  attributes(x2) <- attributes(x)
  x <- as.POSIXlt(x2)
  x$sec <- round(x$sec, digits)
  # Add a fudge factor 
  x$sec <- x$sec + 10^(-digits-1)
  format.POSIXlt(x, paste("%Y-%m-%d %H:%M:%OS",digits,sep=""))
}

# ~~~~~ Accelerometry handling functions ---------------------------------------

# convert_raw_acc_to_g <- function(df) {
#   # Druid NANO tags produce raw values that need to be converted into g (/1000)
#   # this function is annoying because creates new column names
#   # and if it's run more than once by mistake then things get weird
#   df$x = df$x/1000
#   df$y = df$y/1000
#   df$z = df$z/1000
#   return(df)
# }

#===USED===#
get_raw_acc_segment <- 
  function(tag_id, segment_start, segment_end = NA, duration_secs = NA, 
           buffer_secs = 0,
           user = user_name, db = db_name,
           select_cols = "*"){
    # Important note: Times should be in local time
    # Input checking
    if(length(segment_end) != 1 | length(segment_start) != 1 | 
       length(duration_secs) != 1){
      stop(paste0("No more than one value can be provided for each of the arguments ", 
                  "segment_start, segment_end and duration"))
    }
    
    if(!is.na(segment_end) && !is.na(duration_secs)){
      stop("Only one of segment_end or duration_secs can be provided")
    }
    
    # Attempt conversion to POSIXct if in plain text format
    if(!is.POSIXct(segment_start)){
      segment_start <- 
        local_dt_to_posix(segment_start)
      if(is.na(segment_start)) 
        stop("Failed to parse segment_start time, provide as POSIXt")
    }
    if(!is.na(segment_end)){
      if(!is.POSIXct(segment_end)){
        segment_end <- 
          local_dt_to_posix(segment_end)
        if(is.na(segment_end)) 
          stop("Failed to parse segment_start time, provide as POSIXt")
      } 
    }
    
    # Connect to database
    con <- dbcon(user=user, db=db)
    # Check for tag ID in the database
    thisid <- 
      dbq(con, glue("SELECT tag_id FROM ACC_NANO ", 
                    "WHERE tag_id = '{tag_id}' ",
                    "LIMIT 1"))
    closeCon(con)
    
    if(nrow(thisid)==0) 
      print(paste0("Could not find id in database: ", tag_id))
    
    # Define start and end times of segment
    if(!is.na(duration_secs)){
      segment_end <- segment_start + duration_secs
    }
    if(buffer_secs > 0){
      segment_end <- segment_end + buffer_secs
      segment_start <- segment_start - buffer_secs
    }
    
    # Convert local segment start and end times to UTC time (to match database)
    # If times are already in UTC, times will not change
    segment_start <- dt_to_acc(segment_start) 
    segment_end <- dt_to_acc(segment_end)
    
    # Pull data matching the specified timeframe from the database
    con <- dbcon(user=user, db=db)
    if(!is.na(segment_end)) {
    result <- dbq(con, glue(
      "SELECT {select_cols} 
         FROM ACC_NANO 
         WHERE datetime_ >= '{segment_start}' 
            AND datetime_ <= '{segment_end}' 
            AND tag_id = '{tag_id}'"))
    }
    
    if(is.na(segment_end)) {
      result <- dbq(con, glue(
        "SELECT {select_cols} 
         FROM ACC_NANO 
         WHERE datetime_ > '{segment_start}' 
            AND tag_id = '{tag_id}'"))
    }
    
    closeCon(con)
    if(nrow(result) == 0) 
      message(paste0("Extracted 0 rows of data for ID ", 
                  tag_id, ". Check segment_start or try increasing buffer."))
    
    # Convert imported times to UTC (or they will be returned with the local tz)
    if(nrow(result)>0)
      result$datetime_ <- force_tz(result$datetime_, tzone = "UTC")
    
    return(result)
  }

exclude_duplicates <- function(df) {
  df <- distinct(df)
}

#===USED===#
apply_scaling <- function(dat, scaling_factor){
  result <- dat*scaling_factor
  return(result)
}

#===USED===#
#' Compute static acceleration from raw accelerometer data
#' 
#' Static X Y Z are computed.
#'
#' @param df (data.frame) df assumed to have x, y, and z columns 
#'      representing raw acceleration values
#' @param static_window_size (numeric) the size of the rolling window over which
#'      to compute static acceleration, in seconds
#' @param sr (integer) sampling rate (in Hz)
#' @return data.frame with new columns appended
get_static <- function(df, static_window_size, sr){
  df$statX <- frollmean(df$x, sr * static_window_size, fill=NA, 
                        algo="fast", align="center", na.rm=TRUE)
  df$statY <- frollmean(df$y, sr * static_window_size, fill=NA, 
                        algo="fast", align="center", na.rm=TRUE)
  df$statZ <- frollmean(df$z, sr * static_window_size, fill=NA, 
                        algo="fast", align="center", na.rm=TRUE)
  return(df)
}

#===USED===#
#' Compute ODBA from raw acceleration data
#'
#' @param df (data.frame) df assumed to have columns x/y/z (raw acceleration)
#' @param sr (integer) sampling rate (in Hz)
#' @return data.frame with new columns appended
get_odba <- function(df, static_window_size, sr, keep_raw=FALSE){
  df <- get_static(df, static_window_size, sr)
  df$odba <- abs(df$x - df$statX) + abs(df$y - df$statY) + abs(df$z - df$statZ)
  
  if(keep_raw==FALSE) {
  df <- df[, -c('x', 'y', 'z', 'statX', 'statY', 'statZ')]
  }
  
  if(keep_raw==TRUE) {
  df <- df[, -c('statX', 'statY', 'statZ')]
  }
  
  return(df)
}

#===USED===#
#' Computes dynamic acceleration and derived values on raw accelerometer data
#' 
#' Dynamic X/Y/Z, PDBA, ODBA, VeDBA, PDBA to VeDBA ratio are calculated
#' @param df (data.frame) df assumed to have columns x/Y/Z (raw acceleration)
#'      and statX/Y/Z (static acceleration)
#' @param sr (integer) sampling rate (in Hz)
#' @return data.frame with new columns appended
get_dynamic <- function(df, sr){
  # Assumes the data has columns x/Y/Z, and statX/Y/Z
  
  # Dynamic acceleration
  df$dynX <- df$x - df$statX
  df$dynY <- df$y - df$statY
  df$dynZ <- df$z - df$statZ
  df$dynXYZ <- sqrt(df$dynX^2 + df$dynY^2 + df$dynZ^2) # used in HAR features
  
  # Partial dynamic acceleration (PDBA)
  df$pdynX <- abs(df$dynX)
  df$pdynY <- abs(df$dynY) 
  df$pdynZ <- abs(df$dynZ)
  
  # Overall dynamic body acceleration (ODBA)
  df$ODBA <- df$pdynX + df$pdynY + df$pdynZ
  
  # Vectorial dynamic body acceleration (VeDBA) ('total' dynamic acc)
  df$VeDBA <- (df$pdynX^2 + df$pdynY^2 + df$pdynZ^2)^0.5

  return(df)
}

# ~~~~~ Clock adjustment functions ---------------------------------------------

#===USED===#
#' Exclude datapoints associated with back-and-forth clock jumps (pingpongs)
exclude_pingpongs <- function(dat, pingpong_pks){
  new_dat <- dat[!(dat$pk %in% pingpong_pks$pk), ]
  return(new_dat)
}

# ~~~~~ Windowing functions ----------------------------------------------------

#===USED===#
#' Get timestamps for a sliding window implementation
#' 
#' A series of sliding windows will be created between sw_start and sw_end. The
#' number of windows and window spacing depends on the window size and step. If
#' window step is smaller than window size, there will be overlapping windows.
#'
#' @param sw_start (POSIXct) The start time of the series of sliding windows
#' @param sw_end (POSIXct) The end time of the series of sliding windows
#' @param win_size (numeric) the duration of each window, in seconds
#' @param win_step (numeric) the interval between the start time of a window, 
#'      and the start time of the next window.
#' @return data.frame with 1 row per window, and window start/window end columns
get_window_timestamps <- function(sw_start, sw_end, win_size, win_step){
    # Calculate how many windows can be extracted from a sequence of data
    # Checks
    if (!is.POSIXt(sw_start) | !is.POSIXt(sw_end)){
      stop(paste0("seg_start and seg_end must be provided as POSIXct",
                  "with fractional seconds"))
    }
    
    # Allow partial windows at the end of the sequence
    window_duration <- as.numeric(sw_end) - as.numeric(sw_start)
    nwindows <- ceiling(window_duration / win_step)
    
    window_df <- data.frame(window_start_UTC = rep(NA, nwindows), 
                            window_end_UTC = rep(NA, nwindows))
    
    starts <- (0:(nwindows-1)) * win_step
    ends <- starts + win_size
    window_df$window_start_UTC <- prtime(starts + sw_start,2)
    window_df$window_end_UTC <- prtime(ends + sw_start,2)
    return(window_df)
  }



# ~~~~~ Miscellaneous ----------------------------------------------------------

#===USED===#
# exclude bird that died and the 1-hour recording
colour_combos_to_exclude <- c("O,Y,PI", "PI,DG,O")

# ~~~~~ Currently unused ----------------------------------------------------------

round_time = function(x, precision, method = round) {
  if ("POSIXct" %in% class(x) == FALSE)
    stop("x must be POSIXct")
  
  tz = attributes(x)$tzone
  secs_rounded = method(as.numeric(x) / precision) * precision
  as.POSIXct(secs_rounded, tz = tz, origin = "1970-01-01")
}

format_ecotopia_dt <- function(dt, time_chr_length){
  paste(substr(dt,1,10),substr(dt,12,12+time_chr_length-1))
}

#' Determine which rows of the raw accelerometer data file belong to this window
#' 
#' This function helps to subset a raw acceleration data frame more quickly than
#' filtering by window datetime.
#' @param window_index (integer) The window number (first, second, third etc.)
#' @param sample_rate (integer) sampling rate (in Hz)
#' @param win_size (numeric) the duration of each window, in seconds
#' @param win_step (numeric) the interval between the start time of a window, 
#' @return 
get_rows_for_window <- function(window_index, sample_rate, win_size, win_step,
                                start_buffer_rows){
  # window_index = first, second, third epoch etc. 
  # sample_rate = sampling rate in Hz
  # win_size = epoch size in seconds
  # win_step = difference in start time between successive windows (in seconds)
  # start_buffer_rows = number of rows until first window starts
  
  n_per_window <- win_size * sample_rate # number of samples (rows) in each window
  n_per_step <- win_step * sample_rate # number of rows until next window starts
  
  row_start <- start_buffer_rows + 
    round((window_index-1) * n_per_step) # rounds down if odd sample rate
  row_end <- row_start + n_per_window -1
  
  return(row_start:row_end)
}