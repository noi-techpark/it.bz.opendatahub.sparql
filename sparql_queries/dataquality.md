<!--
SPDX-FileCopyrightText: NOI Techpark <digital@noi.bz.it>

SPDX-License-Identifier: CC0-1.0
-->

# ODH VKG Data Quality SPARQL Queries

## Lodging businesses and accommodation

### Lodging businesses without accommodation
```sparql
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX schema: <http://schema.org/>

SELECT ?pos ?posColor ?bName (?bName AS ?posLabel)
WHERE {
  ?b a schema:LodgingBusiness ; schema:name ?bName ; geo:asWKT ?pos .
  MINUS {
     ?r schema:containedInPlace ?b .
     ?r a schema:Accommodation
  }
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
*NB: The bounding box coordinates were found using [this tool](https://boundingbox.klokantech.com/)*
```sql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT ?h ?pos ?posLabel ?box ?boxColor ?posColor {
?h a schema:LodgingBusiness ; schema:name ?posLabel ; schema:geo [ schema:latitude ?lat ; schema:longitude ?long ] ; geo:asWKT ?pos .
FILTER (?lat < 46.2198 || ?lat > 47.0921 || ?long < 10.3818 || ?long > 12.4779) .
FILTER (lang(?posLabel) = 'de') .
BIND("MULTILINESTRING((10.3818 46.2198, 12.4779 46.2198, 12.4779 47.0921, 10.3818 47.0921, 10.3818 46.2198))"^^geo:wktLiteral AS ?box) .
BIND("jet,0.8" AS ?posColor) .
BIND("jet,0.8" AS ?boxColor) .
}
```

### Lodging businesses in Bolzano with the wrong German or Italian name
```sql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT ?h ?pos ?posLabel ("jet,0.8" AS ?posColor) WHERE {
  ?h a schema:LodgingBusiness ; geo:asWKT ?pos ; schema:name ?name ; schema:address ?a .
  ?a schema:addressLocality ?deCity, ?itCity ; schema:postalCode "39100" . 
  FILTER ((lang(?name) = 'de') && (lang(?deCity) = 'de') && (lang(?itCity) = 'it') 
    && ((lcase(str(?itCity)) != "bolzano") || (lcase(str(?deCity)) != "bozen")))
  
  BIND(concat(?name,'<hr/>de: ',?deCity, '<hr/> it: ',?itCity) AS ?posLabel)
}
```

## Events

