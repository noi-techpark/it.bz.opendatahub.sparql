
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


function changeTab(tabNumber) {
	var queryTab01 = document.getElementById('queryTab01');
	var queryTab02 = document.getElementById('queryTab02');
	var queryTab03 = document.getElementById('queryTab03');
	var tab01 = document.getElementById('tab01');
	var tab02 = document.getElementById('tab02');
	var tab03 = document.getElementById('tab03');

	queryTab01.classList.remove('is-active');
	queryTab02.classList.remove('is-active');
	queryTab03.classList.remove('is-active');
	tab01.classList.remove('is-active');
	tab02.classList.remove('is-active');
	tab03.classList.remove('is-active');
	switch (tabNumber) {
		case '01' :
			queryTab01.classList.add('is-active');
			tab01.classList.add('is-active');
			return;
		case '02' :
			queryTab02.classList.add('is-active');
			tab02.classList.add('is-active');
			return;
		case '03' :
			queryTab03.classList.add('is-active');
			tab03.classList.add('is-active');
			return;



	}
	// scrollToElement('#queries-tabs', 600)
}

function runQuery(menu, buttonNumber, output) {
	tab = yasgui.selectTab("");
	switch (menu) {
		case 'Tourism':
			currentQuery = queryList.Tourism[buttonNumber];
			break;
		case 'Environment':
			currentQuery = queryList.Environment[buttonNumber];
			break;
		case 'Mobility':
			currentQuery = queryList.Mobility[buttonNumber];
			break;
	}
	tab.setQuery(currentQuery);
	// tab.query();
	switch (output) {
		case 'table':
			tab.yasr.options.output = "table";
			break;
		case 'leaflet':
			tab.yasr.options.output = "leaflet";
			break;

	}
	scrollToElement('#yasgui', 600);
}
