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

(:***************************************************************
Q9: Create a summary of CS classes: List all CS department courses in order of enrollment. For each course include only its Enrollment (as an attribute) and its Title (as a subelement).
***************************************************************:)
<Summary>
{ for $cs in doc("courses.xml")//Department[@Code = "CS"]/Course
  order by xs:int($cs/@Enrollment)
  return
    <Course>
      {$cs/@Enrollment}
      {$cs/Title}
    </Course>
}
</Summary>

(:***************************************************************
Q10: Return a "Professors" element that contains as subelements a listing of all professors in all departments, sorted by last name with each professor appearing once. The "Professor" subelements should have the same structure as in the original data. For this question, you may assume that all professors have distinct last names. Watch out -- the presence/absence of middle initials may require some special handling. (This problem is quite challenging; congratulations if you get it right.)
***************************************************************:)
<Professors>{
  for $ln in distinct-values(doc("courses.xml")//Professor/Last_Name)
  for $fn in distinct-values(doc("courses.xml")//Professor[Last_Name = $ln]/First_Name)
  order by $ln
  return
    <Professor>
      <First_Name>{$fn}</First_Name>
      {for $mi in doc("courses.xml")//Professor[Last_Name = $ln]/Middle_Initial
       return $mi}
      <Last_Name>{$ln}</Last_Name>
    </Professor>
}</Professors>

(:***************************************************************
Q11: Expanding on the previous question, create an inverted course listing: Return an "Inverted_Course_Catalog" element that contains as subelements professors together with the courses they teach, sorted by last name. You may still assume that all professors have distinct last names. The "Professor" subelements should have the same structure as in the original data, with an additional single "Courses" subelement under Professor, containing a further "Course" subelement for each course number taught by that professor. Professors who do not teach any courses should have no Courses subelement at all. (This problem is very challenging; extra congratulations if you get it right.)
***************************************************************:)
<Inverted_Course_Catalog>{
  for $ln in distinct-values(doc("courses.xml")//Professor/Last_Name)
  for $fn in distinct-values(doc("courses.xml")//Professor[Last_Name = $ln]/First_Name)
  order by $ln
  return
    <Professor>
      <First_Name>{$fn}</First_Name>
      {for $mi in doc("courses.xml")//Professor[Last_Name = $ln]/Middle_Initial
       return $mi}
      <Last_Name>{$ln}</Last_Name>
      {for $p in distinct-values(
        doc("courses.xml")//Course/Instructors/Professor[Last_Name = $ln])
       where count($p) != 0
       return
       <Courses>{
        for $c in doc("courses.xml")//Course
        where $c/Instructors/Professor/Last_Name = $ln
        return
        <Course>{$c/data(@Number)}</Course>
       }</Courses>}
    </Professor>
}</Inverted_Course_Catalog>