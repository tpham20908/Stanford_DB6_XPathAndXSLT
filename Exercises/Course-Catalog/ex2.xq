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