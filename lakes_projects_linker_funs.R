# Functions to associate lakes with projects, and projects with lakes
# Written by Kaija Gahm on 9 June 2020
# lakeprojects() takes one or more lakeID's as a character vector and returns a table showing those lakeID's with their associated projects. If the tableNames argument is set to TRUE (it's FALSE by default), then the returned table also includes the names of the db tables that contain the given lake/project combo. 

# projectlakes() takes one or more projectID's as a character vector and returns a table showing those projectID's with their associated lakes. If the tableNames argument is set to TRUE (it's FALSE by default), then the returned table also includes the names of the db tables that contain the given project/lake combo.

# First, do the part that takes a long time: pulling out the tables that link projects and lakes.
l <- dbTableList(fpath = dbdir, dbname = db)
linkertab_names <- c()
u <- dbTable("UNITS")
for(i in 1:length(l)){ # for each table
  column_names <- u %>%  # get its column names from UNITS
    filter(tableName == l[i]) %>%
    pull(colName) # pull column names out as a vector
  
  if("lakeID" %in% column_names & "projectID" %in% column_names){
    linkertab_names <- c(linkertab_names, l[i]) # if the table in question contains both lakeID and projectID, add its name to linkertab_names
  }
}

# create list of linker tables
linkertabs <- vector(mode = "list", length = length(linkertab_names))
for(i in 1:length(linkertabs)){ # populate the list with tables
  linkertabs[[i]] <- dbTable(linkertab_names[i]) %>% 
    mutate(tableName = linkertab_names[i]) %>% # create a column for the name of the table in question
    dplyr::select(lakeID, projectID, tableName) %>% 
    distinct() # get only distinct combinations of lakeID and projectID
}

# Bind all of these together
lt <- bind_rows(linkertabs, .id = NULL)


# Given a lakeID, find which projects are associated with it.
lakeprojects <- function(lakeID = c(), fpath = dbdir, dbname = db, tableNames = FALSE, linker_table = lt){
  # select the lakes of interest 
  lt <- linker_table %>% 
    rename("li" = lakeID) %>% # we have to temporarily rename the column so it's not the same as the argument name
    dplyr::filter(li %in% lakeID) %>%
    rename("lakeID" = li) %>%
    mutate(projectID = as.numeric(projectID)) %>%
    arrange(lakeID, projectID, tableName)
  
  if(tableNames){ # if the user asked for table names, return the whole table.
    return(lt) # get a data frame showing lake name, projectID, and table name
  } 
  
  else{ # if the user didn't ask for table names, return only lakeID's and projectID's.
    lt <- lt %>%
      dplyr::select(-tableName) %>%
      distinct()
    
    return(lt)
  }
}

# Given a projectID, find which lakes are associated with it.
projectlakes <- function(projectID = c(), fpath = dbdir, dbname = db, tableNames = FALSE, linker_table = lt){
  # select the projects of interest 
  lt <- linker_table %>% 
    rename("pi" = projectID) %>% # we have to temporarily rename the column so it's not the same as the argument name
    dplyr::filter(pi %in% projectID) %>%
    rename("projectID" = pi) %>%
    mutate(projectID = as.numeric(projectID)) %>%
    select(projectID, lakeID, tableName) %>%
    arrange(projectID, lakeID, tableName)
  
  if(tableNames){ # if the user asked for table names, return the whole table.
    return(lt) # get a data frame showing lake name, projectID, and table name
  } 
  
  else{ # if the user didn't ask for table names, return only lakeID's and projectID's.
    lt <- lt %>%
      dplyr::select(-tableName) %>%
      distinct()
    
    return(lt)
  }
}



lakeprojects(lakeID = c("WL", "EL"))

  