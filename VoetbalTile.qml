  
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
		if ((matchModel)) {
			matchModel.clear()
			statusModel.clear()
			for (var i = 0; i < app.items.length; i++) {
				if (app.items[i].length > 2) {
					matchModel.append({match: app.items[i]});
					statusModel.append({status: app.timestatus[i]});
					//console.log("app.timestatus[i] (tile): " + app.timestatus[i])
					//console.log("app.items[i] (tile): " + app.items[i])
					//console.log("app.showmatchesontile: " + app.showmatchesontile)
				}
			}
		}
	}

	
	ListModel {
		id: matchModel
	}
	
	ListModel {
		id: statusModel
	}


	Text {
		id: label1
		text: "Geen wedstrijden vandaag" 
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.tileTextColor : colors.tileTextColor
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 50 : 40
			horizontalCenter: parent.horizontalCenter
		}
		font.pixelSize: isNxt ? 20 : 16
		font.family: qfont.regular.name
		visible: !app.showmatchesontile
	}

	Text {
		id: txtSender
		text:  "Voetbal App"
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.tileTextColor : colors.tileTextColor
		anchors {
			top: label1.bottom
			horizontalCenter: parent.horizontalCenter
		}
		font.pixelSize: isNxt ? 20 : 16
		font.family: qfont.bold.name
		visible: !app.showmatchesontile
	}


	GridView {
		id: statusListView
		model: statusModel
		delegate: Text {
				id: mytext2
				text: status
				color: (typeof dimmableColors !== 'undefined') ? dimmableColors.tileTextColor : colors.tileTextColor
				font {
					family: qfont.semiBold.name
					pixelSize: app.sizeoftilefont
				}
				anchors.right: parent.right
			}

		flow: GridView.TopToBottom
		cellWidth: parent.width
		cellHeight: isNxt ? parseInt(195/app.items.length) : parseInt(156/app.items.length)
		height :  isNxt ? parent.height-10 : parent.height-8
		width :  isNxt ? parseInt(app.sizeoftilefont * 1.5) : parseInt(app.sizeoftilefont * 1.2)
		anchors {
			top: parent.top
			left: parent.left
			leftMargin:  isNxt ? 16: 12
			topMargin: isNxt? 10: 8
		}
		visible: app.showmatchesontile
	}
	
	GridView {
		id: matchListView

		model: matchModel
		delegate: Text {
				id: mytext
				text: match
				color: (typeof dimmableColors !== 'undefined') ? dimmableColors.tileTextColor : colors.tileTextColor
				font {
					family: qfont.semiBold.name
					pixelSize: app.sizeoftilefont
				}
			}

		flow: GridView.TopToBottom
		cellWidth: parent.width
		cellHeight: statusListView.cellHeight
		height :   statusListView.height
		width :  isNxt ?  parent.width-statusListView.width-30 :  parent.width-statusListView.width-24
		anchors {
			top: statusListView.top
			left: statusListView.right
			leftMargin:  isNxt? 24: 16
		}
		visible: app.showmatchesontile
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
	