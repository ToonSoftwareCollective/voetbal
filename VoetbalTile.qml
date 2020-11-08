  
import QtQuick 2.1
import qb.base 1.0
import BasicUIControls 1.0
import qb.components 1.0

Tile {
	id: voetbalTile
	
	property bool dimState: screenStateController.dimmedColors

	
	Component.onCompleted: {
		app.matchesUpdated.connect(updateMatchesList);
	}

	function updateMatchesList() {
		matchModel.clear()
		for (var i = 0; i < app.items.length; i++) {
			if (app.items[i].length > 2) {
				matchModel.append({match: app.items[i]});
			}
		}
	}

	
	ListModel {
		id: matchModel
	}


	Text {
		id: label1
		text: "Voetbal" 
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 50 : 40
			horizontalCenter: parent.horizontalCenter
		}
		color: colors.clockTileColor
		font.pixelSize: isNxt ? 20 : 16
		font.family: qfont.regular.name
		visible: ((app.items.length<1) && !dimState)
	}
	
	GridView {
		id: matchListView

		model: matchModel
		delegate: Text {
				id: mytext
				text: match
				font {
					family: qfont.semiBold.name
					pixelSize: isNxt ? app.sizeoftilefont : 16
				}
			}

		flow: GridView.TopToBottom
		cellWidth: parent.width
		cellHeight: isNxt ? parseInt(195/app.items.length) : parseInt(140/app.items.length)
		height : parent.height-10
		width : parent.width-30
		anchors {
			top: parent.top
			left: parent.left
			leftMargin: 20
			topMargin:10
		}
		visible: (app.items.length>0)
	}
	
	
	MouseArea {
		height : parent.height/2
		width : parent.width/2
		anchors {
			top: parent.top
			left: parent.left
			leftMargin: parent.width/4
			topMargin:parent.height/4
		}
		onClicked: {
			stage.openFullscreen(app.voetbalConfigScreenUrl)
		}
	}
		
}
	