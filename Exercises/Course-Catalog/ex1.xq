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
doc("courses.xml")//Course[data(@Enrollment > 500)]/Title

(:============================================================
  Q4: Return titles of departments that have some course that takes "CS106B" as a prerequisite.
==============================================================:)
for $d in doc("courses.xml")//Department
where $d/Course/Prerequisites/Prereq = "CS106B"
return $d/Title