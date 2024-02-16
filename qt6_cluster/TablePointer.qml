import QtQuick 2.15

Item {
    id:root
    property int initAngle
    property string source
    property int speed
    property real rotateAngle: 0
    property point centerPos
    property point startPos
    property point endPos
    property var posList
    property bool positive: true
    property var pointAngle;

    Image {
        id:pointer
        anchors.fill: parent
        source: root.source
        rotation: root.initAngle
        sourceSize.width: parent.width
        sourceSize.height: parent.height
    }

    onSpeedChanged: {
        if(positive){
            getTwoPointAngle(root.speed);
            pointer.rotation = root.initAngle + root.pointAngle;
        } else {
            getTwoPointAngle(root.speed);
            pointer.rotation = root.initAngle - root.pointAngle;
        }
    }

    function getTwoPointAngle(spd) {
        //find posIdx
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
        root.endPos = Qt.point(posX,posY)
        const dx1 = startPos.x - centerPos.x
        const dy1 = startPos.y - centerPos.y
        const dx2 = endPos.x - centerPos.x
        const dy2 = endPos.y - centerPos.y
        var angle1 = Math.atan2(dy1,dx1)
        angle1 = (angle1 *180)/Math.PI
//        console.log("angle1 = " + angle1)

        var angle2 = Math.atan2(dy2,dx2)
        angle2 = (angle2*180)/Math.PI
//        console.log("angle2 = " + angle2)

        if (angle1*angle2 >= 0) {
            var included_angle = Math.abs(angle1-angle2)
        } else {
            included_angle = Math.abs(angle1) + Math.abs(angle2)
            if (included_angle >180) {
                included_angle = 360 - included_angle
            }
        }

        root.pointAngle = included_angle;

        posIdx = null;
        startValue = null;
        startPoint = null;
        endValue = null;
        endPoint = null;
        percent = null;
        posX = null;
        posY = null;
        angle1 = null;
        angle2 = null;
        included_angle = null;
    }
}
