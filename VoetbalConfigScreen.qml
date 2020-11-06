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
	property int numberofscenes: 0

	property variant  lampsUUID : []
	property variant  scenesUUID : []

	property string  selectedlampsbyname : ""
	property string  selectedlampsbyuuid : ""

	property string  selectedscenebyname : ""
	property string  selectedscenebyuuid : ""
	property string  bridgeuuid : ""
	property int notificationtime
	property bool bridgefound: false
	
	
	onShown: {
		addCustomTopRightButton("Save")
		getTeams()
		getLamps()
		selectedteams = app.selectedteams
		selectedlampsbyuuid = app.selectedlampsbyuuid
		selectedlampsbyname = app.selectedlampsbyname
		selectedscenebyuuid = app.selectedscenebyuuid
		selectedscenebyname = app.selectedscenebyname
		notificationtime = app.notificationtime
		bridgeuuid = app.bridgeuuid
	}

	onCustomButtonClicked: {
		app.selectedteams = selectedteams
		app.selectedlampsbyuuid = selectedlampsbyuuid
		app.selectedlampsbyname = selectedlampsbyname
		app.selectedscenebyuuid = selectedscenebyuuid
		app.selectedscenebyname = selectedscenebyname
		app.bridgeuuid = bridgeuuid
		app.notificationtime = notificationtime
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
						model3.clear()
						var lampsfile = doc.responseText;
						var lampsArray = lampsfile.split('<device>')
						numberoflamps =  0
						numberofscenes = 0
						for(var x0 = 0;x0 < lampsArray.length;x0++){
							var found0 = 2
							found0 = lampsArray[x0].indexOf('<type>hue_bridge')
								if (found0>1){
									bridgefound=true
									var n20 = lampsArray[x0].indexOf('<uuid>') + 6
									var n21 = lampsArray[x0].indexOf('</uuid>',n21)
									bridgeuuid = lampsArray[x0].substring(n20, n21)
								}else{													//no bridge found so no lamps, no scenes
									selectedlampsbyuuid = ""
									selectedlampsbyname = ""
									selectedscenebyuuid = ""
									selectedscenebyname = ""
								}
						}
						for(var x1 = 0;x1 < lampsArray.length;x1++){
							var found = 2
							found = lampsArray[x1].indexOf('<type>hue_light')
								if (found>1){
									numberoflamps = numberoflamps + 1
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
						for(var x2 = 0;x2 < lampsArray.length;x2++){
							var found2 = 2
							console.log(lampsArray)
							found2 = lampsArray[x2].indexOf('<type>hue_scene')
								if (found2>1){
									numberofscenes = numberofscenes + 1
									var n10 = lampsArray[x2].indexOf('<uuid>') + 6
									var n11 = lampsArray[x2].indexOf('</uuid>',n10)
									var uuid = lampsArray[x2].substring(n10, n11)
									var n15 = lampsArray[x2].indexOf('<name>') + 6
									var n16 = lampsArray[x2].indexOf('</name>',n15)
									var scenename = lampsArray[x2].substring(n15, n16)
									listview3.model.append({name: scenename}) // scenenames to listview3
									scenesUUID.push(uuid) //scene uuids to array
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
			pixelSize: isNxt ? 16: 12
		}
		anchors {
			top:parent.top
			left:parent.left
			leftMargin: 10
			topMargin: 5
		}
	}
	
	Text {
		id: mytexttop2
		text: "When a goal is scored in a match of your"

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 16 : 12
		}
		anchors {
			top:		mytexttop1.bottom
			topMargin: 	0
			left:   	mytexttop1.left
		}
	}
	
		Text {
		id: mytexttop3
		text: "selected team(s) you will get a notification"

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 16 : 12
		}
		anchors {
			top:		mytexttop2.bottom
			topMargin: 	0
			left:   	mytexttop1.left
		}
	}
	
	Rectangle{
		id: listviewContainer1
		width: isNxt ? 200 : 160
		height: isNxt ? 150 : 100
		color: "white"
		radius: isNxt ? 5 : 4
		border.color: "black"
			border.width: isNxt ? 5 : 4
		anchors {
			top:		mytexttop3.bottom
			topMargin: 	5
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
					font.pixelSize: isNxt ? 16 : 12
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
		}
	}

/////////////////////////////////////////////////////////////////////////

	IconButton {
		id: upButton
		anchors {
			top: listviewContainer1.top
			left:  listviewContainer1.right
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
			bottom: listviewContainer1.bottom
			left:  listviewContainer1.right
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
		height: isNxt ? 25 : 20
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "Add"
		anchors {
			top: listviewContainer1.bottom
			left: listviewContainer1.left
			topMargin: 5
			}
		onClicked: {
			if (selectedteams.indexOf(teamsShort[listview1.currentIndex]) == -1){
				if  (selectedteams.length<1){
					selectedteams = teamsShort[listview1.currentIndex]
				}else{
					selectedteams += ";" + teamsShort[listview1.currentIndex]
				}
			}
		}
	}

	NewTextLabel {
		id: clearText
		width: isNxt ? 95 : 65;  
		height: isNxt ? 25 : 20
		buttonActiveColor: "red"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "Clear"
		anchors {
			top: addText.top
			right: listviewContainer1.right
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
			pixelSize: isNxt ? 16: 12
		}
		anchors {
			top:clearText.bottom
			left:listviewContainer1.left
			topMargin: 5
		}
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	Text {
		id: mytimerlabel
		text: "Time for notification (seconds): " 

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 16 : 12
		}
		anchors {
			top:mytext1.bottom
			left:listviewContainer1.left
			topMargin: 5
		}
	}
	
	NewTextLabel {
		id:minText
		width: isNxt ? 95 : 65;  
		height: isNxt ? 25 : 20
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "-"
		anchors {
			top: mytimerlabel.bottom
			left: listviewContainer1.left
			topMargin: 3
			}
		onClicked: {
			if (notificationtime>5000){
				notificationtime = notificationtime -1000
			}
		}
	}

	Text {
		id: mytimerlabel2
		text:  notificationtime/1000

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 20 : 16
		}
		anchors {
			top:minText.top
			left:minText.right
			leftMargin:10
		}
	}
	

	NewTextLabel {
		id:plusText
		width: isNxt ? 95 : 65;  
		height: isNxt ? 25 : 20
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "+"
		anchors {
			top: minText.top
			left: mytimerlabel2.right
			leftMargin:10
			}
		onClicked: {
			if (notificationtime<100000){
				notificationtime = notificationtime +1000
			}
		}
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	Text {
		id: mytexttop10
		text: "Select your favorite lamps."

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 16 : 12
		}
		anchors {
			top:parent.top
			left:parent.left
			leftMargin: (parent.width/2) + 20
			topMargin: 5
		}
		visible : bridgefound
	}
	
	Text {
		id: mytexttop11
		text: "When a goal is scored in a match of"

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 16 : 12
		}
		anchors {
			top:		mytexttop10.bottom
			topMargin: 	0
			left:   	mytexttop10.left
		}
		visible : bridgefound
	}
	
	Text {
		id: mytexttop12
		text: "your selected team(s) lamps will blink"

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 16 : 12
		}
		anchors {
			top:		mytexttop11.bottom
			topMargin: 	0
			left:   	mytexttop10.left
		}
		visible : bridgefound
	}
	
	Rectangle{
		id: listviewContainer2
		width: isNxt ? 200 : 160
		height: isNxt ? 150 : 100
		color: "white"
		radius: isNxt ? 5 : 4
		border.color: "black"
			border.width: isNxt ? 5 : 4
		anchors {
			top:		listviewContainer1.top
			left:   	mytexttop10.left
		}

		Component {
			id: aniDelegate2
			Item {
				width: isNxt ? (parent.width-20) : (parent.width-16)
				height: 22
				Text {
					id: tst2
					text: name
					font.pixelSize: isNxt ? 16 : 12
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
		}
		visible : bridgefound
		
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
		visible : bridgefound		
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
		    if (numberoflamps>=listview2.currentIndex){
                        listview2.currentIndex  = listview2.currentIndex +1
            }
		}
		visible : bridgefound		
	}


	NewTextLabel {
		id: addText2
		width: isNxt ? 95 : 65;  
		height: isNxt ? 25 : 20
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
					selectedlampsbyuuid = lampsUUID[listview2.currentIndex]
					selectedlampsbyname = model2.get(listview2.currentIndex).name
				}else{
					selectedlampsbyuuid += ";" + lampsUUID[listview2.currentIndex]
					selectedlampsbyname += ";" + model2.get(listview2.currentIndex).name
				}
			}
		}
		visible : bridgefound		
	}

	NewTextLabel {
		id: clearText2
		width: isNxt ? 95 : 65;  
		height: isNxt ? 25 : 20
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
		visible : bridgefound		
	}

	Text {
		id: mytext2
		text: "Selected lamps: " + selectedlampsbyname

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 16 : 12
		}
		anchors {
			top:clearText2.bottom
			left:listviewContainer2.left
			topMargin: 5
		}
		visible : bridgefound		
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	Text {
		id: mytexttop20
		text: "Do you want to set a scene also?"

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 16 : 12
		}
		anchors {
			top:mytext2.bottom
			left:parent.left
			leftMargin: (parent.width/2) + 20
			topMargin: 10
		}
		visible : bridgefound		
	}
	
	Rectangle{
		id: listviewContainer3
		width: isNxt ? 200 : 160
		height: isNxt ? 100 : 80
		color: "white"
		radius: isNxt ? 5 : 4
		border.color: "black"
			border.width: isNxt ? 5 : 4
		anchors {
			top:		mytexttop20.bottom
			left:   	mytexttop10.left
			topMargin: 	2
			
		}

		Component {
			id: aniDelegate3
			Item {
				width: isNxt ? (parent.width-20) : (parent.width-16)
				height: 22
				Text {
					id: tst3
					text: name
					font.pixelSize: isNxt ? 20 : 16
				}
			}
		}

		ListModel {
				id: model3
		}


		ListView {
			id: listview3
			anchors {
				top: parent.top
				topMargin:isNxt ? 20 : 16
				leftMargin: isNxt ? 12 : 9
				left: parent.left
			}
			width: parent.width
			height: isNxt ? (parent.height-50) : (parent.height-40)
			model:model3
			delegate: aniDelegate3
			highlight: Rectangle { 
				color: "lightsteelblue"; 
				radius: isNxt ? 5 : 4
			}
			focus: true
		}
		visible : bridgefound		
	}

/////////////////////////////////////////////////////////////////////////

	IconButton {
		id: upButton3
		anchors {
			top: listviewContainer3.top
			left:  listviewContainer3.right
			leftMargin : 3
		}

		iconSource: "qrc:/tsc/up.png"
		onClicked: {
		    if (listview3.currentIndex>0){
                        listview3.currentIndex  = listview3.currentIndex -1
            }
		}
		visible : bridgefound				
	}

	IconButton {
		id: downButton3
		anchors {
			bottom: listviewContainer3.bottom
			left:  listviewContainer3.right
			leftMargin : 3

		}

		iconSource: "qrc:/tsc/down.png"
		onClicked: {
		    if (numberofscenes>=listview3.currentIndex){
                        listview3.currentIndex  = listview3.currentIndex +1
            }
		}
		visible : bridgefound		
	}


	NewTextLabel {
		id: addText3
		width: isNxt ? 95 : 65;  
		height: isNxt ? 25 : 20
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "Select"
		anchors {
			top: listviewContainer3.bottom
			left: listviewContainer3.left
			topMargin: 10
			}
		onClicked: {
			//selectedscenebyuuid = scenesUUID[listview3.currentIndex]
			selectedscenebyuuid = listview3.currentIndex
			selectedscenebyname =  model3.get(listview3.currentIndex).name
		}
		visible : bridgefound		
	}

	Text {
		id: mytext3
		text: "Selected scene: " + selectedscenebyname

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 16 : 12
		}
		anchors {
			top:addText3.bottom
			left:listviewContainer3.left
			topMargin: 5
		}
		visible : bridgefound		
	}
}




