import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    property string messageTitleText: "Receive: "
    property string messageFromServiceText: "default_text"

    title: qsTr("Test")
    visible: true
    width: 1280
    height: 720
    color:"black"

    Text {
        id:displayText
        x:100;y:400;
        width:500
        height:50
        visible:true
        font.pixelSize:90
        text: messageTitleText
        color: "green"
    }

    Text {
        id:testText
        x:450;y:500;
        width:500
        height:50
        visible:true
        font.pixelSize:90
        text: messageFromServiceText
        color: "yellow"
    }

    Connections {
        target: qtAndroidService

        function onMessageFromService(message) {
            console.log("qml_onMessageFromService");
             console.log("message: " + message);
            messageFromServiceText = message;
        }

//        function onSignalChange(iconId, iconStatus){
//            console.log("dawi_mainScreen_onSignalChange")
//            if (iconStatus === "Opened") {
//                console.log("Signal: " + iconId );
//                console.log("Status: " + iconStatus + "\n======\n");
//                messageTitleText = iconId;
//                messageFromServiceText = iconStatus;
//            } else if (iconStatus === "Closed") {
//                console.log("Signal: " + iconId );
//                console.log("Status: " + iconStatus + "\n======\n");
//                messageTitleText = iconId;
//                messageFromServiceText = iconStatus;
//            }
//        }
    }
}
