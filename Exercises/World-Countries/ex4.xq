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

(:***********************************************************************
Q11: Return all languages whose name textually contains the name of a
country in which the language is spoken. For instance, Icelandic is
spoken in Iceland, so return Icelandic. (Hint: Depending on your
solution, may want to use data(.), which returns the text value of the
"current element" within an XPath expression.)
***********************************************************************:)
doc("countries.xml")//country/language[contains(data(.), parent::*/data(@name))]/data(.)

(:***********************************************************************
Q12: Return the number of countries where Russian is spoken.
***********************************************************************:)
count(doc("countries.xml")//country[language = "Russian"])

(:***********************************************************************
Q13: Return the names of all countries for which the data does not
include any languages or cities, but the country has more than 10
million people.
***********************************************************************:)
doc("countries.xml")//country[
  @population > 10000000 and
  count(language) = 0 and
  count(city) = 0]/data(@name)

(:***********************************************************************
Q14: Return the name of the country with the highest population. (Hint:
You may need to explicitly cast population numbers as integers with
xs:int() to get the correct answer.)
***********************************************************************:)
doc("countries.xml")//country[@population =
  max(doc("countries.xml")//country/data(@population))
  ]/data(@name)

(:***********************************************************************
Q15: Return the name of the country that has the city with the highest
population. (Hint: You may need to explicitly cast population numbers as
integers with xs:int() to get the correct answer.)
***********************************************************************:)
doc("countries.xml")//country[city/population =
  max(doc("countries.xml")//country/city/population)
  ]/data(@name)

(:***********************************************************************
Q16: Return the average number of languages spoken in countries where
Russian is spoken.
***********************************************************************:)
count(doc("countries.xml")//country[language = "Russian"]/language) div
count(doc("countries.xml")//country[language = "Russian"])

(:***********************************************************************
Q17: Return all country-language pairs where the language is spoken in
the country and the name of the country textually contains the language
name. Return each pair as a country element with language attribute,
e.g.,
<country language="French">French Guiana</country>
***********************************************************************:)
for $c in doc("countries.xml")//country
for $l in $c/language
where contains($c/@name, $l)
return <country language="{$l}">{$c/data(@name)}</country>

(:***********************************************************************
Q18: Return all countries that have at least one city with population
greater than 7 million. For each one, return the country name along with
the cities greater than 7 million, in the format:
<country name="country-name">
  <big>city-name</big>
  <big>city-name</big>
  ...
</country>
***********************************************************************:)
for $country in doc("countries.xml")//country[count(city[population > 7000000]) > 0]
return
  <country name = "{$country/data(@name)}">{
    for $city in $country/city
    where $city/population > 7000000
    return
    <big>{$city/data(name)}</big>
  }</country>

(:***********************************************************************
Q19: Return all countries where at least one language is listed, but the
total percentage for all listed languages is less than 90%. Return the
country element with its name attribute and its language subelements,
but no other attributes or subelements.
***********************************************************************:)
for $c in doc("countries.xml")//country[count(language) > 0 and sum(language/@percentage) < 90]
return
  <country name = "{$c/data(@name)}">
    {$c/language}
  </country>

(:***********************************************************************
Q20: Return all countries where at least one language is listed, and
every listed language is spoken by less than 20% of the population.
Return the country element with its name attribute and its language
subelements, but no other attributes or subelements.
***********************************************************************:)
for $c in doc("countries.xml")//country[count(language) > 0 and
  count(language[@percentage >= 20]) = 0]
return
  <country name = "{$c/data(@name)}">
    {$c/language}
  </country>

(:***********************************************************************
Q21: Find all situations where one country's most popular language is
another country's least popular, and both countries list more than one
language. (Hint: You may need to explicitly cast percentages as
floating-point numbers with xs:float() to get the correct answer.)
Return the name of the language and the two countries, each in the
format:
<LangPair language="lang-name">
  <MostPopular>country-name</MostPopular>
  <LeastPopular>country-name</LeastPopular>
</LangPair>
***********************************************************************:)
