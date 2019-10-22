# ODH VKG Regular SPARQL Queries

### Lodging businesses
*limited to 500 results for demonstrational purposes*
```sql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT ?h ?pos ?posLabel ?posColor WHERE {
  ?h a schema:LodgingBusiness ; geo:asWKT ?pos ; schema:name ?posLabel ; schema:address ?a .
  OPTIONAL {
     ?h a ?c
    VALUES (?c ?posColor) {
      (schema:Campground "chlorophyll,0.5") # Green
      (schema:BedAndBreakfast "viridis,0.1") #Purple
      (schema:Hotel "jet,0.3") # Light blue
      (schema:Hostel "jet,0.8") # Red
    }
  }
  FILTER (lang(?posLabel) = 'de')
}
LIMIT 500
```

### Biggest lodging businesses
*limited to 50 results for demonstrational purposes*
```sql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX : <http://noi.example.org/ontology/odh#>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT ?pos ?posColor ?bName
      (SUM(?nb) AS ?countRoom)
      (SUM(?maxPersons) AS ?countMaxPersons)
      (CONCAT(?bName, ': ', str(?countRoom), ' accommodations, max ', str(?countMaxPersons), ' guests') AS ?posLabel)  WHERE {
  ?b a schema:LodgingBusiness ; schema:name ?bName ; geo:asWKT ?pos .
  OPTIONAL {
     ?r schema:containedInPlace ?b .
     ?r a schema:Accommodation ; :numberOfUnits ?nb ; schema:occupancy [ schema:maxValue ?maxOccupancyPerRoom ] .
    BIND (?nb * ?maxOccupancyPerRoom AS ?maxPersons)
  }
  FILTER (lang(?bName) = 'en')
  OPTIONAL {
     ?b a ?c
    VALUES (?c ?posColor) {
      (schema:Campground "chlorophyll,0.5") # Green
      (schema:BedAndBreakfast "viridis,0.1") #Purple
      (schema:Hotel "jet,0.3") # Light blue
      (schema:Hostel "jet,0.8") # Red
    }
  }
}
GROUP BY ?b ?bName ?pos ?posColor
ORDER BY DESC(?countRoom)
LIMIT 50
```

### Number of lodging businesses 
```sql
PREFIX schema: <http://schema.org/>

SELECT (COUNT(?h) AS ?count) WHERE {
  ?h a schema:LodgingBusiness 
}
```

### Number of lodging businesses in Bolzano
```sql
PREFIX schema: <http://schema.org/>

SELECT (COUNT(DISTINCT ?h) AS ?count) WHERE {
  ?h a schema:LodgingBusiness ; schema:address ?a .
  ?a schema:postalCode "39100" .
}
```

### Ski areas in the region with a custom label
*In this query the label of the marker for each ski area also contains an image showing the routes.
This means that when you visualize the query results in the map, for each map marker there will be an associated image. This is done via the the bind command (last lines).*
```sql
PREFIX : <http://noi.example.org/ontology/odh#>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>

SELECT * WHERE {
  ?s a schema:SkiResort ; 
     rdfs:label ?name ; 
     geo:asWKT ?pos ; 
     schema:geo [ schema:elevation ?maxElevation ] ; 
     schema:image ?img ; 
     schema:isPartOf ?skiRegion. 
  
  ?skiRegion a :SkiRegion ; 
     rdfs:label ?regionName.

  bind(concat(
      '<h3>',str(?name),' </h3>',
      ?regionName,
      ', max elevation: ', str(?maxElevation), ' m ',
      '<img src="',str(?img), '" height="300" width="300">'
    ) as ?posLabel)
}
```