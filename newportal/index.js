$(function () {
    //Clear local storage and session storage data 
    localStorage.clear();
    sessionStorage.clear();

    //Initial tab styling
    $("#choice-option1").css("background-color", "#337ab7");
    $("#choice-option1").css("color", "#fff");
    $("#choice-option2").css("background-color", "#fff");
    $("#choice-option2").css("color", "#337ab7");
})

function queryChoice(choice) {
    //Get the value of the two tabs on click to then decide on styling of the parameters
    qvalue = choice.getAttribute("value");

    //Style accordingly
    if (qvalue == "dataq") {
        $("#choice-option1").css("background-color", "#337ab7");
        $("#choice-option1").css("color", "#fff");
        $("#choice-option2").css("background-color", "#fff");
        $("#choice-option2").css("color", "#337ab7");
        $("#yasgui").show();
    } else if (qvalue == "regular") {
        $("#choice-option2").css("background-color", "#337ab7");
        $("#choice-option2").css("color", "#fff");
        $("#choice-option1").css("background-color", "#fff");
        $("#choice-option1").css("color", "#337ab7");
        $("#yasgui").hide();
    } else {
        //Have a handler in case the value is not dataq or regular
        console.log("Unknown Input!");
    }

}