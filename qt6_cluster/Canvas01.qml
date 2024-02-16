import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id:speedMask
    width: 800; height: 600
    property int speed: 50

    Canvas {
        id:speedCurve
        width: parent.width
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        property real alpha: 1.0
        property real scale : 1
        x: 0
        y: 0

        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = 5
            ctx.strokeStyle = "powderblue"

            ctx.save();
            ctx.clearRect(0, 0, canLevel1.width, canLevel1.height);
            ctx.beginPath()
            ctx.lineCap = "round"
            ctx.moveTo(700,165)//右上
            ctx.lineTo(406,86)
            ctx.lineTo(99,185)
            ctx.lineTo(99,434)
            ctx.lineTo(406,535)
            ctx.lineTo(700,458)
            ctx.stroke()

        }

    }

    Text {
        id: speedvalue
        text: qsTr(speedMask.speed.toString())
        font.pixelSize: 86
        anchors.centerIn: parent

    }

    Text {
        color: "cornflowerblue"
        font.pixelSize: 40

        text: qsTr("km/h")
    }
}
