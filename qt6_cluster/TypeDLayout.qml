import QtQuick 2.15

Item {
    id:root
    property int speedValue: 0 //當前時速
    property bool switchNaviRemain: true
    property string costTime: "40 min" //抵達目的地所需分鐘數
    property int totalKm: 180 //抵達目的地所需公里數
    property string arrivalTime: "12:50 AM"//抵達目的地的時間
    property bool switchNaviNext: true
    property real nextRoadDistance: 20 //下一個路口距離
    property string nextRoadName: "N Jackson St"//下一個路口名字
    property var displayModeList /*由main指定含有的playMode*/
    property string currentPlayMode /*當前指定的playMode*/

    Image {
        id:image
        width: 1800;height: 960 //540 //
        source: "qrc:/assets/fsd3dmodel_1920x1080.png" //fsd3dmodel.png
        sourceSize.width: 1800
        sourceSize.height: 960 //540 //
    }

    Text {
        id:speed
        width: 240
        height: 144
        color: "white"
        text: root.speedValue
        font.pixelSize: 120
        anchors.top: image.top
        anchors.left: image.left
        anchors.topMargin: 774 //350
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        color: "#088169"
        text: "km/h"
        font.pixelSize: 38
        /*1920x720 version
        anchors.top:speed.bottom
        anchors.horizontalCenter: speed.horizontalCenter*/
        // 1920x1080 version
        anchors.bottom: speed.bottom // 對齊底緣
        anchors.left: speed.right // 設置左錨點為 id:speed 的右邊緣
        anchors.leftMargin: 10 // 調整左邊距
        font.weight: Font.Normal
    }

    Item {
        id: naviRemain
        visible: root.switchNaviRemain
        width: 600 //300
        height: 102
        anchors.right: image.right
        anchors.top:image.top
        anchors.topMargin: 855 //438

        Rectangle{
            anchors.fill: parent
            radius:12
            gradient: Gradient {
                GradientStop {
                    position: 0.0;color: "#E6374845"
                }
                GradientStop {
                    position: 1.0;color: "#E6133832"
                }
            }
        }

        Text {
            id:costtime
            //車程時間
            color: "white"
            text: root.costTime
            anchors.top: parent.top
            anchors.topMargin: 12
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 38
            font.weight: Font.Normal
        }

        Row{
            anchors.top: costtime.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 15
            Text {
                //抵達目的地剩餘公里數
                color: "white"
                text: root.totalKm + " km"
                font.pixelSize: 30
                font.weight: Font.Normal
            }

            Rectangle {
                anchors.top: parent.top
                anchors.topMargin: 13

                width: 6;height: 6
                color: "white"
                radius: 3
            }

            Text {
                //預計抵達時間
                color: "white"
                text: root.arrivalTime
                font.pixelSize: 30
                font.weight: Font.Normal
            }
        }
    }

    Item {
        id: naviNext
        visible: root.switchNaviNext
        width: 390;height: 120
        anchors.right: image.right
        anchors.top: image.top
        anchors.topMargin: 45 //12

        Rectangle {
            anchors.fill: parent
            radius:12
            gradient: Gradient {
                GradientStop {
                    position: 0.0;color: "#E6374845"
                }
                GradientStop {
                    position: 1.0;color: "#E6133832"
                }
            }
        }

        Row {
            anchors.centerIn: parent
            spacing: 20

            Image {
                anchors.verticalCenter: parent.verticalCenter
                width: 60;height: 60
                source: "qrc:/assets/icon_turn_left.png"
                sourceSize.width: 60
                sourceSize.height: 60
            }

            Column {
                width: 270
                Text {
                    id: meter
                    text: root.nextRoadDistance.toFixed(1).toString() + " m"
                    font.pixelSize: 46
                    color: "white"
                    font.weight: Font.Normal
                }

                Text {
                    id: roadname
                    font.pixelSize: 30
                    text: root.nextRoadName
                    color: "white"
                    font.weight: Font.Normal
                }

            }
        }
    }
}
