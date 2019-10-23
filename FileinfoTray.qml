import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0

SystrayIcon {
	id: fileinfoSystrayIcon
	visible: true
	posIndex: 9000
	property string objectName: "fileinfoSystray"

	onClicked: {
		if (app.fileinfoScreen) app.fileinfoScreen.show();
	}

	Image {
		id: imgNewMessage
		anchors.centerIn: parent
		source: "qrc:/tsc/fileinfotray.png"
	}
}
