import QtQuick 2.1
import BasicUIControls 1.0
import qb.components 1.0

Screen {
	id: voetbalConfigScreen3
	screenTitle: "Voetbal App Setup"

	property int numberoflamps: 0
	property int numberofscenes: 0

	property variant  lampsUUID : []
	property variant  scenesUUID : []

	property string  selectedlampsbyname : ""
	property string  selectedlampsbyuuid : ""
	property string  selectedlampsText : ""

	property string  selectedscenebyname : ""
	property string  selectedscenebyuuid : ""
	property string  bridgeuuid : ""
	property bool bridgefound: false
	property int lampNotificationtime
	
	
	onShown: {
		addCustomTopRightButton("Opslaan")
		getLamps()
		lampNotificationtime = app.lampNotificationtime
		selectedlampsbyuuid = app.selectedlampsbyuuid
		selectedlampsbyname = app.selectedlampsbyname
		selectedscenebyuuid = app.selectedscenebyuuid
		selectedscenebyname = app.selectedscenebyname
		selectedLampstoText()
		//console.log ("selectedlampsbyname: " + selectedlampsbyname)
	}

	onCustomButtonClicked: {
		app.selectedlampsbyuuid = selectedlampsbyuuid
		app.selectedlampsbyname = selectedlampsbyname
		app.lampNotificationtime = lampNotificationtime
		app.selectedscenebyuuid = selectedscenebyuuid
		app.selectedscenebyname = selectedscenebyname
		app.bridgeuuid = bridgeuuid
		app.saveSettings()
		hide()
	}

	function selectedLampstoText(){
		var newArray = selectedlampsbyname.split(';')
		for(var x2 = 0;x2 < newArray.length;x2++){
			//console.log("Teamsarray: " + newArray[x2])
			if (x2==0){
					selectedlampsText = newArray[x2]
				}else{
					selectedlampsText = selectedlampsText + ", " + newArray[x2]
				}
		}
	}



	function getLamps(){
		var doc = new XMLHttpRequest();
        	doc.onreadystatechange = function() {
            		if (doc.readyState == XMLHttpRequest.DONE) {
						model1.clear()
						model2.clear()
						var lampsfile = doc.responseText;
						var lampsArray = lampsfile.split('<device>')
						numberoflamps =  0
						numberofscenes = 0
						for(var x0 = 0;x0 < lampsArray.length;x0++){
							found0 = lampsArray[x0].indexOf('<type>hue_bridge')
							var found0 = lampsArray[x0].indexOf('<type>hue_bridge')
								if (found0>1){
									var n20 = lampsArray[x0].indexOf('<uuid>') + 6
									//console.log("Found <uuid> : "  + n20)
									var n21 = lampsArray[x0].indexOf('</uuid>',n21)
									bridgeuuid = lampsArray[x0].substring(n20, n21)
									//console.log("Found Hue Bridge : "  + bridgeuuid)
									if (bridgeuuid.length>10){// bridge found
										bridgefound=true
									}
									break
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
									listview1.model.append({name: lampname}) // lampnames to listview1
									lampsUUID.push(uuid) //lamp uuids to array
								}
						}
						for(var x2 = 0;x2 < lampsArray.length;x2++){
							var found2 = 2
							found2 = lampsArray[x2].indexOf('<type>hue_scene')
								if (found2>1){
									numberofscenes = numberofscenes + 1
									var n10 = lampsArray[x2].indexOf('<uuid>') + 6
									var n11 = lampsArray[x2].indexOf('</uuid>',n10)
									var uuid = lampsArray[x2].substring(n10, n11)
									var n15 = lampsArray[x2].indexOf('<name>') + 6
									var n16 = lampsArray[x2].indexOf('</name>',n15)
									var scenename = lampsArray[x2].substring(n15, n16)
									listview2.model.append({name: scenename}) // scenenames to listview2
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
			//text: "Select your favorite lamps. When a goal is scored in a match of your selected team(s) lamps will blink"
			text: "Als gescoord wordt in een wedstrijd van je favoriete club(s) zullen lampen knipperen"
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 18 : 14
		}
		anchors {
			top:parent.top
			left:parent.left
			leftMargin: isNxt ? 10 : 8
			topMargin: isNxt ? 5 : 4
		}
	}
	

	Text {
		id: mytexttop2
		//text: "Select from list:"
		text: "Selecteer lampen:"
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 18:14
		}
		anchors {
			top:mytexttop1.bottom
			left:mytexttop1.left
			topMargin: isNxt ? 10 : 8
		}
	}
	


	Rectangle{
		id: listviewContainer1
		width:isNxt ? parent.width/2 -100 :  parent.width/2 -80
		height: isNxt ? 150 : 120
		color: "white"
		radius: isNxt ? 5 : 4
		border.color: "black"
		border.width: isNxt ? 3 : 2
		anchors {
			top:		mytexttop2.bottom
			topMargin: 	isNxt ? 8 : 6
			left:   	mytexttop1.left
		}

		Component {
			id: aniDelegate1
			Item {
				width: isNxt ? (parent.width-20) : (parent.width-16)
				height: isNxt ? 22 : 18
				Text {
					id: tst2
					text: name
					font.pixelSize: isNxt ? 18:14
				}
			}
		}

		ListModel {
				id: model1
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
			model:model1
			delegate: aniDelegate1
			highlight: Rectangle { 
				color: "lightsteelblue"; 
				radius: isNxt ? 5 : 4
			}
			focus: true
		}
	}

/////////////////////////////////////////////////////////////////////////

	IconButton {
		id: upButton1
		anchors {
			top: listviewContainer1.top
			left:  listviewContainer1.right
			leftMargin :  isNxt ? 3: 2
		}

		iconSource: "qrc:/tsc/up.png"
		onClicked: {
		    if (listview1.currentIndex>0){
                listview1.currentIndex  = listview1.currentIndex -1
            }
		}		
	}

	IconButton {
		id: downButton1
		anchors {
			bottom: listviewContainer1.bottom
			left:  listviewContainer1.right
			leftMargin : isNxt ? 3: 2

		}

		iconSource: "qrc:/tsc/down.png"
		onClicked: {
		    if (numberoflamps>=listview1.currentIndex){
                        listview1.currentIndex  = listview1.currentIndex +1
            }
		}	
	}


	NewTextLabel {
		id: addText1
		width: isNxt ? 120 : 96;  
		height: isNxt ? 40:32
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		//buttonText:  "Add"
		buttonText:  "Voeg Toe"
		anchors {
			top: listviewContainer1.bottom
			left: listviewContainer1.left
			topMargin: isNxt ? 5: 4
			}
		onClicked: {
			if (selectedlampsbyuuid.indexOf(lampsUUID[listview1.currentIndex]) == -1){
				if  (selectedlampsbyuuid.length<1){
					selectedlampsbyuuid = lampsUUID[listview1.currentIndex]
					selectedlampsbyname = model1.get(listview1.currentIndex).name
					selectedlampsText = model1.get(listview1.currentIndex).name
				}else{
					selectedlampsbyuuid += ";" + lampsUUID[listview1.currentIndex]
					selectedlampsbyname += ";" + model1.get(listview1.currentIndex).name
					selectedlampsText += ", " + model1.get(listview1.currentIndex).name
				}
			}
		}	
	}

	NewTextLabel {
		id: clearText1
		width: isNxt ? 120 : 96;  
		height: isNxt ?  40:32
		buttonActiveColor: "red"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		//buttonText:  "Clear"
		buttonText:  "Verwijder"
		anchors {
			top: lampsText.bottom
			left: selectedLampsT.left
			topMargin: isNxt ? 8 : 6;  
		}
		onClicked: {
			selectedlampsbyname = ""
			selectedlampsbyuuid = ""
			selectedlampsText = ""
		}	
	}

	Text {
		id: selectedLampsT
		//text: "Selected lamps: "
		text: "Geselecteerd lampen: "
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 18:14
		}
		anchors {
			top: mytexttop2.top
			left:parent.left
			leftMargin: parent.width/2
		}
	}
	
	
	Rectangle {
		id: lampsText
		color: "white"
		width: isNxt ? parent.width/2 -100 :  parent.width/2 -80
		height:  isNxt ? listviewContainer1.height-50   :  listviewContainer1.height-40     		
		Text{
			id: tText
			width: parent.width
			font.pixelSize: isNxt? 18:14
			wrapMode: Text.WordWrap
         	text: selectedlampsText
			font.family: qfont.regular.name
			color: "black"
     	}
		anchors {
			top: listviewContainer1.top
			left:selectedLampsT.left	
		}
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	Text {
		id: selectScenesText
		//text: "Do you want to set a scene also?"
		text: "Ook een scene kiezen?"
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 18 : 14
		}
		anchors {
			top:addText1.bottom
			left:listviewContainer1.left
			topMargin:  isNxt ? 8 : 6
		}	
	}
	
	Rectangle{
		id: listviewContainer2
		width: isNxt ? parent.width/2 -100 :  parent.width/2 -80
		height: isNxt ? 100 : 80
		color: "white"
		radius: isNxt ? 5 : 4
		border.color: "black"
			border.width: isNxt ? 5 : 4
		anchors {
			top:		selectScenesText.bottom
			left:   	listviewContainer1.left
			topMargin: 	 isNxt ? 5 : 4
			
		}

		Component {
			id: aniDelegate2
			Item {
				width: isNxt ? (parent.width-20) : (parent.width-16)
				height:  isNxt ? 22 : 18
				Text {
					id: tst2
					text: name
					font.pixelSize: isNxt ? 18 : 14
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
	}

/////////////////////////////////////////////////////////////////////////

	IconButton {
		id: upButton2
		anchors {
			top: listviewContainer2.top
			left:  listviewContainer2.right
			leftMargin : isNxt ? 3 : 2
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
			leftMargin : isNxt ? 3 : 2

		}

		iconSource: "qrc:/tsc/down.png"
		onClicked: {
		    if (numberofscenes>=listview2.currentIndex){
                        listview2.currentIndex  = listview2.currentIndex +1
            }
		}	
	}


	NewTextLabel {
		id: addText2
		width: isNxt ? 120 : 96;  
		height: isNxt ? 40:32
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		//buttonText:  "Select"
		buttonText:  "Selecteer"
		anchors {
			top: listviewContainer2.bottom
			left: listviewContainer2.left
			topMargin: isNxt ? 8 : 6
			}
		onClicked: {
			selectedscenebyuuid = listview2.currentIndex
			selectedscenebyname =  model2.get(listview2.currentIndex).name
		}	
	}

	Text {
		id: mySelectedSceneText
		//text: "Selected scene: "
		text: "geselecteerd scene: "
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 18:14
		}
		anchors {
			top:  selectScenesText.top
			left: selectedLampsT.left
		}
	}
	
	Text {
		id: mySelectedSceneText2
		text: selectedscenebyname

		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 18:14
		}
		anchors {
			top:  mySelectedSceneText.top
			left:  mySelectedSceneText.right
		}
	}
	
	NewTextLabel {
		id: clearText12
		width: isNxt ? 120 : 96;  
		height: isNxt ?  40:32
		buttonActiveColor: "red"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		//buttonText:  "Clear"
		buttonText:  "Verwijder"
		anchors {
			top: mySelectedSceneText.bottom
			left: selectedLampsT.left
			topMargin: isNxt ? 8 : 6
		}
		onClicked: {
			selectedscenebyname = ""
			selectedscenebyuuid = ""
		}	
	}
	
		Text {
		id: mytimerlabel
		//text: "Time for notification (seconds): " 
		text: "Tijd dat de lampen knipperen (seconden): "
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 18:14
		}
		anchors {
			top:addText2.bottom
			left:listviewContainer1.left
			topMargin: 8
		}
	}
	
	NewTextLabel {
		id:minText
		width: isNxt ? 55 : 45;  
		height: isNxt ?40:32
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "-"
		anchors {
			top: mytimerlabel.top
			left:  mytimerlabel.right
			leftMargin:  isNxt ? 6 :4
		}
		onClicked: {
			if (lampNotificationtime>5000){
				lampNotificationtime = lampNotificationtime -1000
			}
		}
	}

	Text {
		id: mytimerlabel2
		text:  lampNotificationtime/1000

		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 18:14
		}
		anchors {
			top:mytimerlabel.top
			left:minText.right
			leftMargin:  isNxt ?  10 : 8
		}
	}
	

	NewTextLabel {
		id:plusText
		width: isNxt ? 55 : 45;  
		height: isNxt ? 40:32
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "+"
		anchors {
			top: minText.top
			left: mytimerlabel2.right
			leftMargin:isNxt ?  10 : 8
			}
		onClicked: {
			if (lampNotificationtime<100000){
				lampNotificationtime = lampNotificationtime +1000
			}
		}
	}
}




