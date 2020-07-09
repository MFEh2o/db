# Pull all data associated with a metadataID, a sampleID, etc.

library(tidyverse)
library(RSQLite)
source("dbUtil.R")



# Basic logic of this function: first, we connect to the database and list out all the names of the tables contained in it. Then, for each table in that list, we look through its column names to see if they contain `metadataID`. If they do, we filter that table to get rows associated with the metadataID(s) in question. Then we store those in a list.

# Helper function: get rows from a specified table with the specified metadataID(s)
getrows <- function(tablename, column, value, con){
  if(column == "metadataID"){
    query <- sprintf("SELECT * FROM '%s' WHERE metadataID = '%s'", tablename, value)
  }else if(column == "sampleID"){
    query <- sprintf("SELECT * FROM '%s' WHERE sampleID = '%s'", tablename, value)
  }else if(column == "projectID"){
    query <- sprintf("SELECT * FROM '%s' WHERE projectID = '%s'", tablename, value)
  }else{
    stop("Right now, this function can only handle 'metadataID', 'sampleID', and 'projectID' as column types.")
  }
  rows <- dbGetQuery(con, query)
}

# Note: as written, this function can only take one metadataID at a time. Will try to re-write it later to take more than one. 
getData <- function(column, value, dbdir = "./", dbname = "MFEdb.db"){
  drv <- dbDriver("SQLite") # have to do this in a separate command instead of just passing in drv = "SQLite" to dbConnect, for some reason. Otherwise it throws an error. Some info in the comments here: https://stackoverflow.com/questions/36943201/what-does-this-mean-unable-to-find-an-inherited-method-for-function-a-for-sig
  con <- dbConnect(drv = drv, dbname = "MFEdb.db") # connect to the database
  
  tableNames <- dbTableList(fpath = dbdir, dbname = dbname) # list the database table names

  l <- lapply(tableNames, function(x) dbListFields(con, x)) # grab the column names of all tables in the database.
  l2 <- lapply(l, function(x) column %in% x) %>% unlist() # which ones have `metadataID` among their column names?
  tableNamesReduced <- tableNames[l2] # grab only the tableNames that have metadataID
  
  # Get data frame subsets that have this metadataID
  rows <- lapply(tableNamesReduced, function(x) getrows(tablename = x, column = column, value = value, con))
  names(rows) <- tableNamesReduced
  keep <- lapply(rows, function(x) nrow(x) > 0) %>% unlist()

  rows <- rows[keep] # keep only the tables that do have rows pertaining to this metadataID.
  
  dbDisconnect(con) # disconnect from the database.
  return(rows)
}

getData(column = "sampleID", value = "ST_unknown_20100908_0000_sediment_5_unknown")
