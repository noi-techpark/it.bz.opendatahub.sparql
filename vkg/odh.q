[QueryItem="Star"]
PREFIX schema: <http://schema.org/>

SELECT * {
 ?s ?p ?o .
}

[QueryItem="Lodging businesses"]
PREFIX : <http://noi.example.org/ontology/odh#>
PREFIX schema: <http://schema.org/>

SELECT * {
<http://noi.example.org/ontology/odh#data/accommodation/745EB990148B974EBB057DF103E5D7D3> a schema:LodgingBusiness ; ?p ?o .
}

[QueryGroup="Visual"] @collection [[
[QueryItem="lodging-bz-city-quality-issues"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT ?h ?pos (CONCAT(?name, CONCAT(CONCAT('<hr/>de: ',?deCity),CONCAT('<hr/> it: ',?itCity))) AS ?posLabel) WHERE {
  ?h a schema:LodgingBusiness ; geo:asWKT ?pos ; schema:name ?name ; schema:address ?a .
  ?a schema:addressLocality ?deCity, ?itCity ; schema:postalCode "39100" . 
  MINUS {
    ?a schema:addressLocality "Bolzano"@it . 
  }
  FILTER ((lang(?name) = 'de') && (lang(?deCity) = 'de') && (lang(?itCity) = 'it'))
}

[QueryItem="lodging-bz"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT ?h ?pos ?posLabel WHERE {
  ?h a schema:LodgingBusiness ; geo:asWKT ?pos ; schema:name ?posLabel ; schema:address ?a .
  ?a schema:postalCode "39100" .
  FILTER (lang(?posLabel) = 'de')
}

[QueryItem="lodging-st"]
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
  #?a schema:postalCode "39100" .
  FILTER (lang(?posLabel) = 'de')
}
LIMIT 500

[QueryItem="lodging-st-count"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
SELECT (COUNT(*) AS ?count) WHERE {
  ?h a schema:LodgingBusiness .
}

[QueryItem="lodging-bz-count"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT (COUNT(DISTINCT ?h) AS ?count) WHERE {
  ?h a schema:LodgingBusiness ; schema:address ?a .
  # ?a schema:addressLocality "Bolzano"@it .
  ?a schema:postalCode "39100" .
}
]]

[QueryGroup="POI"] @collection [[
[QueryItem="poi"]
PREFIX : <http://noi.example.org/ontology/odh#>
PREFIX dc: <http://purl.org/dc/terms/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX xml: <http://www.w3.org/XML/1998/namespace>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obda: <https://w3id.org/obda/vocabulary#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>

SELECT * {
?x a schema:Place ; rdfs:label ?posLabel ; geo:asWKT ?pos; schema:elevation ?posHeight.
}
LIMIT 50
]]

[QueryGroup="Area"] @collection [[
[QueryItem="area"]
PREFIX : <http://noi.example.org/ontology/odh#>
PREFIX dc: <http://purl.org/dc/terms/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX xml: <http://www.w3.org/XML/1998/namespace>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obda: <https://w3id.org/obda/vocabulary#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>

SELECT * WHERE {
?a a schema:AdministrativeArea ; rdfs:label ?name . 
}
]]

[QueryGroup="Quality"] @collection [[
[QueryItem="Pitch not in Campground"]
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX schema: <http://schema.org/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT DISTINCT ?b WHERE {
  ?pitch a schema:CampingPitch ; schema:containedInPlace ?b .
  ?b geo:asWKT ?pos .
    MINUS {
    ?b a schema:Campground
  }
}
]]
