(:***************************************************************
  Q1: Return the course number of the course that is cross-listed as "LING180".
***************************************************************:)
doc("courses.xml")//Course[contains(Description, "LING180")]/data(@Number)

(:***************************************************************
  Q2: Return course numbers of courses that have the same title as some other course. (Hint: You might want to use the "preceding" and "following" navigation axes for this query, which were not covered in the video or our demo script; they match any preceding or following node, not just siblings.)
***************************************************************:)
doc("courses.xml")//Course[
  Title = following::*/Title or Title = preceding::*/Title
  ]/data(@Number)

(:***************************************************************
Q3: Return course numbers of courses taught by an instructor with first name "Daphne" or "Julie".
***************************************************************:)
doc("courses.xml")//Course[
  Instructors/(Lecturer|Professor)/First_Name = "Daphne" or
  Instructors/(Lecturer|Professor)/First_Name = "Julie"]/data(@Number)

(:***************************************************************
Q4: Return the number (count) of courses that have no lecturers as instructors.
***************************************************************:)
count(doc("courses.xml")//Course[count(Instructors/Lecturer) = 0])

(:***************************************************************
Q5: Return titles of courses taught by the chair of a department. For this question, you may assume that all professors have distinct last names.
***************************************************************:)
doc("courses.xml")//Course[Instructors/Professor/Last_Name =
  parent::*/Chair/Professor/Last_Name]/Title

(:***************************************************************
Q6: Return titles of courses that have both a lecturer and a professor as instructors. Return each title only once.
***************************************************************:)
doc("courses.xml")//Course[count(Instructors/Professor) > 0 and
  count(Instructors/Lecturer) > 0]/Title

(:***************************************************************
Q7: Return titles of courses taught by a professor with the last name "Ng" but not by a professor with the last name "Thrun".
***************************************************************:)
doc("courses.xml")//Course[Instructors/Professor/Last_Name = "Ng" and
  count(Instructors/Professor[Last_Name = "Thrun"]) = 0]/Title

(:***************************************************************
Q8: Return course numbers of courses that have a course taught by Eric Roberts as a prerequisite.
***************************************************************:)
doc("courses.xml")//Course[
  Prerequisites/Prereq =
    doc("courses.xml")//Course[
      Instructors/Professor[First_Name = "Eric" and
      Last_Name = "Roberts"]
      ]/data(@Number)
  ]/data(@Number)