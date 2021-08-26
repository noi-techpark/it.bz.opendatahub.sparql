var queryList = {
	"Tourism": [
		"PREFIX schema: <http://schema.org/>\nPREFIX geo: <http://www.opengis.net/ont/geosparql#>\nPREFIX : <http://noi.example.org/ontology/odh#>\n \nSELECT ?h ?pos ?posLabel\nWHERE {\n ?h a schema:LodgingBusiness ;\n      schema:name ?posLabel ;    \n      geo:defaultGeometry/geo:asWKT ?pos ;\n      schema:geo/schema:elevation ?altitude ;\n      schema:containedInPlace/schema:name \"Kastelruth\"@de .\n \n FILTER (lang(?posLabel) = 'de')\n FILTER (?altitude > 1800)\n}",
		"PREFIX sosa: <http://www.w3.org/ns/sosa/>\nPREFIX : <http://noi.example.org/ontology/odh#>\nPREFIX geo: <http://www.opengis.net/ont/geosparql#>\nPREFIX schema: <http://schema.org/>\nPREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\nPREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\nPREFIX geof: <http://www.opengis.net/def/function/geosparql/>\nPREFIX uom: <http://www.opengis.net/def/uom/OGC/1.0/>\nPREFIX qudt: <http://qudt.org/schema/qudt#>\nPREFIX qudt-unit: <http://qudt.org/vocab/unit#>\n \nSELECT ?nameStat ?posStat ?temp ?t ?nameFood ?tel\nWHERE {\n  ?o  a :LatestObservation;\n      sosa:hasResult ?r;\n      sosa:resultTime ?t;\n      sosa:hasFeatureOfInterest ?f;\n      sosa:observedProperty ?p .\n  ?r qudt:numericValue ?temp ; \n     qudt:unit qudt-unit:DegreeCelsius .\n  FILTER (?temp > 18)\n  ?f a :OutdoorWater ; geo:defaultGeometry/geo:asWKT ?posStat .\n  ?p a :Temperature .\n  # Weather platform\n  ?stat sosa:hosts/sosa:madeObservation ?o.\n  ?stat rdfs:label ?nameStat .\n  # Food establishment\n  ?e a schema:FoodEstablishment;\n     schema:name ?nameFood;\n     schema:telephone ?tel;\n     geo:defaultGeometry/geo:asWKT ?posFood.\n  FILTER(lang(?nameFood) = \"it\")\n  #Spatial correlation between food establishment and weather stations\n  BIND(geof:distance(?posFood, ?posStat, uom:metre) AS ?distanceFoodWeather)\n  FILTER (?distanceFoodWeather < 2000)\n}\n",
		"PREFIX geo: <http://www.opengis.net/ont/geosparql#>\nPREFIX schema: <http://schema.org/>\nPREFIX : <http://noi.example.org/ontology/odh#>\n \nSELECT ?pos ?name\n    (SUM(?numberUnits) AS ?accommodationCount) #Sums all the accommodation units\n    (SUM(?maxPersons) AS ?countMaxPersons) #Sum the hosting capabilities\nWHERE {\n # LodgingBusiness\n ?lb a schema:LodgingBusiness ; \n    schema:name ?name ; \n    geo:defaultGeometry/geo:asWKT ?pos .\n \n # Accommodation\n ?a a schema:Accommodation ;\n    schema:containedInPlace ?lb ; \n    :numberOfUnits ?numberUnits ;\n    schema:occupancy/schema:maxValue ?maxOccupancyPerRoom .\n \n # Computation of maxPersons per accommodation\n BIND (?numberUnits * ?maxOccupancyPerRoom AS ?maxPersons)\n FILTER (lang(?name)='en')\n}\nGROUP BY ?lb ?name ?pos\nORDER BY DESC(?countMaxPersons)\nLIMIT 50\n",
		"PREFIX schema: <http://schema.org/>\nPREFIX geo: <http://www.opengis.net/ont/geosparql#>\nPREFIX : <http://noi.example.org/ontology/odh#>\n \nSELECT ?h ?pos ?posLabel ?altitude\nWHERE {\n  ?h a schema:LodgingBusiness ;\n      schema:name ?posLabel ;      \n      geo:defaultGeometry/geo:asWKT ?pos ;\n      schema:geo/schema:elevation ?altitude ;\n  FILTER (lang(?posLabel) = 'de')\n  FILTER (?altitude > 2500)\n  FILTER REGEX(?posLabel, \"hütte\", \"i\")\n}\n"
	],
	"Environment": [
		"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\nPREFIX sosa: <http://www.w3.org/ns/sosa/>\nPREFIX : <http://noi.example.org/ontology/odh#>\n\nSELECT DISTINCT ?sensor ?sensorLabel ?stationCode (MIN(?resultTime) as ?resultsStart) (MAX(?resultTime) as ?resultsEnd) WHERE {\n  ?observation a sosa:Observation ;\n  \tsosa:observedProperty ?observableProperty ;\n  \tsosa:madeBySensor ?sensor ;\n  \tsosa:resultTime ?resultTime ;\n  \tsosa:hasSimpleResult ?resultValue .\n  ?sensor rdfs:label ?sensorLabel ;\n      \t:hasStationCode ?stationCode .\n  ?observableProperty rdfs:label \"nitrogen-dioxide\"\n}\nGROUP BY ?sensor ?sensorLabel ?stationCode\n",
		"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\nPREFIX sosa: <http://www.w3.org/ns/sosa/>\nPREFIX : <http://noi.example.org/ontology/odh#>\n\nSELECT DISTINCT ?valueBin (COUNT(*) AS ?count) WHERE {\n  ?observation a :LatestObservation ;\n  \tsosa:observedProperty ?observableProperty ;\n  \tsosa:madeBySensor ?sensor ;\n  \tsosa:resultTime ?resultTime ;\n  \tsosa:hasSimpleResult ?resultValue .\n  ?sensor rdfs:label ?sensorLabel .\n  ?observableProperty rdfs:label \"air-temperature\" .\n  BIND (FLOOR(ROUND(?resultValue) / 5) * 5 AS ?valueBin)\n}\nGROUP BY ?valueBin\nORDER BY ?valueBin\n"
	],
	"Mobility": []
}
