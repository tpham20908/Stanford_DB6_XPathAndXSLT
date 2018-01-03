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

(:============================================================
  Q5: Return last names of all professors or lecturers who use a middle initial. Don't worry about eliminating duplicates.
==============================================================:)
doc("courses.xml")//(Professor|Lecturer)[Middle_Initial]/Last_Name

(:============================================================
  Q6: Return the count of courses that have a cross-listed course (i.e., that have "Cross-listed" in their description).
==============================================================:)
count(doc("courses.xml")//Course[contains(Description, "Cross-listed")])

(:============================================================
  Q7: Return the average enrollment of all courses in the CS department.
==============================================================:)
avg(doc("courses.xml")//Department[data(@Code) = "CS"]/Course/@Enrollment)

(:============================================================
  Q8: Return last names of instructors teaching at least one course that has "system" in its description and enrollment greater than 100.
==============================================================:)
doc("courses.xml")//Course[contains(Description, "system")
and data(@Enrollment) > 100]/Instructors/(Lecturer|Professor)/Last_Name

(:============================================================
  Q9: Return the title of the course with the largest enrollment.
==============================================================:)
doc("courses.xml")//Course[@Enrollment = max(doc("courses.xml")//Course/@Enrollment)]/Title