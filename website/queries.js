var queryList = {
	"Tourism": [
		{
			"query": "PREFIX schema: <http://schema.org/>\nPREFIX geo: <http://www.opengis.net/ont/geosparql#>\nPREFIX : <http://noi.example.org/ontology/odh#>\n \nSELECT ?h ?pos ?posLabel\nWHERE {\n ?h a schema:LodgingBusiness ;\n      schema:name ?posLabel ;    \n      geo:defaultGeometry/geo:asWKT ?pos ;\n      schema:geo/schema:elevation ?altitude ;\n      schema:containedInPlace/schema:name \"Kastelruth\"@de .\n \n FILTER (lang(?posLabel) = 'de')\n FILTER (?altitude > 1800)\n}",
			"tabName": "Businesses",
			"tabId": "bs",
			"output": "leaflet",
		},
		{
			"query": "PREFIX sosa: <http://www.w3.org/ns/sosa/>\nPREFIX : <http://noi.example.org/ontology/odh#>\nPREFIX geo: <http://www.opengis.net/ont/geosparql#>\nPREFIX schema: <http://schema.org/>\nPREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\nPREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\nPREFIX geof: <http://www.opengis.net/def/function/geosparql/>\nPREFIX uom: <http://www.opengis.net/def/uom/OGC/1.0/>\nPREFIX qudt: <http://qudt.org/schema/qudt#>\nPREFIX qudt-unit: <http://qudt.org/vocab/unit#>\n \nSELECT ?nameStat ?posStat ?temp ?t ?nameFood ?tel\nWHERE {\n  ?o  a :LatestObservation;\n      sosa:hasResult ?r;\n      sosa:resultTime ?t;\n      sosa:hasFeatureOfInterest ?f;\n      sosa:observedProperty ?p .\n  ?r qudt:numericValue ?temp ; \n     qudt:unit qudt-unit:DegreeCelsius .\n  FILTER (?temp > 18)\n  ?f a :OutdoorWater ; geo:defaultGeometry/geo:asWKT ?posStat .\n  ?p a :Temperature .\n  # Weather platform\n  ?stat sosa:hosts/sosa:madeObservation ?o.\n  ?stat rdfs:label ?nameStat .\n  # Food establishment\n  ?e a schema:FoodEstablishment;\n     schema:name ?nameFood;\n     schema:telephone ?tel;\n     geo:defaultGeometry/geo:asWKT ?posFood.\n  FILTER(lang(?nameFood) = \"it\")\n  #Spatial correlation between food establishment and weather stations\n  BIND(geof:distance(?posFood, ?posStat, uom:metre) AS ?distanceFoodWeather)\n  FILTER (?distanceFoodWeather < 2000)\n}\n",
			"tabName": "Restaurants",
			"tabId": "rt",
			"output": "leaflet",
		},
		{
			"query": "PREFIX geo: <http://www.opengis.net/ont/geosparql#>\nPREFIX schema: <http://schema.org/>\nPREFIX : <http://noi.example.org/ontology/odh#>\n \nSELECT ?pos ?name\n    (SUM(?numberUnits) AS ?accommodationCount) #Sums all the accommodation units\n    (SUM(?maxPersons) AS ?countMaxPersons) #Sum the hosting capabilities\nWHERE {\n # LodgingBusiness\n ?lb a schema:LodgingBusiness ; \n    schema:name ?name ; \n    geo:defaultGeometry/geo:asWKT ?pos .\n \n # Accommodation\n ?a a schema:Accommodation ;\n    schema:containedInPlace ?lb ; \n    :numberOfUnits ?numberUnits ;\n    schema:occupancy/schema:maxValue ?maxOccupancyPerRoom .\n \n # Computation of maxPersons per accommodation\n BIND (?numberUnits * ?maxOccupancyPerRoom AS ?maxPersons)\n FILTER (lang(?name)='en')\n}\nGROUP BY ?lb ?name ?pos\nORDER BY DESC(?countMaxPersons)\nLIMIT 50\n",
			"tabName": "Facilities",
			"tabId": "fc",
			"output": "leaflet",
		},
		{
			"query": "PREFIX schema: <http://schema.org/>\nPREFIX geo: <http://www.opengis.net/ont/geosparql#>\nPREFIX : <http://noi.example.org/ontology/odh#>\n \nSELECT ?h ?pos ?posLabel ?altitude\nWHERE {\n  ?h a schema:LodgingBusiness ;\n      schema:name ?posLabel ;      \n      geo:defaultGeometry/geo:asWKT ?pos ;\n      schema:geo/schema:elevation ?altitude ;\n  FILTER (lang(?posLabel) = 'de')\n  FILTER (?altitude > 2500)\n  FILTER REGEX(?posLabel, \"hütte\", \"i\")\n}\n",
			"tabName": "Mountain",
			"tabId": "mt",
			"output": "leaflet",
		}
	],
	"Environment": [
		{
			"query": "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" +
				"PREFIX sosa: <http://www.w3.org/ns/sosa/>\n" +
				"PREFIX : <http://noi.example.org/ontology/odh#>\n" +
				"\n" +
				"SELECT DISTINCT ?station ?stationLabel ?stationCode (MIN(?resultTime) as ?resultsStart) (MAX(?resultTime) as ?resultsEnd) WHERE {\n" +
				"  ?observation a sosa:Observation ;\n" +
				"  \tsosa:observedProperty ?observableProperty ;\n" +
				"  \tsosa:madeBySensor ?sensor ;\n" +
				"  \tsosa:resultTime ?resultTime ;\n" +
				"  \tsosa:hasResult ?resultValue .\n" +
				" ?sensor sosa:isHostedBy ?station .\n" +
				"    ?station  rdfs:label ?stationLabel ;\n" +
				"      \t:hasStationCode ?stationCode .\n" +
				"  ?observableProperty rdfs:label \"nitrogen-dioxide\"\n" +
				"}\n" +
				"GROUP BY ?station ?stationLabel ?stationCode\n" +
				"\n",
			"tabName": "Sensors",
			"tabId": "sn",
			"output": "gchart",
			// "chartConfig": {
			// 	"chartType": "LineChart",
			// 	"isDefaultVisualization": false,
			// 	"state": {},
			// 	"view": {
			// 		"rows": null,
			// 		"columns": [
			// 			0,
			// 			{
			// 				"label": "sensorLabel",
			// 				"properties": {"role": "annotation"},
			// 				"sourceColumn": 1
			// 			},
			// 			{
			// 				"label": "stationCode",
			// 				"properties": {"role": "annotationText"},
			// 				"sourceColumn": 2
			// 			},
			// 			3,
			// 			4],
			// 	},
			// 	"options": {
			// 		booleanRole: "certainty",
			// 		curveType: "",
			// 		legacyScatterChartLabels: true,
			// 		legend: "right",
			// 		lineWidth: 2,
			// 		annotations: {domain: {style: "line"}},
			// 		hAxis: {
			// 			maxValue: null,
			// 			minValue: null,
			// 			useFormatFromData: true,
			// 			viewWindow: null,
			// 			viewWindowMode: null,
			// 		},
			// 		vAxes: [
			// 			{
			// 				maxValue: null,
			// 				minValue: null,
			// 				useFormatFromData: true,
			// 				viewWindow: {max: null, min: null},
			// 			},
			// 			{
			// 				maxValue: null,
			// 				minValue: null,
			// 				useFormatFromData: true,
			// 				viewWindow: {max: null, min: null},
			// 			},
			// 		],
			// 	},
			// },
		},
		{
			"query": "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" +
				"PREFIX sosa: <http://www.w3.org/ns/sosa/>\n" +
				"PREFIX : <http://noi.example.org/ontology/odh#>\n" +
				"PREFIX qudt: <http://qudt.org/schema/qudt#>\n" +
				"\n" +
				"SELECT DISTINCT ?valueBin (COUNT(*) AS ?count) WHERE {\n" +
				"  ?observation a :LatestObservation ;\n" +
				"  \tsosa:observedProperty ?observableProperty ;\n" +
				"  \tsosa:madeBySensor ?sensor ;\n" +
				"  \tsosa:resultTime ?resultTime ;\n" +
				"  \tsosa:hasResult/qudt:numericValue ?resultValue .\n" +
				"  ?observableProperty rdfs:label \"air-temperature\" .\n" +
				"  BIND (FLOOR(ROUND(?resultValue) / 5) * 5 AS ?valueBin)\n" +
				"}\n" +
				"GROUP BY ?valueBin\n" +
				"ORDER BY ?valueBin\n" +
				"\n",
			"tabName": "Temperature",
			"tabId": "tp",
			"output": "gchart",
			// "chartType": "Histogram",
		}
	],
	"Mobility": []
}
