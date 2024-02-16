import QtQuick 2.15

Item {
    id: m_Navigation
    width: 480
    height: 144
    property alias text_roadText: text_road.text
    property alias text_distanceText: text_distance.text
    property real nextRoadDistance: 20.0 //下一個路口距離
    property string nextRoadName: "Zhongxiao E Rd"//下一個路口名字
    property string nextRoadIcon: "qrc:/assets/icon_navi_right_merged_child1.png"

    Text {
        id: text_distance
        x: 0
        y: 108
        width: 481
        height: 36
        color: "#FFFFFF"
        opacity: 0.5
        text: nextRoadDistance.toFixed(1).toString() + "km"
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Text {
        id: text_road
        x: 0
        y: 72
        width: 481
        height: 36
        color: "#ffffff"
        text: nextRoadName
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Image {
        id: icon_navi_right
        x: 206
        y: 0
        width: 60
        height: 60
        source:nextRoadIcon
        sourceSize.width: 60
        sourceSize.height: 60
    }

//    Timer {
//        id:demoA2timer
//        interval: 4000; running: true; repeat: true;
//        onTriggered: {
//            distanceNumber = (distanceNumber - 0.1).toFixed(1)

//            text_distanceText = distanceNumber.toString() + " km"
//        }
//        triggeredOnStart:false
//    }

//    onVisibleChanged: {
//        if(!visible) {
//            distanceNumber = 20
//        }
//    }

//    onDistanceNumberChanged: {
//        if(distanceNumber <= 10)
//            demoA2timer.stop()
//    }
}
