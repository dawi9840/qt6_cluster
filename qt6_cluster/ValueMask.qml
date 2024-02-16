import QtQuick 2.15
import Qt5Compat.GraphicalEffects
//import QtGraphicalEffects 1.15

Item {
    id:root
    property string maskSource
    property string source
    property int speed:0/*當前時速*/
    property var posList
    property int sourceWidth
    property int sourceHeight
    property point pointPos
    property bool sourceVisible:false
    clip: true

    Image {
        id:sourceMask
        source:maskSource
        anchors.fill: parent
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        visible: root.sourceVisible
    }

    Item {
        id:sourceItem
        anchors.fill: parent
        visible: root.sourceVisible
        Image {
            id:sourceImg
            source: root.source
            x:pointPos.x;y:pointPos.y
            width: root.sourceWidth
            height: root.sourceHeight
            sourceSize.width: root.sourceWidth
            sourceSize.height: root.sourceHeight
        }
    }

    OpacityMask {
        id:speedOpacityMask
        anchors.fill: parent
        visible: true
        source: sourceItem;
        maskSource: sourceMask
    }

    onSpeedChanged: {
        //find posIdx
        var spd = root.speed;
        for(var posIdx=0; posIdx<posList.length; posIdx++) {
            if (posList[posIdx]['value'] >= spd) {
                break
            }
        }

        if (posIdx == 0){
            return
        }

        var startValue = posList[posIdx-1]['value']
        var startPoint = posList[posIdx-1]['point']
        var endValue = posList[posIdx]['value']
        var endPoint = posList[posIdx]['point']
        var percent = (spd-startValue)/(endValue-startValue)

        var posX = (endPoint.x - startPoint.x)*percent + startPoint.x
        var posY = (endPoint.y - startPoint.y)*percent + startPoint.y
        root.pointPos = Qt.point(posX,posY)

        spd = null;
        posIdx = null;
        startValue = null;
        startPoint = null;
        endValue = null;
        endPoint = null;
        percent = null;
        posX = null;
        posY = null;
    }
}
