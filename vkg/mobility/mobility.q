[QueryItem="station"]
PREFIX : <http://ex.org/suedtirol#>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX sf: <http://www.opengis.net/ont/sf#>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX xml: <http://www.w3.org/XML/1998/namespace>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX obda: <https://w3id.org/obda/vocabulary#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX sosa: <http://www.w3.org/ns/sosa/>
PREFIX vann: <http://purl.org/vocab/vann/>
PREFIX terms: <http://purl.org/dc/terms/>
PREFIX schema: <http://schema.org/>

SELECT * {
?s a :TrafficStation . 
?s rdfs:label ?l .
OPTIONAL {?s geo:defaultGeometry ?g .
?g geo:asWKT ?wkt .}
}

[QueryItem="properties"]
PREFIX : <http://ex.org/suedtirol#>
PREFIX WV: <http://www.wurvoc.org/vocabularies/WV/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX sf: <http://www.opengis.net/ont/sf#>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX xml: <http://www.w3.org/XML/1998/namespace>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX obda: <https://w3id.org/obda/vocabulary#>
PREFIX om-2: <http://www.wurvoc.org/bibliography/om-2/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX sosa: <http://www.w3.org/ns/sosa/>
PREFIX vann: <http://purl.org/vocab/vann/>
PREFIX terms: <http://purl.org/dc/terms/>
PREFIX schema: <http://schema.org/>

SELECT * WHERE {
?p a sosa:ObservableProperty .
#?p rdfs:label ?l . 
?p rdfs:comment ?c.
}

[QueryItem="observation"]
PREFIX : <http://ex.org/suedtirol#>
PREFIX WV: <http://www.wurvoc.org/vocabularies/WV/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX sf: <http://www.opengis.net/ont/sf#>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX xml: <http://www.w3.org/XML/1998/namespace>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX obda: <https://w3id.org/obda/vocabulary#>
PREFIX om-2: <http://www.wurvoc.org/bibliography/om-2/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX sosa: <http://www.w3.org/ns/sosa/>
PREFIX vann: <http://purl.org/vocab/vann/>
PREFIX terms: <http://purl.org/dc/terms/>
PREFIX schema: <http://schema.org/>

SELECT * WHERE {
#?s a sosa:Sensor .
#?s sosa:isHostedBy ?p.
#?p geo:defaultGeometry ?g . ?g geo:asWKT ?wkt .
?s sosa:madeObservation ?o .
?o sosa:hasSimpleResult ?v .
?o sosa:resultTime ?t .
?o sosa:observedProperty ?prop .
?prop rdfs:comment ?pc .
}
LIMIT 100

[QueryItem="road"]
PREFIX : <http://ex.org/suedtirol#>
PREFIX WV: <http://www.wurvoc.org/vocabularies/WV/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX sf: <http://www.opengis.net/ont/sf#>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX xml: <http://www.w3.org/XML/1998/namespace>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX obda: <https://w3id.org/obda/vocabulary#>
PREFIX om-2: <http://www.wurvoc.org/bibliography/om-2/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX sosa: <http://www.w3.org/ns/sosa/>
PREFIX vann: <http://purl.org/vocab/vann/>
PREFIX terms: <http://purl.org/dc/terms/>
PREFIX schema: <http://schema.org/>

SELECT * {
?rs a :RoadSegment ; geo:defaultGeometry ?g . ?g geo:asWKT ?wkt 
}

[QueryItem="host"]
PREFIX : <http://ex.org/suedtirol#>
PREFIX WV: <http://www.wurvoc.org/vocabularies/WV/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX sf: <http://www.opengis.net/ont/sf#>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX xml: <http://www.w3.org/XML/1998/namespace>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX obda: <https://w3id.org/obda/vocabulary#>
PREFIX om-2: <http://www.wurvoc.org/bibliography/om-2/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX sosa: <http://www.w3.org/ns/sosa/>
PREFIX vann: <http://purl.org/vocab/vann/>
PREFIX terms: <http://purl.org/dc/terms/>
PREFIX schema: <http://schema.org/>

SELECT * {
?s1 sosa:isHostedBy ?s2 .
?s1 rdfs:label ?ll ; :hasStationType ?t1.
    ?s1 geo:defaultGeometry [geo:asWKT ?wkt1] .
  ?s2 rdfs:label ?l2 ; :hasStationType ?t2 .
  ?s2 geo:defaultGeometry [geo:asWKT ?wkt2] .
}
LIMIT 100
