  
import QtQuick 2.1
import qb.base 1.0
import BasicUIControls 1.0
import qb.components 1.0
import BxtClient 1.0

Tile {
	id: voetbalTile
	
	property bool lampstate: false
	
	Component.onCompleted: {
		app.matchesUpdated.connect(updateMatchesList);
	}

	function updateMatchesList() {
		matchModel.clear();
		for (var i = 0; i < app.items.length; i++) {
			if (app.items[i].length > 2) {
				matchModel.append({match: app.items[i]});
			}
		}
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
		cellHeight: isNxt ? parseInt(170/app.items.length) : parseInt(140/app.items.length)
		height : parent.height - 40
		width : parent.width
		anchors {
			top: parent.top
			left: parent.left
		}
	}

	ListModel {
		id: matchModel
	}

	NewTextLabel {
		id: setupText
		width: parent.width-30
		height: isNxt ? 35 : 30
		buttonActiveColor: "lightgrey"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "Setup"
		anchors {
			bottom: parent.bottom
			left: parent.left
			leftMargin:15
			bottomMargin: 5
			}
		onClicked: {
			onClicked: {stage.openFullscreen(app.voetbalConfigScreenUrl)}	
		}
		visible: !dimState
	}
	
}