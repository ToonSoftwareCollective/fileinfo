import QtQuick 2.1
import BasicUIControls 1.0;
import qb.components 1.0

Screen {
	id: fileinfoFilterScreen

	property variant roadArray : ["A1", "A2", "A4", "A5", "A6", "A7", "A8", "A9", "A10", "A12", "A13", "A15", "A16", "A17", "A18", "A20", "A22", "A27", "A28", "A29", "A30", "A31", "A32", "A35", "A37", "A38", "A44", "A50", "A58", "A59", "A65", "A67", "A73", "A74", "A76", "A77", "A79", "A200", "A325", "Alle\nN-wegen"]

	screenTitle: qsTr("Filter")
	isSaveCancelDialog: true

	onShown: {
		// Get the correct button indices to set selected state on

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

		interactive: false
		flow: GridView.TopToBottom
		cellWidth: isNxt ? 132 : 106
		cellHeight: isNxt ? 75 : 60

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
