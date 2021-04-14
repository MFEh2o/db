# Allowed parameter values and range restrictions for relationalChecks.R

# Allowed values ---------------------------------------------------------
depthClassValues <- c("bottle", "distFromShore", "epi", "horiz.tow", "hypo", "meta", "midEpi", "piez", "PML", "point", "sediment", "staff", "surface", "tow", NA)

fishSexValues <- c("M", "F", "U", NA)

otuHabitatValues <- c("benthic", "empty", "littoral", "none", "pelagic", "terrestrial", "unidentifiable", "unknown")

otuGroupingValues <- c("amphibian", "benthic_invertebrate", "benthic_invertebrates", "bird", "empty", "fish", "invertebrate", "mammal", "none", "snake", "terrestrial", "terrestrial_invertebrate", "turtle", "unidentifiable", "unknown", "vertebrate", "zooplankton") # these need to be standardized!

docQCCodeValues <- c("code11", NA, "code10", "code15", "code9", "code6", "code7", 
                     "code1", "code3", "code4", "code5", "code2", "code8", "code12")

fishMorphometricsParameterValues <- c("X1", "Y1", "X2", "Y2", "X3", "Y3", "X4", "Y4", "X5", "Y5", 
                                      "X6", "Y6", "X7", "Y7", "X8", "Y8", "X9", "Y9", "X10", "Y10", 
                                      "X11", "Y11", "X12", "Y12", "X13", "Y13", "X14", "Y14", "X15", 
                                      "Y15", "X16", "Y16", "X17", "Y17", "X18", "Y18", "X19", "Y19", 
                                      "eyeWidth", "pecFinInsertionAngle", "pecFinLength", "pecFinBaseWidth", 
                                      "totalRakerCount", "lengthRaker1", "lengthRaker2", "lengthRaker3", 
                                      "lengthRaker4", "lengthRaker5", "lengthRaker6", "lengthRaker7", 
                                      "lengthRaker8", "lengthRaker9", "spaceRaker1", "spaceRaker2", 
                                      "spaceRaker3", "spaceRaker4", "spaceRaker5", "spaceRaker6", "spaceRaker7", 
                                      "spaceRaker8", "pecFinRatioSizeStd")

fishOtolithsParameterValues <- c("otolithWeight", "totalRadius", "ageAtCapture", "weightAtCapture", 
                                 "lengthAtCapture", "annulusRadius", "sulculGrooveShortAxisTotalRadius", 
                                 "sulculGrooveLongAxisTotalRadius", "sulculGrooveShortAxisAnnulusIncrement", 
                                 "sulculGrooveLongAxisAnnulusIncrement")

sedTrapDataParameterValues <- c("C", "N", "P")

waterChemParameterValues <- c("DOC", "nitrate", "particulateP", "POC", "PON", "SRP", "TN", "TP")

# Check function definitions ----------------------------------------------
expectedTablesCheck <- function(expectedTables, tableNames){
  # This function checks whether a text file is present for each expected table that you listed in relationalChecks.R. Be sure to update the list of expectedTables if you add or remove a database table!
  if(!all(expectedTables %in% tableNames)){
    stop(paste0("Did not find text files for all expected tables. Missing tables are: \n", 
                paste(expectedTables[!(expectedTables %in% tableNames)], 
                      collapse = ", ")))
  }else if(!all(tableNames %in% expectedTables)){
    stop(paste0("Found the following unexpected text files: \n",
                paste(paste0(tableNames[!(tableNames %in% expectedTables)], ".txt"), 
                      collapse = ", "), 
                "\nMake sure to update the expectedTables list with the names of any newly-added tables!"))
  }else{
    message("SUCCESS! Text files correspond to expected table names.")
  }
}

tableNamesSet <- function(n, tableName, tableList = tabs){
  # This function checks whether the column name vector you have defined is the right length to be set as column names for the given table. If it is, then that vector of names is returned. If not, it throws an error. When you change the structure of a database table (i.e. add, remove, or rename a column), be sure to update the names vector in the relationalChecks.R script, as well as updating the column names in the sql script.
  if(length(n) == ncol(tableList[[tableName]])){
    return(n)
  }else{
    stop(paste0("Incorrect number of column names for ", tableName, ". Cannot set names."))
  }
}

fkCheck <- function(childTable, childColumn, parentTable, parentColumn, tableList = tabs){
  # This function checks whether all the values in the child column are present in the parent column, allowing for NA's. May later customize this to allow the option to include or exclude NA values.
  child <- tabs[[childTable]]
  parent <- tabs[[parentTable]]
  if(!all(child[,childColumn] %in% c(NA, parent[,parentColumn]))){
    stop(paste0("Some elements of ", childTable, "$", childColumn, " not found in ", parentTable, "$", parentColumn))
  }
}

sCheck <- function(table, column, start, end, tableList = tabs){
  # This function checks whether a given component of the sampleID matches the corresponding column in the specified table.
  tab <- tabs[[table]] %>%
    mutate(across(everything(), as.character)) # grab the table and convert all to character
  if(column == "dateSample"){
    r <- which(as.character(tab[,column]) !=
                 as.character(lubridate::ymd(word(tab$sampleID, start = start, end = end, sep = "_"))))
    if(length(r) > 0){
      return(r)
      stop(paste0(table, "$", column, " disagrees with the ", column, " component of the sampleID at ", length(r), " rows. Returning a vector of problematic row indices."))
    }
  }else if(column == "dateTimeSample"){
    dateTimes <- word(tab$sampleID, start = start, end = end, sep = "_") %>% 
      lubridate::ymd_hm() %>% as.character()
    dateTimeSamples <- lubridate::parse_date_time(tab$dateTimeSample, orders = c("ymd_HMS", "ymd_HM", "ymd")) %>% as.character()
    r <- which(dateTimes != dateTimeSamples)
    if(length(r) > 0){
      return(r)
      stop(paste0(table, "$", column, " disagrees with the ", column, " component of the sampleID at ", length(r), " rows. Returning a vector of problematic row indices."))
    }
  }else{
    if(!all(replace_na(as.character(tab[,column]), "NA") == 
            word(tab$sampleID, start = start, end = end, sep = "_"))){
      r <- which(replace_na(as.character(tab[,column]), "NA") != 
                   word(tab$sampleID, start = start, end = end, sep = "_"))
      return(r)
      stop(paste0(table, "$", column, " disagrees with the ", column, " component of the sampleID at ", length(r), " rows. Returning a vector of problematic row indices."))
    }
  }
}

avCheck <- function(table, column, values, tableList = tabs){
  # This function checks whether all values in the specified table and column are contained in the allowed values vector.
  if(!all(tableList[[table]][,column] %in% values)){
    bad <- tableList[[table]][which(!tableList[[table]][,column] %in% values), column] %>% unique()
    stop(paste0("Some elements of ", table, "$", column, " not included in the allowed values. Problematic values are: ", paste(bad, collapse = ", ")))
  }
}
