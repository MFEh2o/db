# db
Functions for interacting with MFE database. 

To use any of these scripts in your own analysis script, you'll need to:

1. Download the manual and/or sensor database from the Box directory. The manual database is also available on FigShare and DataONE. The sensor database may end up there soon too.

2. Install the library RSQLite: `install.packages("RSQLite")` (do this _once_, not at the top of every script). Then, at the top of each script, load the library: `library(RSQLite)`. 

3. Set the variable `dbdir` to a string that contains the path to the database file on your computer.

4. Set the variable `db` to the name of the database file on your computer (we don't recommend changing this from the name of the file you downloaded)

#let R find the MFE database files by setting the path

#******************************************************

dbdir <- file.path("C:/Users/ksaunde1/Documents/Regular Database/Current Database/")

db <- "MFEdb.db"  

sensor_dbdir <- file.path"C:/Users/ksaunde1/Documents/Sensor Database/Current Database/")

sensor_db <- "MFEsensordb.db"

5. Source the script name.


dbUtil.R contains 3 functions:
1. `dbTableList()` which provides a list of tables in the manual database
2. `dbTable()` which will return data from a table in the manual database
3. `dbTableStructure()` which will return information about a table in the manual database

sensordbTable.R contains 2 functions: 
1. `sensordbTableList()` which returns a list of tables in the sensor database
2. `sensordbTable()` which returns data from a table in the sensor database
