(:***********************************************************************
Q1: Return the names of all countries with population greater than 100 million.
***********************************************************************:)
doc("countries.xml")//country[@population > 100000000]/data(@name)

(:***********************************************************************
Q2: Return the names of all countries where over 50% of the population
speaks German. (Hint: Depending on your solution, you may want to use
".", which refers to the "current element" within an XPath expression.)
***********************************************************************:)
doc("countries.xml")//country[language[data(.) = "German" and @percentage > 50]]/data(@name)

(:***********************************************************************
Q3: Return the names of all countries where a city in that country
contains more than one-third of the country's population.
***********************************************************************:)
doc("countries.xml")//country[city/population > (@population div 3)]/data(@name)

(:***********************************************************************
Q4: Return the population density of Qatar. Note: Since the "/" operator
has its own meaning in XPath and XQuery, the division operator is "div".
To compute population density use "(@population div @area)".
***********************************************************************:)
let $qatar := doc("countries.xml")//country[@name = "Qatar"]
return $qatar/@population div $qatar/@area

(:***********************************************************************
Q5: Return the names of all countries whose population is less than one
thousandth that of some city (in any country).
***********************************************************************:)
for $country_name in distinct-values(
  for $country in doc("countries.xml")//country
  for $city in doc("countries.xml")//city
  where $country/@population < ($city/population div 1000)
  return $country/data(@name)
)
return $country_name

(:***********************************************************************
Q6: Return all city names that appear more than once, i.e., there is
more than one city with that name in the data. Return only one instance
of each such city name. (Hint: You might want to use the "preceding" and/
or "following" navigation axes for this query, which were not covered in
the video or our demo script; they match any preceding or following
node, not just siblings.)
***********************************************************************:)
for $city1 in doc("countries.xml")//city
for $city2 in doc("countries.xml")//city
where $city1/name = $city2/name and $city1[parent::*/@name] < $city2[parent::*/@name]
return $city1/name

(:***********************************************************************
Q7: Return the names of all countries containing a city such that some
other country has a city of the same name. (Hint: You might want to use
the "preceding" and/or "following" navigation axes for this query, which
were not covered in the video or our demo script; they match any
preceding or following node, not just siblings.)
***********************************************************************:)
for $c1 in doc("countries.xml")//country
for $c2 in doc("countries.xml")//country
where $c1/city/name = $c2/city/name and $c1/@name != $c2/@name
return $c1/data(@name)

(:***********************************************************************
Q8: Return the names of all countries whose name textually contains a
language spoken in that country. For instance, Uzbek is spoken in
Uzbekistan, so return Uzbekistan. (Hint: You may want to use ".", which
refers to the "current element" within an XPath expression.)
***********************************************************************:)
for $c in doc("countries.xml")//country
where some $l in $c/language satisfies contains($c/@name, $l)
return $c/data(@name)

(:***********************************************************************
Q9: Return the names of all countries in which people speak a language
whose name textually contains the name of the country. For instance,
Japanese is spoken in Japan, so return Japan. (Hint: You may want to use
".", which refers to the "current element" within an XPath expression.)
***********************************************************************:)
for $c in doc("countries.xml")//country
where some $l in $c/language satisfies contains($l, $c/@name)
return $c/data(@name)

(:***********************************************************************
Q10: Return all languages spoken in a country whose name textually
contains the language name. For instance, German is spoken in Germany,
so return German. (Hint: Depending on your solution, may want to use
data(.), which returns the text value of the "current element" within an
XPath expression.)
***********************************************************************:)
doc("countries.xml")//country/language[contains(parent::*/data(@name), data(.))]/data(.)