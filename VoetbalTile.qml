import QtQuick 2.1
//import qb.base 1.0
import qb.components 1.0

Tile {
	id: voetbalTile
	Text {
		id: mytext1
		text: app.match1
		font {
			family: qfont.semiBold.name
			pixelSize: 14
		}
		anchors {
			top:parent.top
			left:parent.left
			leftMargin: 10
		}
	}
	Text {
		id: mytext2
		text: app.match2
		font {
			family: qfont.semiBold.name
			pixelSize: 14
		}
		anchors {
			top:mytext1.bottom
			left:mytext1.left
			topMargin: 5
		}
	}
	Text {
		id: mytext3
		text:app.match3
		font {
			family: qfont.semiBold.name
			pixelSize: 14
		}
		anchors {
			top:mytext2.bottom
			left:mytext1.left
			topMargin: 5
		}
	}
	Text {
		id: mytext4
		text: app.match4
		font {
			family: qfont.semiBold.name
			pixelSize: 14
		}
		anchors {
			top:mytext3.bottom
			left:mytext1.left
			topMargin: 5
		}
	}
	Text {
		id: mytext5
		text: app.match5
		font {
			family: qfont.semiBold.name
			pixelSize: 14
		}
		anchors {
			top:mytext4.bottom
			left:mytext1.left
			topMargin: 5
		}
	}
	Text {
		id: mytext6
		text: app.match6
		font {
			family: qfont.semiBold.name
			pixelSize: 14
		}
		anchors {
			top:mytext5.bottom
			left:mytext1.left
			topMargin: 5
		}
	}
	Text {
		id: mytext7
		text: app.match7
		font {
			family: qfont.semiBold.name
			pixelSize: 14
		}
		anchors {
			top:mytext6.bottom
			left:mytext1.left
			topMargin: 5
		}
	}
	Text {
		id: mytext8
		text: app.match8
		font {
			family: qfont.semiBold.name
			pixelSize: 14
		}
		anchors {
			top:mytext7.bottom
			left:mytext1.left
			topMargin: 5
		}
	}
	Text {
		id: mytext9
		text: app.match9
		font {
			family: qfont.semiBold.name
			pixelSize: 14
		}
		anchors {
			top:mytext8.bottom
			left:mytext1.left
			topMargin: 5
		}
	}

}

