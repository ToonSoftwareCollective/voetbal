import QtQuick 2.1
import BasicUIControls 1.0
import qb.components 1.0

Screen {
	id: voetbalConfigScreen
	screenTitle: "Voetbal app Setup"

	property variant   teams: ["ADO","Ajax","AZ","Emmen","Groningen","Twente","Utrecht","Feyenoord","Fortuna","Heracles","PEC","PSV","RKC","Heerenveen","Sparta","Vitesse","VVV","Willem"]
	property int  numberofItems :0
	property string  selectedteams : ""
	
	onShown: {
		addCustomTopRightButton("Save");
		getData();
		selectedteams = app.selectedteams;
	}

	onCustomButtonClicked: {
		app.selectedteams = selectedteams;
		app.saveSettings();
		hide();
	}

	function getData() {
		numberofItems =  teams.length
		model.clear()
		for (var i = 0; i < teams.length; i++){
			listview1.model.append({name: teams[i]})
		}
	}

/////////////////////////////////////////////////////////////////////////
	Rectangle{
		id: listviewContainer
		width: isNxt ? 240 : 188
		height: isNxt ? 300 : 200
		color: "white"
		radius: isNxt ? 5 : 4
		border.color: "black"
			border.width: isNxt ? 5 : 4
		anchors {
			top:		parent.top
			topMargin: 	50
			left:   	parent.left
			leftMargin:	20
		}

		Component {
			id: aniDelegate
			Item {
				width: isNxt ? (parent.width-20) : (parent.width-16)
				height: 22
				Text {
					id: tst
					text: name
					font.pixelSize: isNxt ? 22 : 17
				}
			}
		}


		ListModel {
				id: model
		}


		ListView {
			id: listview1
			anchors {
				top: parent.top
				topMargin:isNxt ? 20 : 16
				leftMargin: isNxt ? 12 : 9
				left: parent.left
			}
			width: parent.width
			height: isNxt ? (parent.height-50) : (parent.height-40)
			model:model
			delegate: aniDelegate
			highlight: Rectangle { 
				color: "lightsteelblue"; 
				radius: isNxt ? 5 : 4
			}
			focus: true
			MouseArea {
				anchors.fill: parent
				onClicked: {
				animation(model.get(listview1.currentIndex).name);
				}
			}
		}
		visible: !dimState
	}

/////////////////////////////////////////////////////////////////////////

	IconButton {
		id: upButton
		anchors {
			top: listviewContainer.top
			left:  listviewContainer.right
			leftMargin : 3
		}

		iconSource: "qrc:/tsc/up.png"
		onClicked: {
		    if (listview1.currentIndex>0){
                        listview1.currentIndex  = listview1.currentIndex -1;
            }
		}	
		visible: !dimState
	}

	IconButton {
		id: downButton
		anchors {
			bottom: listviewContainer.bottom
			left:  listviewContainer.right
			leftMargin : 3

		}

		iconSource: "qrc:/tsc/down.png"
		onClicked: {
		    if (numberofItems>=listview1.currentIndex){
                        listview1.currentIndex  = listview1.currentIndex +1;
            }
		}	
		visible: !dimState
	}


	NewTextLabel {
		id: addText
		width: isNxt ? 95 : 65;  
		height: isNxt ? 35 : 30
		buttonActiveColor: "lightgrey"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "Add"
		anchors {
			top: listviewContainer.bottom
			left: listviewContainer.left
			topMargin: 10
			}
		onClicked: {
			console.log(model.get(listview1.currentIndex).name);
			if  (selectedteams.length<1){
				selectedteams = model.get(listview1.currentIndex).name;
			}else{
				selectedteams += ";" + model.get(listview1.currentIndex).name;
			}
		}
		visible: !dimState
	}

	NewTextLabel {
		id: clearText
		width: isNxt ? 95 : 65;  
		height: isNxt ? 35 : 30
		buttonActiveColor: "lightgrey"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "Clear"
		anchors {
			top: listviewContainer.bottom
			left: addText.right
			leftMargin:10
			topMargin: 10
			}
		onClicked: {
			selectedteams= "";
		}
		visible: !dimState
	}

	Text {
		id: mytext1
		text: "Selected Teams: " + selectedteams

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 22 : 17
		}
		anchors {
			top:clearText.bottom
			left:listviewContainer.bottom
			leftMargin: 0
			topMargin: 10
		}
	}
}
