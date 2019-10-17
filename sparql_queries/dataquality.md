# ODH VKG Data Quality SPARQL Queries

### Lodging businesses without accomodation
```sql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX : <http://noi.example.org/ontology/odh#>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT ?pos ?posColor ?bName
      (?bName AS ?posLabel)  WHERE {
  ?b a schema:LodgingBusiness ; schema:name ?bName ; geo:asWKT ?pos .
  MINUS {
     ?r schema:containedInPlace ?b .
     ?r a schema:Accommodation
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
```

### Lodging businesses with a non-South Tyrolean postal code
```sql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT ?h ?pos ?posLabel ?zip WHERE {
  ?h a schema:LodgingBusiness ; geo:asWKT ?pos ; schema:name ?posLabel ; schema:address ?a .
  ?a schema:postalCode ?zip .
  FILTER (lang(?posLabel) = 'de').
  FILTER regex(?zip, '^(?!39+)', 'i').
}
```

### Lodging businesses outside the South-Tyrolean regions' bounding box
*The bounding box coordinates were found using [this tool](https://boundingbox.klokantech.com/)*
```sql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT ?h ?pos ?posLabel ?box ?posColor {
  ?h a schema:LodgingBusiness ; schema:name ?posLabel ; schema:geo [ schema:latitude ?lat ; schema:longitude ?long ] ; geo:asWKT ?pos .
  FILTER (?lat < 46.2198 || ?lat > 47.0921 || ?long < 10.3818 || ?long > 12.4779) .
  FILTER (lang(?posLabel) = 'de') .
  BIND("POLYGON((10.3818 46.2198, 12.4779 46.2198, 12.4779 47.0921, 10.3818 47.0921, 10.3818 46.2198))" AS ?box) .
  BIND("jet,0.8" AS ?posColor) . # orange
}
```
