//Textanimation
import QtQuick 2.1

Item {
    id: voetbalanimation
    property bool dimState: screenStateController.dimmedColors

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
		color: "white"
		anchors.fill: parent 
		radius: 4
     		Text{
         		id:text1
         		anchors.centerIn: parent
			width: parent.width
			font.pixelSize:  isNxt ? 30 : 22
			font.family: qfont.regular.name
			font.bold: true
			color:  "black" 
         		text: app.firstlinescreentext     		
		}
    		MouseArea{
         		id: buttonMouseArea
         		anchors.fill: parent 
         		onClicked: {buttonLabel.text = "Clicked";textanimation.destroy();}
     		}		
	}
    }

}