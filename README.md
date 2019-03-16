# db
Functions for interacting with MFE database. You'll need to download the manual and/or sensor database from the Box directory.
The manual database is also available on FigShare and DataONE. The sensor database may end up there soon too.

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
