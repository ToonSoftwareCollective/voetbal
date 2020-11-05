import QtQuick 2.1
import BasicUIControls 1.0
import qb.components 1.0

Screen {
	id: voetbalConfigScreen
	screenTitle: "Voetbal App Setup"

	property string teams: ""
	property string teamsURL : "https://raw.githubusercontent.com/ToonSoftwareCollective/toonanimations/master/teamnames.txt"
	property variant  teamsShort : []
	property int  numberofItems :0
	property string  selectedteams : ""
	
	property int numberoflamps: 0
	property variant  lampsUUID : []
	property string  selectedlampsbyname : ""
	property string  selectedlampsbyuuid : ""
	
	
	onShown: {
		addCustomTopRightButton("Save")
		getTeams()
		getLamps()
		selectedteams = app.selectedteams
		selectedlampsbyuuid = app.selectedlampsbyuuid
		selectedlampsbyname = app.selectedlampsbyname
	}

	onCustomButtonClicked: {
		app.selectedteams = selectedteams
		app.selectedlampsbyuuid = selectedlampsbyuuid
		app.selectedlampsbyname = selectedlampsbyname
		app.saveSettings()
		hide()
	}

	function getTeams(){
		var xmlhttp = new XMLHttpRequest()
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState === 4 && xmlhttp.status === 200) {
				teams = xmlhttp.responseText
				var teamsArray = teams.substring(1, teams.length-1).split(';')
				numberofItems =  teamsArray.length
				model.clear()
				for(var x1 = 0;x1 < teamsArray.length;x1++){
						var team = teamsArray[x1]
						var teamArray= team.split(':')
						listview1.model.append({name: teamArray[0]}) // long teamnames to listview
						teamsShort.push(teamArray[1]) //short teamnames to array
				}
			}
		}
		xmlhttp.open("GET", teamsURL, true)
		xmlhttp.send()
	}

	function getLamps(){
		var doc = new XMLHttpRequest();
        	doc.onreadystatechange = function() {
            		if (doc.readyState == XMLHttpRequest.DONE) {
						model2.clear()
						var lampsfile = doc.responseText;
						var lampsArray = lampsfile.split('<device>')
						numberoflamps =  lampsArray.length
						for(var x1 = 0;x1 < lampsArray.length;x1++){
							var found = 2
							found = lampsArray[x1].indexOf('<type>hue_light')
								if (found>1){
									var n1 = lampsArray[x1].indexOf('<uuid>') + 6
									var n2 = lampsArray[x1].indexOf('</uuid>',n1)
									var uuid = lampsArray[x1].substring(n1, n2)
									var n5 = lampsArray[x1].indexOf('<name>') + 6
									var n6 = lampsArray[x1].indexOf('</name>',n5)
									var lampname = lampsArray[x1].substring(n5, n6)
									listview2.model.append({name: lampname}) // lampnames to listview2
									lampsUUID.push(uuid) //lamp uuids to array
								}
						}
            		}
        	}
        	doc.open("GET", "file:////qmf/config/config_hdrv_hue.xml", true);
        	doc.setRequestHeader("Content-Encoding", "UTF-8");
        	doc.send();
	}
	
/////////////////////////////////////////////////////////////////////////

	Text {
		id: mytexttop1
		text: "Select your favorite teams."

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 14 : 12
		}
		anchors {
			top:parent.top
			left:parent.left
			leftMargin: 10
			topMargin: 10
		}
	}
	
	Text {
		id: mytexttop2
		text: "When a goal is scored in a match of your selected team(s) you will get a notification"

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 14 : 12
		}
		anchors {
			top:		mytexttop1.bottom
			topMargin: 	5
			left:   	mytexttop1.left
		}
	}
	
	Rectangle{
		id: listviewContainer
		width: isNxt ? 300 : 240
		height: isNxt ? 300 : 200
		color: "white"
		radius: isNxt ? 5 : 4
		border.color: "black"
			border.width: isNxt ? 5 : 4
		anchors {
			top:		mytexttop2.bottom
			topMargin: 	20
			left:   	mytexttop1.left
		}

		Component {
			id: aniDelegate
			Item {
				width: isNxt ? (parent.width-20) : (parent.width-16)
				height: 22
				Text {
					id: tst
					text: name
					font.pixelSize: isNxt ? 20 : 16
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
			/*MouseArea {
				anchors.fill: parent
				onClicked: {
				if (selectedteams.indexOf(teamsShort[listview1.currentIndex]) == -1){
					if  (selectedteams.length<1){
						selectedteams += teamsShort[listview1.currentIndex]
					}else{
						selectedteams += ";" + teamsShort[listview1.currentIndex]
					}
				}
				}
			}
			*/
		}
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
                        listview1.currentIndex  = listview1.currentIndex -1
            }
		}	
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
                        listview1.currentIndex  = listview1.currentIndex +1
            }
		}	
	}


	NewTextLabel {
		id: addText
		width: isNxt ? 95 : 65;  
		height: isNxt ? 35 : 30
		buttonActiveColor: "lightgreen"
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
			if (selectedteams.indexOf(teamsShort[listview1.currentIndex]) == -1){
				if  (selectedteams.length<1){
					selectedteams += teamsShort[listview1.currentIndex]
				}else{
					selectedteams += ";" + teamsShort[listview1.currentIndex]
				}
			}
		}
	}

	NewTextLabel {
		id: clearText
		width: isNxt ? 95 : 65;  
		height: isNxt ? 35 : 30
		buttonActiveColor: "red"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "Clear"
		anchors {
			top: addText.top
			right: listviewContainer.right
			}
		onClicked: {
			selectedteams= ""
		}
	}

	Text {
		id: mytext1
		text: "Selected Teams (shortnames): " + selectedteams

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 14: 12
		}
		anchors {
			top:clearText.bottom
			left:listviewContainer.left
			leftMargin: 0
			topMargin: 10
		}
	}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	Text {
		id: mytexttop3
		text: "Select your favorite lamps."

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 12 : 9
		}
		anchors {
			top:parent.top
			left:parent.left
			leftMargin: (parent.width/2) + 20
			topMargin: 10
		}
	}
	
	Text {
		id: mytexttop4
		text: "When a goal is scored in a match of your selected team(s) lamps will blink"

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 12 : 9
		}
		anchors {
			top:		mytexttop3.bottom
			topMargin: 	5
			left:   	mytexttop3.left
		}
	}
	
	Rectangle{
		id: listviewContainer2
		width: isNxt ? 300 : 240
		height: isNxt ? 300 : 200
		color: "white"
		radius: isNxt ? 5 : 4
		border.color: "black"
			border.width: isNxt ? 5 : 4
		anchors {
			top:		mytexttop4.bottom
			topMargin: 	20
			left:   	mytexttop3.left
		}

		Component {
			id: aniDelegate2
			Item {
				width: isNxt ? (parent.width-20) : (parent.width-16)
				height: 22
				Text {
					id: tst2
					text: name
					font.pixelSize: isNxt ? 20 : 16
				}
			}
		}

		ListModel {
				id: model2
		}


		ListView {
			id: listview2
			anchors {
				top: parent.top
				topMargin:isNxt ? 20 : 16
				leftMargin: isNxt ? 12 : 9
				left: parent.left
			}
			width: parent.width
			height: isNxt ? (parent.height-50) : (parent.height-40)
			model:model2
			delegate: aniDelegate2
			highlight: Rectangle { 
				color: "lightsteelblue"; 
				radius: isNxt ? 5 : 4
			}
			focus: true
			/*MouseArea {
				anchors.fill: parent
				onClicked: {
				if (selectedteams.indexOf(teamsShort[listview1.currentIndex]) == -1){
					if  (selectedteams.length<1){
						selectedteams += teamsShort[listview1.currentIndex]
					}else{
						selectedteams += ";" + teamsShort[listview1.currentIndex]
					}
				}
				}
			}
			*/
		}
	}

/////////////////////////////////////////////////////////////////////////

	IconButton {
		id: upButton2
		anchors {
			top: listviewContainer2.top
			left:  listviewContainer2.right
			leftMargin : 3
		}

		iconSource: "qrc:/tsc/up.png"
		onClicked: {
		    if (listview2.currentIndex>0){
                        listview2.currentIndex  = listview2.currentIndex -1
            }
		}	
	}

	IconButton {
		id: downButton2
		anchors {
			bottom: listviewContainer2.bottom
			left:  listviewContainer2.right
			leftMargin : 3

		}

		iconSource: "qrc:/tsc/down.png"
		onClicked: {
		    if (numberofItems>=listview2.currentIndex){
                        listview2.currentIndex  = listview2.currentIndex +1
            }
		}	
	}


	NewTextLabel {
		id: addText2
		width: isNxt ? 95 : 65;  
		height: isNxt ? 35 : 30
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "Add"
		anchors {
			top: listviewContainer2.bottom
			left: listviewContainer2.left
			topMargin: 10
			}
		onClicked: {
			if (selectedlampsbyuuid.indexOf(lampsUUID[listview2.currentIndex]) == -1){
				if  (selectedlampsbyuuid.length<1){
					selectedlampsbyuuid += lampsUUID[listview2.currentIndex]
					selectedlampsbyname += model2.get(listview2.currentIndex).name
				}else{
					selectedlampsbyuuid += ";" + lampsUUID[listview2.currentIndex]
					selectedlampsbyname += ";" + model2.get(listview2.currentIndex).name
				}
			}
		}
	}

	NewTextLabel {
		id: clearText2
		width: isNxt ? 95 : 65;  
		height: isNxt ? 35 : 30
		buttonActiveColor: "red"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "Clear"
		anchors {
			top: addText2.top
			right: listviewContainer2.right
			}
		onClicked: {
			selectedlampsbyname = ""
			selectedlampsbyuuid = ""
		}
	}

	Text {
		id: mytext2
		text: "Selected lamps: " + selectedlampsbyname

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 14 : 12
		}
		anchors {
			top:clearText2.bottom
			left:listviewContainer2.left
			leftMargin: 0
			topMargin: 10
		}
	}
}




