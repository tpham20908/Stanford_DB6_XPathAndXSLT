(:**********************************************************************
Q1: Return the area of Mongolia.
***********************************************************************:)
doc("countries.xml")//country[@name = "Mongolia"]/data(@area)

(:**********************************************************************
Q2: Return the names of all cities that have the same name as the country in which they are located.
***********************************************************************:)
doc("countries.xml")//country/city[name = parent::*/@name]/name