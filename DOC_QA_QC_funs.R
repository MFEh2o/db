# QC functions for the DOC quality control pipeline
# First used in DOC_QA_QC.R
# Written by Kaija Gahm, November 2020

# Note to anyone trying to read this code: I use the `case_when` function a lot. It's the tidyverse version of nested ifelse() statements. The documentation for this function is here: https://www.rdocumentation.org/packages/dplyr/versions/0.7.8/topics/case_when. I also wrote two blog posts that explain it a little more clearly: [here](https://www.r-bloggers.com/2019/10/if-ifelse-had-more-ifs/) and [here](https://www.r-bloggers.com/2019/11/if-ifelse-had-more-ifs-and-an-else/).

# Note about this script: This isn't linear! The main function is processNewData(), and it's down near the bottom. It relies on seven other functions, which are defined first.

# Required packages -------------------------------------------------------
library(dplyr)

# SUPPORTING FUNS FOR processNewData() ------------------------------------
# 1. Named group split -------------------------------------------------------
# Function written by Romain Francois, here: https://github.com/tidyverse/dplyr/issues/4223. Splits list into groups using group_split, but then names the list items according to a designation of your choice.
named_group_split <- function(.tbl, ...) {
  grouped <- group_by(.tbl, ...)
  names <- rlang::eval_bare(rlang::expr(paste(!!!group_keys(grouped), sep = " / ")))
  
  grouped %>% 
    group_split() %>% 
    rlang::set_names(names)
}

# 2. checkDistance -----------------------------------------------------------
# Function to check the distance between pairs
# `df` should be a data frame with (at least) columns "DOC" and "sampleID"; otherwise this will throw an error.
# `threshold` must be numeric. This specifies the threshold value for classifying a pair of DOC replicates as "far" or not. Default is 1: e.g. points are `far` if the higher one is more than 100% greater than the lower one. If you set a threshold over 2, the function will warn you that this threshold may be unreasonable/not helpful, but it won't stop you from setting the threshold to whatever you want. 
checkDistance <- function(df, threshold = 1){
  # Check that the df is a data frame and has the requisite columns
  if(!is.data.frame(df)){
    stop("df is not a data frame. Please try again using a data frame.")
  }
  if(!("DOC" %in% names(df))|!("sampleID" %in% names(df))){
    stop("df is missing one or both of the required columns, `DOC` and `sampleID`.")
  }
  
  # Check that the "threshold" argument is numeric
  if(!is.numeric(threshold)){
    stop("Argument `threshold` must be numeric.")
  }
  
  # Check that the threshold is reasonable
  if(threshold > 2){
    warning("You have chosen a threshold value greater than 2: pairs of points will only be considered far apart if one is more than twice the value of the other.")
  }
  
  # Throw a warning if the df has 0 rows
  if(nrow(df) == 0){
    warning("The data frame you have entered has 0 rows: no pairs to check for distance.")
  }
  
  # Remove any non-pairs that may have somehow got in (pipeline should prevent this, but just in case.)
  pairs <- df %>%
    group_by(sampleID) %>%
    filter(n() == 2) %>% # must be exactly two replicates
    mutate(propDiff = (max(DOC) - min(DOC))/min(DOC), # calculate proportion difference between the two replicates
           far = case_when(propDiff > threshold ~ T, # compare to the user-defined threshold value.
                           TRUE ~ F))
  
  # get just the sampleID and the `far` column
  res <- pairs %>% 
    select(sampleID, far) %>%
    distinct() # one row for each sampleID
  
  # output: for each sampleID, are the points far apart? (based on user-defined `threshold`)
  return(res)
}


# 3. checkOOB ----------------------------------------------------------------
# Function to check whether a given row is OOB, based on comparisons to old data from the same lake/site/depthClass combo.
# oldData is a data frame containing previous DOC data: one row per sampleID (unless you set `forceMultipleRows` to `T`)
# nPoints (default: 10) is the threshold below which we won't compute mean/sd for comparison to new, incoming data. The idea is that fewer than e.g. 10 points isn't really enough data to get a meaningful estimate of the mean and standard deviation for DOC at a given site, and we don't want to assign a bunch of flags to new data based on shaky precedent.
# forceMultipleRows is F by default. If T, it allows more than one row per sampleID in `oldData`. This isn't typically how we do DOC quality control: we assume that old data represents either averaged values from multiple replicates, or singleton values.
checkOOB <- function(oldData, newData, nPoints = 10, forceMultipleRows = F){
  # Make sure we're dealing with averages/singletons for oldData: should have only one row per sampleID.
  if(length(unique(oldData$sampleID)) < nrow(oldData) & forceMultipleRows == F){
    stop("Some sampleID's have more than one row. Typically, DOC quality control is done by comparing new points to old data that is either averages or single points--either way, a single row per sampleID. If you're intentionally doing things differently, you can set the `forceMultipleRows` argument to 'TRUE' to bypass this error.")
  }
  
  # Make sure DOC column is numeric, or coercible to numeric
  if(is.factor(newData$DOC)){
    newData$DOC <- as.numeric(as.character(newData$DOC))
  }else if(is.character(newData$DOC)){
    newData$DOC <- as.numeric(newData$DOC)
  }else if(is.numeric(newData$DOC)){
    newData <- newData
  }else{
    stop("Column `DOC` is not numeric, character, or factor.")
  }
  
  # Split oldData into unique sites
  siteStats <- oldData %>%
    ungroup() %>%
    group_by(lakeID, siteName, depthClass) %>% # each unique lakeID/siteName/depthClass combo gets compared to new points from the same lakeID/siteName/depthClass.
    filter(n() >= nPoints) %>% # remove any that are below the user-defined threshold for precedent
    {if(nrow(.) > 0) summarize(.,
                               mn = mean(DOC, na.rm = T),
                               sd = sd(DOC, na.rm = T),
                               lower = mn - 2*sd,
                               upper = mn + 2*sd) else .}
  
  # Warn if no lakeID/siteName/depthClass combos have enough points for comparison to new data. This is to be expected for early years of data, but would be an unusual outcome for future data, unless somehow that future data was all collected from really new sites and we abandoned all the old standbys.
  if(nrow(siteStats) == 0){
    warning(paste0("No sites found with at least ", nPoints, " points."))
  }
  
  # Join siteStats to newData
  if(nrow(siteStats) == 0){ # if there's no data for precedent, make a fake df for joining.
    newData <- newData %>%
      mutate(mn = NA, sd = NA, lower = NA, upper = NA) # add NA stat columns
  }else{
    newData <- newData %>%
      left_join(siteStats, by = c("lakeID", "siteName", "depthClass")) # join mn/sd data to incoming data
  }
  
  # TRUE/FALSE/NA: is data out-of-bounds (OOB)?
  res <- newData %>% # compare incoming data DOC values to +/- 2sd bounds to determine whether incoming data is OOB.
    mutate(OOB = case_when(DOC > upper | DOC < lower ~ T,
                           is.na(upper) & is.na(lower) ~ NA,
                           TRUE ~ F))
  # Return data
  return(res)
}


# 4. processFarPairs ---------------------------------------------------------
# Once we've flagged pairs of replicates as being far apart (as per the user-defined threshold specified in checkDistance()), we need to determine whether one replicate, both replicates, or neither replicate, is out of bounds. Then we flag accordingly.
processFarPairs <- function(farPairs){
  # Coerce QCcode to character
  farPairs <- farPairs %>%
    mutate(QCcode = as.character(QCcode))
  
  # Initialize output data frame
  out <- farPairs[FALSE,] # same col names as farPairs, but 0 rows.
  
  # Loop through the data, dealing with each pair of replicates (each unique sampleID)
  for(i in 1:length(unique(farPairs$sampleID))){ # for each far pair:
    
    # Get data for this sampleID
    df <- farPairs %>%
      filter(sampleID == unique(farPairs$sampleID)[i])
    
    # If ONE rep is OOB
    if(!(any(is.na(df$OOB))) & sum(df$OOB == F) == 1){
      row <- df %>%
        filter(OOB == F) %>% # filter out the OOB point
        mutate(QCcode = case_when(!is.na(QCcode) ~ paste(QCcode, "code5", sep = "; "),
                                  TRUE ~ "code5"))
    }else{ # If BOTH reps are the same
      a <- mean(df$DOC) # compute the mean
      row <- df %>% # 'row' will be the single (averaged DOC) row to append to the resulting data
        mutate(DOC = a, # set DOC to the computed mean from above
               # deal with the comments: combine if not same, else take the one that's not NA.
               comments = case_when(first(comments) == last(comments) ~ first(comments),
                                    is.na(first(comments)) & !is.na(last(comments)) ~ last(comments),
                                    is.na(last(comments)) & !is.na(first(comments)) ~ first(comments),
                                    !is.na(first(comments)) & !is.na(last(comments)) & first(comments) != last(comments) ~ paste(first(comments), last(comments), sep = "; "))) %>% 
        # set QCcodes
        mutate(QCcode = case_when(all(df$OOB == T) & !is.na(QCcode) ~ paste(QCcode, "code2", sep = "; "),
                                  all(df$OOB == T) & is.na(QCcode) ~ "code2", # both out of bounds
                                  all(df$OOB == F) & !is.na(QCcode) ~ paste(QCcode, "code3", sep = "; "),
                                  all(df$OOB == F) & is.na(QCcode) ~ "code3", # both in bounds
                                  all(is.na(df$OOB)) & !is.na(QCcode) ~ paste(QCcode, "code9", sep = "; "),
                                  all(is.na(df$OOB)) & is.na(QCcode) ~ "code9")) %>% # no bounds for comparison
        slice(1) # only need one row for each sampleID (we've already overwritten DOC with the averaged DOC value.)
    }
    out <- bind_rows(out, row) # append the row for this sampleID to the initialized 'out' df.
  }
  
  # return the result
  return(out)
}


# 5. getNearPairsToCheck -----------------------------------------------------
# This function picks out the sampleID's for pairs where the reps were close together (as per the user-defined threshold for distance in the checkDistance() function), but whose average value falls OOB. For each of those sampleID's, we will wind back the clock and take a look at each of the individual reps. 
getNearPairsToCheck <- function(avgsAndSingles){
  sampleIDsVec <- avgsAndSingles %>%
    # get non-singletons (averaged values) that fell OOB
    filter(singleton == F & OOB == T) %>%
    pull(sampleID) %>%
    unique() # end up with a vector of unique sampleID's
  
  # return resulting vector
  return(sampleIDsVec)
}


# 6. processAvgsAndSingles ---------------------------------------------------
processAvgsAndSingles <- function(avgsAndSingles){
  # Note: this function does not deal with non-singleton rows with OOB == T--that's already been dealt with in getNearPairsToCheck.
  
  # Separate out the different cases (singles, averages, oob, no precedent, etc.). Assign QCcodes.
  # a. Non-OOB rows (averages or singles; doesn't matter)
  a <- avgsAndSingles %>%
    filter(OOB == F) %>%
    mutate(QCcode = case_when(singleton == F ~ "code6",
                              singleton == T ~ "code7"))
  
  # b. OOB singles
  b <- avgsAndSingles %>% # Flag OOB singles
    filter(OOB == T & singleton == T) %>%
    mutate(QCcode = case_when(!is.na(QCcode) ~ paste(QCcode, "code8", sep = "; "),
                              TRUE ~ "code8"))
  
  # c. Singles with no precedent--is.na(OOB)
  c <- avgsAndSingles %>%
    filter(is.na(OOB) & singleton == T) %>%
    mutate(QCcode = case_when(!is.na(QCcode) ~ paste(QCcode, "code11", sep = "; "),
                              TRUE ~ "code11"))
  
  # d. Pair averages with is.na(OOB)
  d <- avgsAndSingles %>%
    filter(is.na(OOB) & singleton == F) %>%
    mutate(QCcode = case_when(!is.na(QCcode) ~ paste(QCcode, "code10", sep = "; "),
                              TRUE ~ "code10"))
  
  # Combine a, b, c, and d into a df.
  tocombine <- list(a, b, c, d) %>% 
    lapply(., function(x) x %>% 
             mutate(QCcode = as.character(QCcode))) # convert QCcode to character to preclude problems joining NA vs character strings.
  df <- bind_rows(tocombine, .id = NULL) # bind list to df
  
  # return result
  return(df)
}

# 7. processCheckedNearPairs -----------------------------------------------------
# checkedDat is a data frame containing the individual replicates for each sampleID that had a near pair whose average fell OOB. Each rep in this df has already been checked for OOB. Now we have to assign QCcodes.
processCheckedNearPairs <- function(checkedDat){
  # Initialize output data frame
  out <- checkedDat[FALSE,] # same col names as checkedDat, but 0 rows.
  
  # Deal with each pair in a for loop
  for(i in 1:length(unique(checkedDat$sampleID))){
    
    # Get data for the target sampleID
    df <- checkedDat %>%
      filter(sampleID == unique(checkedDat$sampleID)[i])
    
    # If ONE point is OOB:
    if(!(any(is.na(df$OOB))) & sum(df$OOB == F) == 1){
      row <- df %>% # select only the row that's not out of bounds. Flag as singleton (S) and D.
        filter(OOB == F) %>%
        {if(!("QCcode" %in% names(.))) mutate(., QCcode = NA) else .} %>%
        mutate(QCcode = case_when(!is.na(QCcode) ~ paste(QCcode, "code4", sep = "; "),
                                  TRUE ~ "code4"))
      # If BOTH points are OOB:
    }else if(all(df$OOB == T)){
      a <- mean(df$DOC)
      row <- df %>%
        mutate(DOC = a) %>%
        {if(!("QCcode" %in% names(.))) mutate(., QCcode = NA) else .} %>%
        mutate(QCcode = case_when(!is.na(QCcode) ~ paste(QCcode, "code1", sep = "; "),
                                  TRUE ~ "code1")) %>%
        slice(1) # take only one row
    }# We don't need another if/else contingency here for is.na(OOB), because by definition if rows got to be in this df, they were already determined to be OOB.
    out <- bind_rows(out, row) # bind the current row to the initialized `out` df
  }
  
  # return finished data
  return(out)
}

# MAIN FUNCTION: processNewData() -----------------------------------------
# This is what the user actually calls in their code. User won't interact with the funs above.
# This function integrates other functions above into one large one. It takes new DOC data and old DOC data as inputs.
processNewData <- function(newData, oldData = newData[FALSE,]){
  # 0. Temporarily modify the old data so that similar sites get QC'ed together.
  oldData <- oldData %>%
    mutate(depthClass = case_when(depthClass == "MidEpi" ~ "PML",
                                  depthClass == "Surface" ~ "PML",
                                  TRUE ~ depthClass))
  
  # 0.5 Modify the new data so that similar sites get QC'ed together. Add a column to keep track of these changes so that we can reset them at the end.
  newData <- newData %>%
    mutate(changesTrack = case_when(depthClass == "MidEpi" ~ "depthClass MidEpi to PML",
                                    depthClass == "Surface" ~ "depthClass Surface to PML"),
           depthClass = case_when(depthClass == "MidEpi" ~ "PML",
                                  depthClass == "Surface" ~ "PML",
                                  TRUE ~ depthClass))
  
  # 1. Pull out singletons and flag them with a "singleton" column
  sings <- newData %>%
    group_by(sampleID) %>%
    filter(n() == 1) %>%
    mutate(singleton = T) %>% # flag as singletons; we'll remove this later
    as.data.frame() %>%
    {if(!("QCcode" %in% names(.))) mutate(., QCcode = NA) else .}
  
  pairs <- newData %>%
    group_by(sampleID) %>%
    filter(n() == 2) %>%
    mutate(singleton = F) %>% # flag as not singletons; we'll remove this later
    {if(!("QCcode" %in% names(.))) mutate(., QCcode = NA) else .} %>% # initialize QCcode column if it doesn't already exist
    as.data.frame()
  
  # 2. Check pairs for distance and join the result back
  pairs <- pairs %>% left_join(checkDistance(pairs), by = "sampleID")
  
  # 3. If close, take avg and add to `sings` to create `avgsAndSingles`
  avgsAndSingles <- pairs %>%
    filter(far == FALSE) %>%
    group_by(projectID, sampleID, lakeID, siteName, dateSample, dateTimeSample, 
             depthClass, depthTop, depthBottom, singleton) %>%
    summarize(DOC = mean(DOC, na.rm = T),
              comments = case_when(comments[1] == comments[2] ~ comments[1],
                                   is.na(comments[1]) & !is.na(comments[2]) ~ comments[2],
                                   is.na(comments[2]) & !is.na(comments[1]) ~ comments[1],
                                   !is.na(comments[1]) & !is.na(comments[2]) & comments[1] != comments[2] ~ paste(comments[1], comments[2], sep = "; "))) %>%
    bind_rows(sings %>% 
                select(projectID, sampleID, lakeID, siteName, 
                       dateSample, dateTimeSample, depthClass, 
                       depthTop, depthBottom, DOC, QCcode, singleton, comments)) %>%
    ungroup() %>% 
    as.data.frame()
  
  if(length(unique(avgsAndSingles$sampleID)) != nrow(avgsAndSingles)){ # check unique sampleID's: should be one row for each sampleID (either an averaged value or a singleton)
    stop("Number of unique sampleID's in `avgsAndSingles` is not the same as the number of rows. Check for repeats.")
  }
  
  # 4. If far, pull out into `farPairs`
  farPairs <- pairs %>%
    filter(far == TRUE) %>%
    select(-which(names(.) %in% 
                    c("far", "TN_DOC", "replicate", "metadataID", 
                      "flag", "updateID", "year"))) %>%
    ungroup() %>%
    as.data.frame()
  
  # 5. Check `avgsAndSingles` and `farPairs` for OOB
  avgsAndSingles <- checkOOB(oldData, newData = avgsAndSingles)
  farPairs <- checkOOB(oldData, newData = farPairs)
  
  # 6. Pull out the sampleID's for pairs whose average falls OOB
  toCheck <- getNearPairsToCheck(avgsAndSingles) # get the sampleID's for near pairs whose average values fall OOB
  
  # 7. Process the rest of the averages and singletons
  avgSingFinal <- processAvgsAndSingles(avgsAndSingles)
  
  # 8. Process the farPairs
  farPairsFinal <- processFarPairs(farPairs)
  
  # 9. Create a "final" data frame combining `avgSingFinal` and `farPairsFinal`.
  final <- bind_rows(avgSingFinal, farPairsFinal)
  
  # 10. Take the sampleID's for near pairs whose average falls OOB (from step 6), and check each individual observation in those pairs.
  if(length(toCheck) > 0){
    toCheckDat <- newData %>%
      filter(sampleID %in% toCheck) %>%
      mutate(singleton = F) %>%
      as.data.frame()
    
    checkedDat <- checkOOB(oldData, newData = toCheckDat) # check each for OOB
    nearPairsFinal <- processCheckedNearPairs(checkedDat) %>% # process the results
      select(names(final)) # align column names with the names in `final`
    
    # 11. Add results from 10. to df `final` created in 9.
    final <- bind_rows(final, nearPairsFinal)
  }
  
  if(!(all(newData$sampleID %in% final$sampleID))){ # throw an error if some of the sampleID's didn't make it through.
    stop("Not all sampleID's from `newData` made it into `final.` Something went wrong!")
  }
  
  # Reset depthClass if it was changed, and remove processing columns
  final <- final %>%
    mutate(depthClass = case_when(changesTrack == "depthClass MidEpi to PML" ~ "MidEpi",
                                  changesTrack == "depthClass Surface to PML" ~ "Surface",
                                  TRUE ~ depthClass)) %>%
    select(-c(mn, sd, lower, upper, OOB, changesTrack, singleton))
  
  # Assign flags and add explanatory comments
  code1Comment <- "Reps close but both OOB"
  code2Comment <- "Reps far apart and both OOB"
  code8Comment <- "Singleton and OOB"
  code9Comment <- "Reps far apart and <10 previous points for comparison"
  
  # Add comments for the QCcodes that result in flags.
  final <- final %>%
    mutate(flag = case_when(QCcode %in% c("code1", "code2", "code8", "code9") ~ "1",
                            TRUE ~ "0"), # assign binary 1/0 flag
           comments = case_when(QCcode == "code1" & is.na(comments) ~ code1Comment,
                                QCcode == "code1" & !is.na(comments) ~ paste(comments, code1Comment, sep = "; "),
                                QCcode == "code2" & is.na(comments) ~ code2Comment,
                                QCcode == "code2" & !is.na(comments) ~ paste(comments, code2Comment, sep = "; "),
                                QCcode == "code8" & is.na(comments) ~ code8Comment,
                                QCcode == "code8" & !is.na(comments) ~ paste(comments, code8Comment, sep = "; "),
                                QCcode == "code9" & is.na(comments) ~ code9Comment,
                                QCcode == "code9" & !is.na(comments) ~ paste(comments, code9Comment, sep = "; "),
                                TRUE ~ comments)) 
  
  
  # Return final data
  return(final)
}

# ADDITIONAL FUNCTION for checking QCcodes: -------------------------------
# this was mostly useful to KG in DOC_QA_QC.R in Nov. 2020. Probably not for future use, but maybe!
# lakeSiteCheck -----------------------------------------------------------
# Given a lake, examine cumulative number of averages/singles at each site*depthClass combo over the years. This is just a convenience function I wrote to create the same ggplot over and over again without retyping the same code.
lakeSiteCheck <- function(data, lake, alphaVal = 0.5){
  p <- oldData %>%
    filter(lakeID == lake) %>%
    group_by(siteName, depthClass, year = substr(dateTimeSample, 1, 4)) %>%
    summarize(n = n()) %>%
    ungroup() %>%
    group_by(siteName, depthClass) %>% summarize(year = year, c = cumsum(n)) %>%
    ggplot(aes(x = jitter(as.numeric(year), factor = 0.1), y = c, col = paste(siteName, depthClass)))+
    geom_line(alpha = alphaVal, size = 3)+
    geom_point(alpha = alphaVal, size = 2)+
    geom_hline(aes(yintercept = 10))
  return(p)
}




