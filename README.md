# db
Functions for interacting with MFE database. 

To use any of these scripts in your own analysis script, you'll need to:

1. download the manual and/or sensor database from the Box directory. The manual database is also available on FigShare and DataONE. The sensor database may end up there soon too.

2. install the library RSQLite

3. set the variable dbdir to a string that contains the path to the database file on your computer

4. set the variable db to the name of the database file on your computer [we don't recommend changing this from the name of the file you downloaded]

# let R find the MFE database files by setting the path
#******************************************************
dbdir=file.path("C:/Users/ksaunde1/Documents/Regular Database/Current Database/$
db="MFEdb.db"  # dbname - name of database, default is 'MFEdb.db'

5. source the script name


dbUtil.R contains 3 functions:
1. dbTableList() which provides a list of tables in the manual database
2. dbTable() which will return data from a table in the manual database
3. dbTableStructure() which will return information about a table in the manual database

sensordbTable.R contains 2 functions: 
1. sensordbTableList() which returns a list of tables in the sensor database
2. sensordbTable() which returns data from a table in the sensor database

MFEmetab.R contains a single function:
1. mfeMetab() which calculates lake metabolism parameters using Chris Solomon's maximumu likelihood code
for data in the sensor database
*to use this function you'll also need to source the dbUtil.R prior to use
