
var action;


      // specify id of element and optional scroll speed as arguments
      var scrollToElement = function(el, ms){
	  clearTimeout(action);
        var speed = (ms) ? ms : 600;
        $('html,body').animate({
            scrollTop: $(el).offset().top
        }, speed);
		
		
    }
	
	// 
	
	var animateButton = function(){

	action = setTimeout(function() {

	
    $(".yasqe_queryButton").fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100);

  }, 600);
  
   
      
    }
	
	// open and select tab specifing id of element and optional scroll speed as arguments
	var openTab = function(el){
	
		oldTab= yasgui.tabs[el];
		//check if there is already a tab open for this query
		if (!oldTab) {
		yasgui.addTab(el);
		} 
		
		return yasgui.selectTab(el);
	}
	



      function playground() {
		
		tab = openTab("pl");
		tab.rename("Playground");
		
        playgroundQuery = `PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
		PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
		SELECT * WHERE {
		  ?sub ?pred ?obj .
		} 
		LIMIT 10
        `
		
        tab.setQuery(playgroundQuery);
    
        tab.yasr.options.output = "table";
		$("button.yasr_btn.select_table").click();
		
		scrollToElement('#yasgui', 600);
		if (tab.yasr.somethingDrawn()) {
		// query to override the results 
		tab.query();
		} else {
		tab.yasr.warn("Press the play button to test the query.")
		animateButton();
		}
		
        
        
		
		
      }



      function lodging() {

		tab = openTab("ld");
		tab.rename("Lodging");
        lodgingBusinesses = `PREFIX schema: <http://schema.org/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX : <http://noi.example.org/ontology/odh#>

SELECT ?h ?pos ?posLabel ?posColor
WHERE {
  ?h a schema:LodgingBusiness ;
     geo:defaultGeometry/geo:asWKT ?pos ;
     schema:name ?posLabel .
  #?h schema:containedInPlace/schema:name "Bozen"@de . # Uncomment for restricting to a municipality
  FILTER (lang(?posLabel) = 'de')

  # Colors
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
}
LIMIT 500
        `
        tab.setQuery(lodgingBusinesses);

		
		tab.yasr.options.output = "leaflet";
		$("button.yasr_btn.select_leaflet").click();
		
		scrollToElement('#yasgui', 600);
		if (tab.yasr.somethingDrawn()) {
		// query to override the results 
		tab.query()
		} else {
		tab.yasr.warn("Press the play button to test the query.");
		animateButton();
		}
		
        
      }