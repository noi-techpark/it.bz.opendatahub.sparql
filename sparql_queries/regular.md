# ODH VKG Regular SPARQL Queries

### Lodging businesses
*Limited to 500 results for demonstrational purposes*
```sql
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT ?h ?pos ?posLabel ?posColor 
WHERE {
  ?h a schema:LodgingBusiness ; 
     geo:asWKT ?pos ; 
     schema:name ?posLabel ; 
     schema:address ?a .
  # ?a schema:postalCode "39100" . # Uncomment for Bolzano only
  FILTER (lang(?posLabel) = 'de')
  
  # Colors
  OPTIONAL {
    ?h a schema:Campground .
    BIND("chlorophyll,0.5" AS ?posColor) # Green
  }
    OPTIONAL {
    ?h a schema:BedAndBreakfast .
    BIND("viridis,0.1" AS ?posColor) # Purple
  }
  OPTIONAL {
    ?h a schema:Hotel .
    BIND("jet,0.3" AS ?posColor) # Light blue
  }
  OPTIONAL {
    ?h a schema:Hostel .
    BIND("jet,0.8" AS ?posColor) # Red
  }
}
LIMIT 500
```

### Biggest lodging businesses
*Limited to 50 results for demonstrational purposes*
```sql
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX schema: <http://schema.org/>
PREFIX : <http://noi.example.org/ontology/odh#>

SELECT ?pos ?posColor ?bName
      (SUM(?nb) AS ?countRoom) 
      (SUM(?maxPersons) AS ?countMaxPersons) 
      (CONCAT(?bName, ': ', str(?countRoom), ' accommodations, max ', str(?countMaxPersons), ' guests') AS ?posLabel)  
WHERE {
  ?b a schema:LodgingBusiness ; 
     schema:name ?bName ; 
     geo:asWKT ?pos .
  
  ?r a schema:Accommodation ; 
     schema:containedInPlace ?b ; 
     :numberOfUnits ?nb ; 
     schema:occupancy [ schema:maxValue ?maxOccupancyPerRoom ] .
  
  # ?b schema:address [ schema:postalCode "39100" ] # For Bolzano only
  
  BIND (?nb * ?maxOccupancyPerRoom AS ?maxPersons)
  FILTER (lang(?bName) = 'en')
  
  # Colors
  OPTIONAL {
    ?b a schema:Campground .
    BIND("chlorophyll,0.5" AS ?posColor) # Green
  }
  OPTIONAL {
    ?b a schema:BedAndBreakfast .
    BIND("viridis,0.1" AS ?posColor) # Purple
  }
  OPTIONAL {
    ?b a schema:Hotel .
    BIND("jet,0.3" AS ?posColor) # Light blue
  }
  OPTIONAL {
    ?b a schema:Hostel .
    BIND("jet,0.8" AS ?posColor) # Red
  }
} 
GROUP BY ?b ?bName ?pos ?posColor
ORDER BY DESC(?countRoom)
LIMIT 50
```

### Number of lodging businesses 
```sql
PREFIX schema: <http://schema.org/>

SELECT (COUNT(?h) AS ?count) 
WHERE {
  ?h a schema:LodgingBusiness 
}
```

### Number of lodging businesses in Bolzano
```sql
PREFIX schema: <http://schema.org/>

SELECT (COUNT(DISTINCT ?h) AS ?count) 
WHERE {
  ?h a schema:LodgingBusiness ; 
     schema:address ?a .
  ?a schema:postalCode "39100" .
}
```

### Ski areas in the region with a custom label
*In this query the label of the marker for each ski area also contains an image showing the routes.
This means that when you visualize the query results in the map, for each map marker there will be an associated image. This is done via the bind command (last lines).*
```sql
PREFIX : <http://noi.example.org/ontology/odh#>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX schema: <http://schema.org/>

SELECT ?pos ?posLabel 
WHERE {
  ?s a schema:SkiResort ; 
     schema:name ?name ; 
     geo:asWKT ?pos ; 
     schema:geo [ schema:elevation ?maxElevation ] ; 
     schema:image ?img ; 
     schema:isPartOf ?skiRegion. 
  
  ?skiRegion a :SkiRegion ; 
     schema:name ?regionName.

  BIND(concat(
      '<h3>',str(?name),' </h3>',
      ?regionName,
      ', max elevation: ', str(?maxElevation), ' m ',
      '<img src="',str(?img), '" height="300" width="300">'
    ) as ?posLabel)
}
```
