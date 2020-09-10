# Met station QC functions
# Quality control functions for the HOBO met station sensor data
# Created by Kaija Gahm on 10 September 2020
# GH issue #41


# saturationDetect function -----------------------------------------------
# Problem: we noticed that some of the met station data (PAR values) saturated at abnormally high values on some dates, generating consecutive runs of the same exact value on those dates.
# We don't want to trust any data from days when the sensor saturated, because that indicates that something was probably miscalibrated.
# This function takes the following arguments:
#   - `df` is a data frame. For example, if met <- dbTable("hobo_metstation_corr"), then df = met.
#   - `col` is the name of the column you want to check for saturation, in quotes. For example, if you want to check for saturation in PAR values, then col = "cleanedPAR_uE_m2_s"

# First, the function finds all "runs" of repeated values in `col`. Then it checks whether there are any runs of 5 or more instances of the maximum value in df[,col]. If there are, it considers that value to be the saturation value. Then it flags all values from ANY date where the saturation value was detected at all, even if the saturation value was only hit once (i.e. not a long run of max. values). 

# In order for this function to make sense, you have to apply the saturation check to a lakeID and a period of time where all the data is collected by the same sensor. I have yet to build in parameters for specifying sensor identity. Waiting to hear back from Chris and Stuart about the best way to do that.

saturationDetect <- function(df, col){
  t <- rle(df[,col]) # get the run lengths
  runs <- data.frame(length = t$lengths, value = t$values) %>%
    mutate_all(as.numeric) # make a runs data frame
  
  # line up the runs with the original df indices
  runs$endidx <- cumsum(runs$length) # get start indices
  runs <- runs %>% # get end indices
    mutate(startidx = case_when(endidx == 1 ~ endidx,
                                TRUE ~ endidx + 1 - length))
  if(runs %>% filter(value == max(value, na.rm = T), length >= 5) %>% nrow() > 0){
    saturationValue <- max(runs$value, na.rm = T) # grab the saturation value
    df$flag <- ifelse(df[,col] == saturationValue, 1, 0) # flag the saturation value rows
    
    # which dates should we throw out?
    badDates <- df %>% 
      filter(flag == 1) %>% 
      pull(dateTime) %>% 
      lubridate::date() %>% 
      unique()
    
    # Flag all values from days when the sensor maxes out
    df$flag <- ifelse(lubridate::date(df[,"dateTime"]) %in% badDates, 1, 0)
    
    # Tell the user how many dates are getting flagged
    print(paste0("Detected ", length(badDates), " days when the sensor maxed out. Flagging all observations from those dates."))
    
    # Return the flagged data
    return(df)
    
    # If no saturation...
  } else{
    print("No saturation detected. Returning the original data frame.")
    return(df) # just return the df as is.
  }
}
