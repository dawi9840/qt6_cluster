import QtQuick 2.15
import QtQuick.Window 2.15

Item {
    id:root
    property int radioIndex:0
    property string radioListString:""
    onRadioIndexChanged: {
        console.log("radioIndex is Change, radioIndex = " + radioIndex);
        if (radioIndex < 0){
            mListView.currentIndex = 0;
        } else if (radioIndex >= 0 && radioIndex < mListView.count) {
            mListView.currentIndex = root.radioIndex;
        } else {
            mListView.currentIndex = mListView.count-1;
        }

    }

    Component {
        id:mRadioModel
        ListModel {
            ListElement {
                name: "Polly"
                type: "Parrot"
                age: 1
            }
            ListElement {
                name: "Penny"
                type: "Turtle"
                age: 2
            }
            ListElement {
                name: "Warren"
                type: "Rabbit"
                age: 3
            }
            ListElement {
                name: "Spot"
                type: "Dog"
                age: 4
            }
            ListElement {
                name: "Schrödinger"
                type: "Cat"
                age: 5
            }
            ListElement {
                name: "Joey"
                type: "Kangaroo"
                age: 6
            }
            ListElement {
                name: "Kimba"
                type: "Bunny"
                age: 7
            }
            ListElement {
                name: "Rover"
                type: "Dog"
                age: 8
            }
            ListElement {
                name: "Tiny"
                type: "Elephant"
                age: 9
            }
            ListElement {
                name: "Tiny"
                type: "Elephant"
                age: 10
            }
        }
    }

    Component {
        id: dragDelegate
        Item {
            id: content
            height:243
            width:ListView.isCurrentItem ? 280:190
            y:ListView.isCurrentItem ? -45:0

            Image {
                id: radioImageBackground
                source: "qrc:/assets/radio_cover_b_shadow_280.png"
                anchors.horizontalCenter: parent.horizontalCenter
                width:content.ListView.isCurrentItem ? 280:190
                height:content.ListView.isCurrentItem ? 280:190
                sourceSize.width: 280
                sourceSize.height: 280
            }

            Image {
                id: radioImage
                source: "qrc:/assets/radio_cover_b_normal_240.png"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: radioImageBackground.top
                anchors.topMargin: 10
                width:content.ListView.isCurrentItem ? 240:160
                height:content.ListView.isCurrentItem ? 240:160
                sourceSize.width: 240
                sourceSize.height: 240
            }

            Text {
                id:radioName
                font.pixelSize: content.ListView.isCurrentItem ? 30:22
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top:radioImageBackground.bottom
                anchors.topMargin: 0
                color: "#FFFFFF"
                text: name
                opacity: content.ListView.isCurrentItem ? 1:0.6
            }
            Text {
                font.pixelSize: content.ListView.isCurrentItem ? 30:22
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: radioName.bottom
                anchors.topMargin: 3
                color: "#80FFFFFF"
                text: age
                opacity: content.ListView.isCurrentItem ? 1:0.6
            }

            onFocusChanged: {
                console.log("onFocusChanged,Index = " + index);
            }
        }
    }

    ListView {
        id: mListView
        orientation: ListView.Horizontal
        width:280
        height:243

        currentIndex:0
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        model: mRadioModel.createObject(mListView)
        delegate: dragDelegate

        spacing: -10
        cacheBuffer: 50
    }

    onRadioListStringChanged: {
        if (radioListString.length != 0) {
            var list = radioListString.split(",");
            for (var i=0;i<list.length;i++){
                var data = list[i].split("&");
                console.log("index = " + i);
                console.log("data[0] = " + data[0]);
                console.log("data[1] = " + data[1]);
            }
        }

        list = null;
        i = null;
        data = null;
    }
}
