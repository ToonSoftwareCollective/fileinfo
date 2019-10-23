import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0

App {
	id: fileinfoApp

	property url fullScreenUrl : "FileinfoScreen.qml"
	property url tileUrl : "FileinfoTile.qml"
	property url thumbnailIcon: "qrc:/tsc/traffic.png"
	property url filterScreenUrl : "FileinfoFilterScreen.qml"
	property url fileinfoMenuIconUrl: "qrc:/tsc/traffic.png"
	property url trayUrl : "FileinfoTray.qml";
	property FileinfoFilterScreen fileinfoFilterScreen
	property FileinfoScreen fileinfoScreen

	property string happWeatherUuid;

	// Fileinfo info header information
	property string trafficJams

	// Fileinfo data in XML string format
	property string fileinfoData
	property string fileinfoDataAll
	property string fileinfoDataFiltered
	property variant fileAnwbJSON : {}

	// Fileinfo filter string and filter enabled indicator
	property bool fileinfoFilterEnabled: false
	property string fileinfoFilterArray

	// Fileinfo data for Tile max 3 roads
	property string roadTile1Name
	property int roadTile1NumberOfJams
	property real roadTile1TotalLength
	property bool roadTile1

	property string roadTile2Name
	property int roadTile2NumberOfJams
	property real roadTile2TotalLength
	property bool roadTile2

	property string roadTile3Name
	property int roadTile3NumberOfJams
	property real roadTile3TotalLength
	property bool roadTile3

	property bool fileinfoDataRead: false

	// Fileinfo signals, used to update the listview and filter enabled button
	signal fileinfoUpdated()
	signal fileinfoFilterUpdated()

	FileIO {
		id: fileinfoSettingsFile
		source: "file:///mnt/data/tsc/fileinfo.userSettings.json"
 	}

	// Init the fileinfo app by registering the widgets
	function init() {
		registry.registerWidget("tile", tileUrl, this, null, {thumbLabel: qsTr("Verkeer"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, thumbIconVAlignment: "center"});
		registry.registerWidget("screen", fullScreenUrl, this, "fileinfoScreen");
		registry.registerWidget("screen", filterScreenUrl, this, "fileinfoFilterScreen");
		registry.registerWidget("menuItem", null, this, null, {objectName: "fileinfoMenuItem", label: qsTr("Fileinfo"), image: fileinfoMenuIconUrl, screenUrl: fullScreenUrl, weight: 120});
		registry.registerWidget("systrayIcon", trayUrl, this, "fileinfoTray");
	}

	// Parse the Fileinfo XML message and signal the FileinfoScreen. If there is no info between the <meldingen></meldingen> tags, empty the fileinfoData string

	function parseFileinfo(fileTxt) {

		fileAnwbJSON = JSON.parse(fileTxt); 
		fileinfoDataRead = true;

			// clear Tile
		roadTile1Name = "";
		roadTile1NumberOfJams = 0;
		roadTile1TotalLength = 0;
		roadTile1 = false;

		roadTile2Name = "";
		roadTile2NumberOfJams = 0;
		roadTile2TotalLength = 0;
		roadTile2 = false;

		roadTile3Name = "";
		roadTile3NumberOfJams = 0;
		roadTile3TotalLength = 0;
		roadTile3 = false;

			// create filtered and normal set of traffic jams

		var length = 0;
		var delay = 0;
		var msgFilter = "";
		var msgWegNr = "-";
		var searchmsgWegNr = "-";
		var myFilter = fileinfoFilterArray;
		var filterArr = myFilter.split(",");

		fileinfoDataFiltered = "<meldingen>";
		fileinfoDataAll = "<meldingen>";

		var i = fileAnwbJSON["roadEntries"].length;
		for (var i = 0; i < fileAnwbJSON["roadEntries"].length; i++) {	

			msgWegNr= fileAnwbJSON["roadEntries"][i]["road"];
			searchmsgWegNr= msgWegNr;
				// 	lookup roadnr in filter array
			if (msgWegNr.substring(0,1) == "N") {
				searchmsgWegNr = "N"
			}
			var index = filterArr.indexOf(searchmsgWegNr);
			for (var j = 0; j < fileAnwbJSON["roadEntries"][i]["events"]["trafficJams"].length; j++) {	
					// 	get length if supplied
				if (fileAnwbJSON["roadEntries"][i]["events"]["trafficJams"][j]["distance"]) {
					length = parseInt(fileAnwbJSON["roadEntries"][i]["events"]["trafficJams"][j]["distance"]) / 1000;
				} else {
					length = 0;
				}
				if (roadTile2Name == "") {
					roadTile2Name = msgWegNr;
					roadTile2NumberOfJams = 1;
					roadTile2TotalLength = length;
					roadTile2 = true;
				} else {
					if (roadTile2Name == msgWegNr) {
						roadTile2NumberOfJams = roadTile2NumberOfJams + 1;
						roadTile2TotalLength = Math.round((roadTile2TotalLength + length) * 100) / 100;
					} else {
						if (roadTile1Name == "") {
							roadTile1Name = msgWegNr;
							roadTile1NumberOfJams = 1;
							roadTile1TotalLength = length;
							roadTile1 = true;
						} else {
							if (roadTile1Name == msgWegNr) {
								roadTile1NumberOfJams = roadTile1NumberOfJams + 1;
								roadTile1TotalLength = Math.round((roadTile1TotalLength + length) * 100) / 100;
							} else {
								if (roadTile3Name == "") {
									roadTile3Name = msgWegNr;
									roadTile3NumberOfJams = 1;
									roadTile3TotalLength = length;
									roadTile3 = true;
								} else {
									if (roadTile3Name == msgWegNr) {
									roadTile3NumberOfJams = roadTile3NumberOfJams + 1;
									roadTile3TotalLength = Math.round((roadTile3TotalLength + length) * 100) / 100;
									}
								}
							}
						}
					}
				}
				delay = 0;
				if (fileAnwbJSON["roadEntries"][i]["events"]["trafficJams"][j]["delay"]) {
					delay = parseInt(fileAnwbJSON["roadEntries"][i]["events"]["trafficJams"][j]["delay"]);
				}
				if (index !== -1) {
					fileinfoDataFiltered = fileinfoDataFiltered + "<melding><wegnr>" + fileAnwbJSON["roadEntries"][i]["road"] + "</wegnr><description>" + fileAnwbJSON["roadEntries"][i]["events"]["trafficJams"][j]["description"] + "</description><afstand>" + length + "</afstand><vertraging>" + delay + "</vertraging></melding>";
				}
				fileinfoDataAll = fileinfoDataAll + "<melding><wegnr>" + fileAnwbJSON["roadEntries"][i]["road"] + "</wegnr><description>" + fileAnwbJSON["roadEntries"][i]["events"]["trafficJams"][j]["description"] + "</description><afstand>" + length + "</afstand><vertraging>" + delay + "</vertraging></melding>";
			}
		}
		
		fileinfoDataFiltered = fileinfoDataFiltered  + "</meldingen>";
		fileinfoDataAll = fileinfoDataAll  + "</meldingen>";

			//actual data to be displayed on screen

		if (fileinfoFilterEnabled) {
			fileinfoData = fileinfoDataFiltered;
		} else {
			fileinfoData = fileinfoDataAll;
		}
		fileinfoUpdated();
	}

	function saveSettings() {

		// save user settings
		var tmpfileinfoFilterEnabled = "";
		if (fileinfoFilterEnabled == true) {
			tmpfileinfoFilterEnabled = "Yes";
		} else {
			tmpfileinfoFilterEnabled = "No";
		}

 		var tmpUserSettingsJson = {
			"roadFilter": fileinfoFilterArray,
			"filterEnabled": tmpfileinfoFilterEnabled 
		}

  		var doc3 = new XMLHttpRequest();
   		doc3.open("PUT", "file:///mnt/data/tsc/fileinfo.userSettings.json");
   		doc3.send(JSON.stringify(tmpUserSettingsJson ));

	}

	function updateFileinfoInfo() {
		
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState == 4) {
				if (xmlhttp.status == 200) {
					parseFileinfo(xmlhttp.responseText);
				}
			}
		}
		xmlhttp.open("GET", "https://www.anwb.nl/feeds/gethf", true);
		xmlhttp.send();
	}

	Component.onCompleted: {

			// read saved filter and start timer

		try {
			var fileinfoSettingsJson = JSON.parse(fileinfoSettingsFile.read());
			fileinfoFilterArray = fileinfoSettingsJson['roadFilter'];
			if (fileinfoSettingsJson['filterEnabled'] == "Yes") {
				fileinfoFilterEnabled = true
			} else {
				fileinfoFilterEnabled = false
			}		
		} catch(e) {
		}
		datetimeTimerFiles.running = true;
	}

	Timer {
		id: datetimeTimerFiles
		interval: 600000			//update every 10 mins
		triggeredOnStart: true
		running: false
		repeat: true
		onTriggered: updateFileinfoInfo()
	}
}
