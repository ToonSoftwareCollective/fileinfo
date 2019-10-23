import QtQuick 2.1

import qb.components 1.0
import qb.base 1.0

MenuItem {
	id: fileinfoMenu
	label: qsTr("Fileinfo")
	image: "qrc:/tsc/traffic.png"
	weight: isNxt ? 50 : 40

	onClicked: {
		if (app.fileinfoScreen) app.fileinfoScreen.show();
	}
}
