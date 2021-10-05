var queryList = {
	"Tourism": [
		{
			"query": "PREFIX schema: <http://schema.org/>\nPREFIX geo: <http://www.opengis.net/ont/geosparql#>\nPREFIX : <http://noi.example.org/ontology/odh#>\n \nSELECT ?h ?pos (CONCAT(?hName, ' (',str(?altitude), ' m)') AS ?posLabel)\nWHERE {\n ?h a schema:LodgingBusiness ;\n      schema:name ?hName ;    \n      geo:defaultGeometry/geo:asWKT ?pos ;\n      schema:geo/schema:elevation ?altitude ;\n      schema:containedInPlace/schema:name \"Kastelruth\"@de .\n \n FILTER (lang(?hName) = 'de')\n FILTER (?altitude > 1800)\n}"
			,
			"tabName": "Lodging businesses",
			"tabId": "bs",
			"output": "leaflet",
		},
		{
			"query": "PREFIX sosa: <http://www.w3.org/ns/sosa/>\nPREFIX : <http://noi.example.org/ontology/odh#>\nPREFIX geo: <http://www.opengis.net/ont/geosparql#>\nPREFIX schema: <http://schema.org/>\nPREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\nPREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\nPREFIX geof: <http://www.opengis.net/def/function/geosparql/>\nPREFIX uom: <http://www.opengis.net/def/uom/OGC/1.0/>\nPREFIX qudt: <http://qudt.org/schema/qudt#>\nPREFIX qudt-unit: <http://qudt.org/vocab/unit#>\n \nSELECT ?posStat (CONCAT(?statName, ' ', str(?temp), '°C') AS ?posStatLabel) ?temp ?t ?posFood (\"jet,0.3\" AS ?posFoodColor) (CONCAT(?nameFood, ' ', ?tel) AS ?posFoodLabel)\nWHERE {\n  ?o  a :LatestObservation;\n      sosa:hasResult ?r;\n      sosa:resultTime ?t;\n      sosa:hasFeatureOfInterest ?f;\n      sosa:observedProperty ?p .\n  ?r qudt:numericValue ?temp ; \n     qudt:unit qudt-unit:DegreeCelsius .\n  FILTER (?temp > 18)\n  ?f a :OutdoorWater ; geo:defaultGeometry/geo:asWKT ?posStat .\n  ?p a :Temperature .\n  # Weather platform\n  ?stat sosa:hosts/sosa:madeObservation ?o.\n  ?stat rdfs:label ?statName .\n  # Food establishment\n  ?e a schema:FoodEstablishment;\n     schema:name ?nameFood;\n     schema:telephone ?tel;\n     geo:defaultGeometry/geo:asWKT ?posFood.\n  FILTER(lang(?nameFood) = \"it\")\n  #Spatial correlation between food establishment and weather stations\n  BIND(geof:distance(?posFood, ?posStat, uom:metre) AS ?distanceFoodWeather)\n  FILTER (?distanceFoodWeather < 2000)\n}\n"
			,
			"tabName": "Food establishments",
			"tabId": "rt",
			"output": "leaflet",
		},
		{
			"query": "PREFIX geo: <http://www.opengis.net/ont/geosparql#>\nPREFIX schema: <http://schema.org/>\nPREFIX : <http://noi.example.org/ontology/odh#>\n \nSELECT ?pos\n    (SUM(?numberUnits) AS ?accommodationCount) #Sums all the accommodation units\n    (SUM(?maxPersons) AS ?countMaxPersons) #Sum the hosting capabilities\n    (CONCAT(?lbName, ': ', str(?accommodationCount), ' accommodations, max ', str(?countMaxPersons), ' guests') AS ?posLabel)\nWHERE {\n # LodgingBusiness\n ?lb a schema:LodgingBusiness ; \n    schema:name ?lbName ; \n    geo:defaultGeometry/geo:asWKT ?pos .\n \n # Accommodation\n ?a a schema:Accommodation ;\n    schema:containedInPlace ?lb ; \n    :numberOfUnits ?numberUnits ;\n    schema:occupancy/schema:maxValue ?maxOccupancyPerRoom .\n \n # Computation of maxPersons per accommodation\n BIND (?numberUnits * ?maxOccupancyPerRoom AS ?maxPersons)\n FILTER (lang(?lbName)='en')\n}\nGROUP BY ?lb ?lbName ?pos\nORDER BY DESC(?countMaxPersons)\nLIMIT 50\n"
			,
			"tabName": "Accommodation facilities",
			"tabId": "fc",
			"output": "leaflet",
		},
		{
			"query": "PREFIX schema: <http://schema.org/>\nPREFIX geo: <http://www.opengis.net/ont/geosparql#>\nPREFIX : <http://noi.example.org/ontology/odh#>\n \nSELECT ?h ?pos (CONCAT(?hName, ' (', str(?altitude), ' m)') AS ?posLabel) ?altitude\nWHERE {\n  ?h a schema:LodgingBusiness ;\n      schema:name ?hName ;      \n      geo:defaultGeometry/geo:asWKT ?pos ;\n      schema:geo/schema:elevation ?altitude ;\n  FILTER (lang(?hName) = 'de')\n  FILTER (?altitude > 2500)\n  FILTER REGEX(?hName, \"hütte\", \"i\")\n}",
			"tabName": "Mountain shelters",
			"tabId": "mt",
			"output": "leaflet",
		}
	],
	"Environment": [
		{
			"query": "PREFIX sosa: <http://www.w3.org/ns/sosa/>\n" +
				"PREFIX : <http://noi.example.org/ontology/odh#>\n" +
				"PREFIX schema: <http://schema.org/>\n" +
				"\n" +
				"SELECT DISTINCT ?station ?stationLabel  (MIN(?resultTime) as ?resultsStart) (MAX(?resultTime) as ?resultsEnd) WHERE {\n" +
				"  ?observation a :HistoricalObservation ;\n" +
				"  \tsosa:observedProperty [a :NitrogenDioxideConcentration ] ;\n" +
				"  \tsosa:madeBySensor/sosa:isHostedBy ?station ;\n" +
				"  \tsosa:resultTime ?resultTime ;\n" +
				"  \tsosa:hasResult ?resultValue .\n" +
				"  \t?station  schema:name ?stationLabel .\n" +
				"}\n" +
				"GROUP BY ?station ?stationLabel\n" +
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
		}
	],
	"Mobility": [],
	"Temperature": [
		`PREFIX sosa: <http://www.w3.org/ns/sosa/>
		PREFIX : <http://noi.example.org/ontology/odh#>
		PREFIX qudt: <http://qudt.org/schema/qudt#>
		PREFIX schema: <http://schema.org/>

		SELECT DISTINCT ?resultValue WHERE {
			?observation a :LatestObservation ;
				sosa:observedProperty [a :AirTemperature ] ;
				sosa:madeBySensor/sosa:isHostedBy ?station ;
				sosa:resultTime ?resultTime ;
				sosa:hasResult/qudt:numericValue ?resultValue .
			?station schema:name ?stationLabel .
		}`,
		`PREFIX sosa: <http://www.w3.org/ns/sosa/>
PREFIX : <http://noi.example.org/ontology/odh#>
PREFIX qudt: <http://qudt.org/schema/qudt#>
PREFIX schema: <http://schema.org/>

SELECT DISTINCT ?sensor ?sensorLabel ?resultValue WHERE {
  ?observation a :LatestObservation ;
    sosa:observedProperty [a :AirTemperature ] ;
      sosa:madeBySensor/sosa:isHostedBy ?station ;
      sosa:hasResult/qudt:numericValue ?resultValue .
  ?station schema:name ?stationLabel .
  FILTER (?stationLabel = "Bolzano")
}`

	]

}
