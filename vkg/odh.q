[QueryItem="Star"]
PREFIX schema: <http://schema.org/>

SELECT * {
 ?s ?p ?o .
}
LIMIT 100

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

[QueryItem="lodging-st-biggest"]
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX schema: <http://schema.org/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX : <http://noi.example.org/ontology/odh#>

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

[QueryItem="lodging-without-accommodation"]
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX schema: <http://schema.org/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX : <http://noi.example.org/ontology/odh#>

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

[QueryItem="lodging-not-in-st"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT ?h ?pos ?posLabel WHERE {
  ?h a schema:LodgingBusiness ; geo:asWKT ?pos ; schema:name ?posLabel ; schema:address ?a .
  ?a schema:postalCode ?zip .
  FILTER (lang(?posLabel) = 'de').
  FILTER regex(?zip, '^(?!39+)', 'i').
}

[QueryItem="lodging-not-in-st-clean"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT ?h ?pos ?posLabel WHERE {
  ?h a schema:LodgingBusiness ; geo:asWKT ?pos ; schema:name ?posLabel ; schema:address ?a .
  ?a schema:postalCode ?zip .
  FILTER (lang(?posLabel) = 'de').
  FILTER regex(?zip, '^(?!39+)', 'i').
  FILTER regex(?zip, '^(?!\\s*$).+', 'i').
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

[QueryItem="Event"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>

SELECT * WHERE {
  ?event a schema:Event ; schema:description ?desc ; schema:location ?location .
  ?location schema:containedInPlace ?place ; schema:name ?name .
  FILTER(langMatches(lang(?desc), 'de'))
}

[QueryItem="Event contact person"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>

SELECT * WHERE {
  ?contactP a schema:Person ; schema:familyName ?surname ; schema:givenName ?name ; schema:email ?email ; schema:telephone ?telNr ; schema:worksFor ?company .
  ?company schema:name ?cname .
}

[QueryItem="Meeting Rooms"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>

SELECT * WHERE {

  ?meetingRoom a schema:MeetingRoom ; schema:name ?name .
}
ORDER BY ?name

[QueryItem="Test"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
SELECT ?h ?pos ?posLabel ?posColor WHERE {
  ?h a schema:LodgingBusiness ; geo:asWKT ?pos ; schema:name ?posLabel ; schema:address ?a .
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
  ?a schema:postalCode "39100" .
  FILTER (lang(?posLabel) = 'de')
}
LIMIT 500

[QueryItem="Outside of ST"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT ?h ?pos ?posLabel WHERE {
  ?h a schema:LodgingBusiness ; geo:asWKT ?pos ; schema:name ?posLabel ; schema:address ?a .
  ?a schema:postalCode ?zip .
  FILTER (lang(?posLabel) = 'de').
  FILTER regex(?zip, '^(?!39+)', 'i').
}

[QueryItem="Outside of ST w/ ZIP"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT ?h ?pos ?posLabel WHERE {
  ?h a schema:LodgingBusiness ; geo:asWKT ?pos ; schema:name ?posLabel ; schema:address ?a .
  ?a schema:postalCode ?zip .
  FILTER (lang(?posLabel) = 'de').
  FILTER regex(?zip, '^(?!39+)', 'i').
  FILTER regex(?zip, '^(?!\\s*$).+', 'i').
}

[QueryItem="Outside of ST bounding box"]
PREFIX my: <http://example.org/ApplicationSchema#>
PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX geof: <http://www.opengis.net/def/function/geosparql/>

SELECT ?h WHERE {
  ?h a schema:LodgingBusiness ; schema:geo [ schema:latitude ?lat ; schema:longitude ?long ] .
  FILTER (?lat < 46.2198 || ?lat > 47.0921 || ?long < 10.3818 || ?long > 12.4779) .
}

[QueryGroup="ski"] @collection [[
[QueryItem="SkiResort"]
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
?s a schema:SkiResort ; rdfs:label ?name ; geo:asWKT ?pos ; schema:elevation ?el ; schema:image ?img ; schema:isPartOf ?skiRegion. ?skiRegion a :SkiRegion .?skiRegion rdfs:label ?regionName.
# ?s schema:isPartOf ?area. ?area a schema:AdministrativeArea ; rdfs:label ?areaName .
  bind(concat('<h3>',str(?name), #?regionName,
' </h3>',
      #        '<a href="', str(?img), '>',
      '<img src="',str(?img), '" height="300" width="300">'
    #  '</a>'
    ) as ?posLabel)
#  bind(strdt(?lex,rdf:HTML) as ?widget)
}
]]

[QueryGroup="ActivityType"] @collection [[
[QueryItem="activityType"]
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
?a a :Activity ; :activityType ?t .
}
]]

[QueryGroup="Wine"] @collection [[
[QueryItem="wine"]
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
?wine a :Wine.
}

[QueryItem="wineAward"]
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
?wine a :Wine ; :wineVintageYear ?vintage ; rdfs:label ?name ; :receivesWineAward ?aw.
}
]]
