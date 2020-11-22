import QtQuick 2.1
import BasicUIControls 1.0
import qb.components 1.0

Screen {
	id: voetbalConfigScreen
	screenTitle: "Voetbal App Setup"
	property bool bridgefound: false
	
	
	onShown: {
		getLamps()
	}
	
	function getLamps(){
		bridgefound=false
		var doc = new XMLHttpRequest();
			doc.onreadystatechange = function() {
					if (doc.readyState == XMLHttpRequest.DONE) {
						var lampsfile = doc.responseText;
						var lampsArray = lampsfile.split('<device>')
						for(var x0 = 0;x0 < lampsArray.length;x0++){
							//console.log("Searching for Hue Bridge : "  + lampsArray[x0])
							var found0 = lampsArray[x0].indexOf('<type>hue_bridge')
							found0 = lampsArray[x0].indexOf('<type>hue_bridge')
								if (found0>1){
									var n20 = lampsArray[x0].indexOf('<uuid>') + 6
									//console.log("Found <uuid> : "  + n20)
									var n21 = lampsArray[x0].indexOf('</uuid>',n21)
									var bridgeuuid = lampsArray[x0].substring(n20, n21)
									console.log("Found Hue Bridge : "  + bridgeuuid)
									if (bridgeuuid.length>10){// bridge found
										bridgefound=true
									}
									break
								}
						}
					}
			}
		doc.open("GET", "file:////qmf/config/config_hdrv_hue.xml", true);
		doc.setRequestHeader("Content-Encoding", "UTF-8");
		doc.send();
	}
	
	
	NewTextLabel {
		id: setupText
		width: isNxt ? parent.width-60 : parent.width - 48
		height: isNxt ? 100 :  80
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		//buttonText:  "Setup Favourite Teams"
		buttonText:  "Configureer Favoriete Clubs (Eredivisie)"
		anchors {
			top: parent.top
			horizontalCenter: parent.horizontalCenter
			topMargin: isNxt ? 5 : 4
			}
		onClicked: {
			onClicked: {stage.openFullscreen(app.voetbalConfigScreenUrl2)}	
		}
	}

	NewTextLabel {
		id: setupText2
		width: isNxt ? parent.width-60 : parent.width - 48
		height: isNxt ? 100 :  80
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		//buttonText:  "Setup Favourite Teams"
		buttonText:  "Configureer Favoriete Landen (Europees/Wereld Kampioenschap en Olymische Spelen)"
		anchors {
			top: setupText.bottom
			horizontalCenter: parent.horizontalCenter
			topMargin: isNxt ? 5 : 4
			}
		onClicked: {
			onClicked: {stage.openFullscreen(app.voetbalConfigScreenUrl4)}	
		}
	}

	NewTextLabel {
		id: setupText3
		width: isNxt ? parent.width-60 : parent.width - 48
		height: isNxt ? 100 :  80
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		//buttonText:  "Setup Hue Lamps"
		buttonText:  "Configureer Hue Lampen"
		anchors {
			top: setupText2.bottom
			left: setupText.left
			topMargin: isNxt ? 5 : 4
			}
		onClicked: {
			onClicked: {stage.openFullscreen(app.voetbalConfigScreenUrl3)}	
		}
		visible: bridgefound
	}
	
	MouseArea {
		height : 80
		width : 80
		anchors {
			bottom: parent.bottom
			right: parent.right
			rightMargin: 0
			bottomMargin:0
		}
		onClicked: {
			app.isDemoMode = !app.isDemoMode
			app.showmatchesontile = false
			console.log("clicked demo mode")
		}
		//visible:false //DELETE THIS to enable demo mode
	}

	Text{
		id:demoMode
		font.pixelSize:  isNxt ? 16 : 12
		font.family: qfont.regular.name
		color:  "red" 
		text: app.isDemoMode? "Demo" : ""
		anchors {
			bottom: parent.bottom
			right: parent.right
			rightMargin: 10
			bottomMargin:10
	 		
		}    		
	}

}




