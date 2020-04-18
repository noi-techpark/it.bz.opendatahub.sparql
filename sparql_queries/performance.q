# Many triple patterns (highly simplifiable)

PREFIX schema: <http://schema.org/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT * WHERE {
  ?h a schema:LodgingBusiness ;
     schema:address ?v1, ?v2, ?v3, ?v4, ?v5, ?v6, ?v7, ?v8, ?v9, ?v10, ?v11, ?v12, ?v13, ?v14, ?v15, ?v16, ?v17, ?v18, ?v19, ?v20,
      ?v21, ?v22, ?v23, ?v24, ?v25, ?v26, ?v27, ?v28, ?v29, ?v30, ?v31, ?v32, ?v33, ?v34, ?v35, ?v36, ?v37, ?v38, ?v39, ?v40
} 
LIMIT 10



