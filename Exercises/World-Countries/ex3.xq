(:**********************************************************************
Q1: Return the area of Mongolia.
***********************************************************************:)
doc("countries.xml")//country[@name = "Mongolia"]/data(@area)

(:**********************************************************************
Q2: Return the names of all cities that have the same name as the
country in which they are located.
***********************************************************************:)
doc("countries.xml")//country/city[name = parent::*/@name]/name

(:**********************************************************************
Q3: Return the average population of Russian-speaking countries.
***********************************************************************:)
avg(doc("countries.xml")//country[language = "Russian"]/data(@population))

(:**********************************************************************
Q4: Return the names of all countries that have at least three cities
with population greater than 3 million.
***********************************************************************:)
doc("countries.xml")//country[count(city[population > 3000000]) > 3]/data(@name)

(:**********************************************************************
Q5: Create a list of French-speaking and German-speaking countries. The
result should take the form:
<result>
  <French>
    <country>country-name</country>
    <country>country-name</country>
    ...
  </French>
  <German>
    <country>country-name</country>
    <country>country-name</country>
    ...
  </German>
</result>
***********************************************************************:)
<result>{
  <French>{
  for $f in doc("countries.xml")//country[language = "French"]
  return
    <country>{$f/data(@name)}</country>
  }</French>
}{
  <German>{
  for $g in doc("countries.xml")//country[language = "German"]
  return
    <country>{$g/data(@name)}</country>
  }</German>
}</result>

(:**********************************************************************
Q6: Return the countries with the highest and lowest population
 densities. Note that because the "/" operator has its own meaning in
 XPath and XQuery, the division operator is infix "div". To compute
 population density use "(@population div @area)". You can assume
 density values are unique. The result should take the form:
  <result>
    <highest density="value">country-name</highest>
    <lowest density="value">country-name</lowest>
  </result>
***********************************************************************:)
<result>{
  let $max_density := max(for $c in doc("countries.xml")//country
              let $density := $c/@population div $c/@area
              return $density)
  let $country_max_density := (for $c in doc("countries.xml")//country
                let $density := $c/@population div $c/@area
                where $density = $max_density
                return $c/data(@name))
  return
  <highest density = "{$max_density}">{$country_max_density}</highest>
}{
  let $min_density := min(for $c in doc("countries.xml")//country
              let $density := $c/@population div $c/@area
              return $density)
  let $country_min_density := (for $c in doc("countries.xml")//country
                let $density := $c/@population div $c/@area
                where $density = $min_density
                return $c/data(@name))
  return
  <lowest density = "{$min_density}">{$country_min_density}</lowest>
}</result>