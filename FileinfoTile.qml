import QtQuick 2.1
import qb.components 1.0

Tile {
	id: fileinfoTile

	onClicked: {
		if (app.fileinfoScreen) app.fileinfoScreen.show();
	}

	Text {
		id: roadTile1NameLabel
		text: app.roadTile1Name
		anchors {
			top: parent.top
			topMargin: -10
			left: parent.left
			leftMargin: 10
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 62 : 50
		}
		color: colors.waTileTextColor
        	visible: app.roadTile1
	}



	Text {
		id: roadTile1NumberLabel
		text: app.roadTile1NumberOfJams + " file(s)"
		anchors {
			top: roadTile1NameLabel.top
			topMargin: 10
			left: roadTile1NameLabel.left
			leftMargin: isNxt ? 162 : 130
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: colors.clockTileColor
        	visible: app.roadTile1
	}

	Text {
		id: roadTile1LengthLabel
		text: app.roadTile1TotalLength+ " km"
		anchors {
			top: roadTile1NameLabel.top
			topMargin: isNxt ? 40 : 32
			left: roadTile1NameLabel.left
			leftMargin: isNxt ? 162 : 130
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: colors.clockTileColor
        	visible: app.roadTile1
	}


	Text {
		id: roadTile2NameLabel
		text: app.roadTile2Name
		anchors {
			top: roadTile1NameLabel.bottom
			topMargin: -18
			left: parent.left
			leftMargin: 10
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 62 : 50
		}
		color: colors.waTileTextColor
        	visible: app.roadTile2
	}



	Text {
		id: roadTile2NumberLabel
		text: app.roadTile2NumberOfJams + " file(s)"
		anchors {
			top: roadTile2NameLabel.top
			topMargin: 10
			left: roadTile2NameLabel.left
			leftMargin: isNxt ? 162 : 130
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: colors.clockTileColor
        	visible: app.roadTile2
	}

	Text {
		id: roadTile2LengthLabel
		text: app.roadTile2TotalLength+ " km"
		anchors {
			top: roadTile2NameLabel.top
			topMargin: isNxt ? 40 : 32
			left: roadTile2NameLabel.left
			leftMargin: isNxt ? 162 : 130
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20

		}
		color: colors.clockTileColor
        	visible: app.roadTile2
	}



	Text {
		id: roadTile3NameLabel
		text: app.roadTile3Name
		anchors {
			top: roadTile2NameLabel.bottom
			topMargin: -18
			left: parent.left
			leftMargin: 10
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 62 : 50
		}
		color: colors.waTileTextColor
        	visible: app.roadTile3
	}



	Text {
		id: roadTile3NumberLabel
		text: app.roadTile3NumberOfJams + " file(s)"
		anchors {
			top: roadTile3NameLabel.top
			topMargin: 10
			left: roadTile3NameLabel.left
			leftMargin: isNxt ? 162 : 130

		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: colors.clockTileColor
        	visible: app.roadTile3
	}

	Text {
		id: roadTile3LengthLabel
		text: app.roadTile3TotalLength + " km"
		anchors {
			top: roadTile3NameLabel.top
			topMargin: isNxt ? 40 : 32
			left: roadTile3NameLabel.left
			leftMargin: isNxt ? 162 : 130

		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: colors.clockTileColor
        	visible: app.roadTile3
	}
}
