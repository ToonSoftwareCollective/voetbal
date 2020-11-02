import QtQuick 2.1
//import qb.base 1.0
import qb.components 1.0

Tile {
	id: voetbalTile

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
					pixelSize: isNxt ? 20 : 16
				}
			}

		flow: GridView.TopToBottom
		cellWidth: parent.width
		cellHeight: isNxt ? 25 : 20

		anchors {
			fill: parent
		}
	}

	ListModel {
		id: matchModel
	}
}

