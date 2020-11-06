//Textanimation
import QtQuick 2.1
import FileIO 1.0

Item {
    id: voetbalanimation
    property bool dimState: screenStateController.dimmedColors
	
	property  string	teams : ""
	property  string	scores : ""

	FileIO {
		id: voetbalFile
		source: "file:///HCBv2/qml/apps/voetbal/newScore.json"
 	}
	
	property variant newScores : {
		"teams" : "",
		"score" : ""
	}
	
	Timer { //allow some time for the app to close the file
		id: newTimer
		running: true
		repeat: false
		interval: 500
		onTriggered: {
			newScores = JSON.parse(voetbalFile.read())
			teams = newScores['teams']	
			scores = newScores['score']	
		}
	}

    width: 500
    height: 250
    x : (parent.width - voetbalanimation.width)/2
    y : (parent.height- voetbalanimation.height)/2

    Item {
        id: sprite
        anchors.centerIn: parent
		height: parent.height
        width: parent.width
        clip: true

        transform: Rotation {
           id: rotator
           origin{
               x: voetbalanimation.width/2
               y: voetbalanimation.height/2
            }
            angle: 0
        }

        SequentialAnimation {
            id: shake
            PropertyAnimation { easing.type: Easing.InQuad; duration: 1000; target: rotator; property: "angle"; to: 5 }
            PropertyAnimation { easing.type: Easing.InQuad; duration: 1000; target: rotator; property: "angle"; to: -5 }
        }

        Timer {
            running: true
            repeat: true
            interval: 2000
            onTriggered: {
                shake.restart();
            }
        }

		Rectangle {
			id: spriteImage
			color: "lightgreen"
			anchors.fill: parent 
			radius: 4   
			Text{
				id:text1
				font.pixelSize:  isNxt ? 30 : 22
				font.family: qfont.regular.name
				font.bold: true
				color:  "red" 
				text: teams
				anchors {
					top: parent.top
					topMargin: 30
					horizontalCenter: parent.horizontalCenter	 		
				}    		
			}
			Text{
				id:text2
				font.pixelSize:  isNxt ? 80 : 65
				font.family: qfont.regular.name
				font.bold: true
				color:  "red" 
				text: scores
				anchors {
					top: text1.bottom
					topMargin: 20
					horizontalCenter: parent.horizontalCenter	 		
				}    		
			}
			
			MouseArea{
				id: buttonMouseArea
				anchors.fill: parent 
				onClicked: {animationscreen.animationRunning= false;voetbalanimation.destroy();}
			}		
		}
    }
	
	Timer {
		interval: 2500
		running: true
		repeat: true
		onTriggered: {
		if (animationscreen.animationRunning==false) {
					voetbalanimation.destroy();
				}
	}
}

}