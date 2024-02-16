import QtQuick 2.0

Item {
    id: root
    width: 660
    height: 600
    property alias cardOneVisible: tripCardOne.visible
    property alias cardTwoVisible: tripCardTwo.visible
    property string tripCardAString: ""
    property string tripCardBString: ""
    property string backgroundImage

    Image {
        anchors.fill: parent
        source: backgroundImage
        sourceSize.width: 660
        sourceSize.height: 600
    }

    Column {
        spacing: 10
        anchors{
            left: parent.left
            leftMargin: 60
            verticalCenter: root.verticalCenter
        }

        Item {
            id:odometer
            width: 540
            height:54

            Rectangle {
                anchors.fill: parent
                color: "#0DFFFFFF"
            }

            Text {
                id: odometerTitle
                width:parent.width/2
                height:parent.height
                anchors.left: parent.left
                text: qsTr("Odometer")
                font.pixelSize: 30
                color: "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                anchors.leftMargin: 24
            }

            Text {
                id: odometerValue
                width:parent.width/2
                height:parent.height
                anchors.right: parent.right
                text: qsTr("288,511 km")
                font.pixelSize: 28
                color: "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                anchors.rightMargin: 30
            }
        }

        Item {
            id:tripCardOne
            width: 540
            height:147
            Text {
                id: titleOne
                text: qsTr("Current")
                width: parent.width/2
                anchors {
                    left: parent.left
                    leftMargin: 24
                }
                height: 36
                font.pixelSize: 28
                color: "#FFDCB0"
            }

            Text {
                id: kmvalueOne
                text: qsTr("2010")
                width:156;height:36
                anchors {
                    top: titleOne.bottom
                    topMargin: 18
                }
                font.pixelSize: 30
                color: "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: qsTr("km")
                width:156;height:26
                anchors.top: kmvalueOne.bottom
                font.pixelSize: 22
                color: "#80FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                id: hrvalueOne
                text: qsTr("2")
                width:47;height:36
                anchors {
                    left: kmvalueOne.right
                    leftMargin: 54
                    top: kmvalueOne.top
                }
                font.pixelSize: 30
                color: "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: qsTr("h")
                width:47;height:26
                font.pixelSize: 22
                color: "#80FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors{
                    left: hrvalueOne.left
                    top: hrvalueOne.bottom
                }
            }

            Text {
                id: minvalueOne
                text: qsTr("46")
                width:47;height:36
                font.pixelSize: 30
                color: "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors {
                    left: hrvalueOne.right
                    leftMargin: 5
                    top: hrvalueOne.top
                }
            }

            Text {
                text: qsTr("min")
                width:47;height:26
                font.pixelSize: 22
                color: "#80FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors {
                    left: minvalueOne.left
                    top: minvalueOne.bottom
                }
            }

            Text {
                id: kwhvalueOne
                text: qsTr("500")
                width:156;height:36
                font.pixelSize: 30
                color: "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors {
                    right: parent.right
                    rightMargin: 6
                    top: minvalueOne.top
                }

            }

            Text {
                text: qsTr("kwh")
                width:156;height:26
                font.pixelSize: 22
                color: "#80FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors {
                    left: kwhvalueOne.left
                    top: kwhvalueOne.bottom
                }
            }
        }

        Item {
            id:tripCardTwo
            width: 540
            height:147

            Text {
                id: titleTwo
                text: qsTr("Fr.Last Charge")
                width: parent.width/2
                height: 36
                anchors {
                    left: parent.left
                    leftMargin: 24
                }
                font.pixelSize: 28
                color: "#FFDCB0"
            }

            Text {
                id: kmvalueTwo
                text: qsTr("5555")
                width:156;height:36
                anchors {
                    top: titleTwo.bottom
                    topMargin: 18
                }
                font.pixelSize: 30
                color: "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: qsTr("km")
                width:156;height:26
                anchors.top: kmvalueTwo.bottom
                font.pixelSize: 22
                color: "#80FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                id: hrvalueTwo
                text: qsTr("8")
                width:47;height:36
                anchors {
                    left: kmvalueTwo.right
                    leftMargin: 54
                    top: kmvalueTwo.top
                }
                font.pixelSize: 30
                color: "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: qsTr("h")
                width:47;height:26
                font.pixelSize: 22
                color: "#80FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors{
                    left: hrvalueTwo.left
                    top: hrvalueTwo.bottom
                }
            }

            Text {
                id: minvalueTwo
                text: qsTr("20")
                width:47;height:36
                font.pixelSize: 30
                color: "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors {
                    left: hrvalueTwo.right
                    leftMargin: 5
                    top: hrvalueTwo.top
                }
            }

            Text {
                text: qsTr("min")
                width:47;height:26
                font.pixelSize: 22
                color: "#80FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors {
                    left: minvalueTwo.left
                    top: minvalueTwo.bottom
                }
            }

            Text {
                id: kwhvalueTwo
                text: qsTr("5000")
                width:156;height:36
                font.pixelSize: 30
                color: "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors {
                    right: parent.right
                    rightMargin: 6
                    top: minvalueTwo.top
                }

            }

            Text {
                text: qsTr("kwh")
                width:156;height:26
                font.pixelSize: 22
                color: "#80FFFFFF"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors {
                    left: kwhvalueTwo.left
                    top: kwhvalueTwo.bottom
                }
            }
        }
    }

    /*收到TripInfo變化*/
    Connections {
        target: qtAndroidService
        function onTripInfos(odo,cardA,cardB){
            console.log("onTripInfos, (odo: " + odo + ",cardA: " + cardA + ",cardB: " + cardB +  ")");
            odometerValue.text = odo + " km";
            tripCardAString = cardA;
            tripCardBString = cardB;
        }
    }

    onTripCardAStringChanged: {
        if (tripCardAString.length != 0) {
            console.log("tripCardAString.length != 0");
            var stringList = tripCardAString.split(',');/*[0]:name,[1]:km,[2]:h,[3]:min,[4]:kwh*/
            titleOne.text = stringList[0];
            kmvalueOne.text = stringList[1];
            hrvalueOne.text = stringList[2];
            minvalueOne.text = stringList[3];
            kwhvalueOne.text = stringList[4];
            cardOneVisible = true

            stringList = null;
        } else {
            console.log("tripCardAString.length == 0");
            cardOneVisible = false
        }
    }

    onTripCardBStringChanged: {
        if (tripCardBString.length != 0) {
            console.log("tripCardBString.length != 0");
            var stringList = tripCardBString.split(',');/*[0]:name,[1]:km,[2]:h,[3]:min,[4]:kwh*/
            titleTwo.text = stringList[0];
            kmvalueTwo.text = stringList[1];
            hrvalueTwo.text = stringList[2];
            minvalueTwo.text = stringList[3];
            kwhvalueTwo.text = stringList[4];
            cardTwoVisible = true;

            stringList = null;
        } else {
            console.log("tripCardBString.length == 0");
            cardTwoVisible = false;
        }
    }

    Component.onCompleted: {
        console.log("Component.onCompleted");
        cardOneVisible = true;
        cardTwoVisible = true;
    }

}
