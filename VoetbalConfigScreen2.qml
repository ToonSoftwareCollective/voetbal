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
	property string  selectedteamsText : ""
	
	property int notificationtime

	
	
	onShown: {
		addCustomTopRightButton("Opslaan")
		notificationtime = app.notificationtime
		getTeams()
		selectedteams = app.selectedteams
		selectedTeamstoText()
	}

	onCustomButtonClicked: {
		app.selectedteams = selectedteams
		app.notificationtime = notificationtime
		app.saveSettings()
		hide()
	}

	function selectedTeamstoText(){
		var newArray = selectedteams.split(';')
		for(var x2 = 0;x2 < newArray.length;x2++){
			//console.log("Teamsarray: " + newArray[x2])
			if (x2==0){
					selectedteamsText = newArray[x2]
				}else{
					selectedteamsText = selectedteamsText + ", " + newArray[x2]
				}
		}
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
/////////////////////////////////////////////////////////////////////////

	Text {
		id: mytexttop1
		//text: "Select your favorite teams. When a goal is scored in a match of your selected team(s) you will get a notification"
		text: "Krijg een notificatie als gescoord wordt in een wedstrijd van je favoriete club(s)"
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 18:14
		}
		anchors {
			top:parent.top
			left:parent.left
			leftMargin: isNxt ? 10 :8
			topMargin: isNxt ? 5 :4
		}
	}
	
	Text {
		id: mytexttop2
		//text: "Select from list:"
		text: "Selecteer:"
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 18:14
		}
		anchors {
			top:mytexttop1.bottom
			left:mytexttop1.left
			topMargin: isNxt ? 10 :8
		}
	}
	
	Rectangle{
		id: listviewContainer1
		width: isNxt ? parent.width/2 -100 : parent.width/2 - 80
		height: isNxt ? 220 : 190
		color: "white"
		radius: isNxt ? 5 : 4
		border.color: "black"
			border.width: isNxt ? 3 : 2
		anchors {
			top:		mytexttop2.bottom
			topMargin: 	8
			left:   	mytexttop1.left
		}

		Component {
			id: aniDelegate
			Item {
				width: isNxt ? (parent.width-20) : (parent.width-16)
				height: isNxt ? 22 : 18
				Text {
					id: tst
					text: name
					font.pixelSize: isNxt ? 18:14
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
			leftMargin : isNxt? 3 : 2
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
			leftMargin : isNxt? 3 : 2

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
			topMargin: isNxt? 5: 4
			}
		onClicked: {
			if (selectedteams.indexOf(teamsShort[listview1.currentIndex]) == -1){
				if  (selectedteams.length<1){
					selectedteams = teamsShort[listview1.currentIndex]
					selectedteamsText = teamsShort[listview1.currentIndex]
				}else{
					selectedteams += ";" + teamsShort[listview1.currentIndex]
					selectedteamsText += ", " + teamsShort[listview1.currentIndex]
				}
			}
		}
	}


	Text {
		id: mytext1
		//text: "Selected Teams (shortnames): "
		text: "Geselecteerde clubs: "
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
		id: teamText
		color: "white"
		width: isNxt ? parent.width/2 - 100 : parent.width/2 - 80
		height: isNxt ? listviewContainer1.height-120  : listviewContainer1.height-100		
		Text{
			id: tText
			width: parent.width
			font.pixelSize: isNxt? 18:14
			wrapMode: Text.WordWrap
         	text: selectedteamsText
			font.family: qfont.regular.name
			color: "black"
     	}
		anchors {
			top: listviewContainer1.top
			left:mytext1.left	
		}
	}
	
	NewTextLabel {
		id: clearText
		width: isNxt ? 120 : 96;  
		height: isNxt ?  40:32
		buttonActiveColor: "red"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		//buttonText:  "Clear"
		buttonText:  "Verwijder"
		anchors {
			top: teamText.bottom
			left: teamText.left
			topMargin: 8
		}
		onClicked: {
			selectedteams= ""
			selectedteamsText = ""
		}
		visible: (selectedteamsText.length>1)
	}
	

	Text {
		id: mytimerlabel
		//text: "Time for notification (seconds): " 
		text: "Tijd van de notificatie (seconden): "
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 18:14
		}
		anchors {
			top:addText.bottom
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
			if (notificationtime<100000){
				notificationtime = notificationtime +1000
			}
		}
	}
}




