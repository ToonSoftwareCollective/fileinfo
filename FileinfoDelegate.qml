import QtQuick 2.1
import qb.components 1.0

Rectangle {

	// Create the correct jam length string
	function getLength () {
		return afstand.toString() + " km, ";
	}

	// Create the delay in seconds to string
	function getDelay () {
		var minutes = parseInt(vertraging) / 60;
		return minutes.toString() + " min vertraging"
	}

	width: isNxt ? 870 : 646
	height: isNxt ? 94 : 73
	color: colors.background

	Text {
		id: roadLabel
		x: 10
		anchors.baseline: parent.top
		anchors.baselineOffset: isNxt ? 30 : 24
		text: wegnr
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 22 : 18
	}

	Text {
		anchors.right: vertragingLabel.left
		anchors.rightMargin: 10
		anchors.bottom: roadLabel.bottom
		text: getLength()
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 22 : 18
	}

	Text {
		id: vertragingLabel
		anchors.baseline: parent.top
		anchors.baselineOffset: isNxt ? 30 : 24
		anchors.right: parent.right
		anchors.rightMargin: 10
		text: getDelay()
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 22 : 18
	}

	Text {
		id:oorzaak
		x: 10
		anchors.baseline: parent.top
		anchors.baselineOffset: isNxt ? 54 : 43
		width: isNxt ? parent.width - 125 : parent.width - 100
		text: description
		wrapMode: Text.WordWrap
		maximumLineCount: 2
		elide: Text.ElideRight
		lineHeight: 0.8
		font.family: qfont.italic.name
		font.pixelSize: isNxt ? 20 : 16
	}
}
