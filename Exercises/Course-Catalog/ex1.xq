(:============================================================
  Q1: Return all Title elements (of both departments and courses).
==============================================================:)
doc("courses.xml")//Title

(:============================================================
  Q2: Return last names of all department chairs.
==============================================================:)
doc("courses.xml")//Chair/Professor/Last_Name

(:============================================================
  Q3: Return titles of courses with enrollment greater than 500.
==============================================================:)
