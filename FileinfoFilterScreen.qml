import QtQuick 2.1
import BasicUIControls 1.0;
import qb.components 1.0

Screen {
	id: fileinfoFilterScreen

	property variant defaultRoadArray : [
		"A1", "A2", "A4", "A6", "A7", "A8", "A9", "A10", "A12", "A13",
		"A15", "A16", "A17", "A18", "A20", "A22", "A27", "A28", "A29", "A30",
		"A31", "A32", "A35", "A37", "A38", "A44", "A50", "A58", "A59", "A65",
		"A67", "A73", "A74", "A76", "A77", "A79", "A200", "A325",
		"N3", "N7", "N9", "N11", "N14", "N18", "N30", "N31", "N32", "N33",
		"N35", "N36", "N44", "N46", "N48", "N50", "N57", "N59", "N61", "N65",
		"N99", "N200", "N434", "N915",
		"Alle\nN-wegen"
	]

	function effectiveRoadArray() {
		if (app.fileinfoAvailableRoads && app.fileinfoAvailableRoads.length > 0) {
			return app.fileinfoAvailableRoads;
		}
		return defaultRoadArray;
	}

	screenTitle: qsTr("Filter")
	isSaveCancelDialog: true

	onShown: {
		// Get the correct button indices to set selected state on

		var roadArray = effectiveRoadArray();
		var myFilter = app.fileinfoFilterArray;
		var filterArr = myFilter.split(",");
		var selectedIndexArr = [];

		for (var i = 0; i < filterArr.length; i++) {
			if (filterArr[i] == "N") {
				var index = roadArray.indexOf("Alle\nN-wegen");
			}
			else {
				var index = roadArray.indexOf(filterArr[i]);
			}
			if (index != -1) {
				selectedIndexArr.push(index);
			}
		}

		// Set selected state of buttons
		fileinfoFilterGroup.clearSelectedControls();
		if (selectedIndexArr.length > 0) {
			fileinfoFilterGroup.setSelectedControls(selectedIndexArr);
		}
	}

	onSaved: {
		// Create array string of roads
		var roadArray = effectiveRoadArray();
		var selectedIndexArr = fileinfoFilterGroup.getSelectedControls();
		var filterArr = [];

		for (var i = 0; i < selectedIndexArr.length; i++) {
			var roadName = roadArray[selectedIndexArr[i]];
			if (roadName === "Alle\nN-wegen")
				roadName = "N"; // Driver expects N instead of "Alle\nN-wegen"
			filterArr.push(roadName);
		}
		var myFilterStr = filterArr.toString();
		app.fileinfoFilterArray = myFilterStr;
		app.saveSettings();
		app.updateFileinfoInfo();
	}

	ControlGroup {
		id: fileinfoFilterGroup
		exclusive: false
	}

	GridView {
		id: fileinfoFilterGridView

		model: fileinfoFilterModel
		delegate: FileinfoFilterDelegate {}

		flow: GridView.TopToBottom
		cellWidth: isNxt ? 132 : 106
		cellHeight: isNxt ? 75 : 60
		interactive: true
		flickableDirection: Flickable.VerticalFlick

		anchors {
			fill: parent
			top: parent.top
			left: parent.left
			topMargin: isNxt ? 51 : 41
			leftMargin: isNxt ? 58 : 46
		}
	}

	ListModel {
		id: fileinfoFilterModel

		// Load roads from array
		Component.onCompleted: {
			var roadArray = effectiveRoadArray();
			for (var i = 0; i < roadArray.length; i++) {
				append({roadName: roadArray[i]});
			}
		}
	}

	Rectangle {
		width: isNxt ? 132 : 106
		height: isNxt ? 75 : 60
		color: colors.canvas

		anchors {
			bottom: parent.bottom
			bottomMargin: 14
			right: parent.right
			rightMargin: 12
		}

		StandardButton {
			id: fileinfoFilterClearButton

			anchors {
				top: parent.top
				topMargin: 4
				left: parent.left
				leftMargin: 1
			}

			text: qsTr("Clear")

			onPressed: {
				fileinfoFilterGroup.clearSelectedControls();
			}
		}
	}
}
