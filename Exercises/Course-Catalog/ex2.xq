(:***************************************************************
  Q1: Return the course number of the course that is cross-listed as "LING180".
***************************************************************:)
doc("courses.xml")//Course[contains(Description, "LING180")]/data(@Number)