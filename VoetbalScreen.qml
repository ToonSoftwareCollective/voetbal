import QtQuick 2.1
import qb.components 1.0

Screen {
	id: voetbalScreen
	screenTitle: "Voetbal"
	
	onShown: {
		console.log("voetbal: VoetbalScreen.onShown() called")
		screenStateController.screenColorDimmedIsReachable = false
	}

	onHidden: {
		console.log("voetbal: VoetbalScreen.onHidden() called")
		screenStateController.screenColorDimmedIsReachable = true
		this.close()
	}


	Text {
		id: mytexttop1
		text: app.firstlinescreentext

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 60 : 50
		}
		anchors {
			top:parent.top
			horizontalCenter: parent.horizontalCenter
			topMargin: 70
		}
	}
	
	Text {
		id: mytexttop2
		text: app.secondlinescreentext

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 100 : 80
		}
		anchors {
			top:		mytexttop1.bottom
			topMargin: 	30
			horizontalCenter: parent.horizontalCenter
		}
	}
	
}
