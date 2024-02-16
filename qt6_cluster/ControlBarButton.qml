import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    width: 50;height: 40
    autoRepeatDelay: 100

    background: Rectangle {
        radius: 5
        anchors.fill: parent
        color: "lightsalmon"
    }
}
