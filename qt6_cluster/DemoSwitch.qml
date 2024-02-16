import QtQuick 2.15
import QtQuick.Controls 2.15

Switch {
    id:root
    font.pixelSize: 25

    indicator: Rectangle {
        implicitHeight: 26
        implicitWidth: 52
        x:root.leftPadding
        y:parent.height/2-height/2
        radius: 13
        color: root.checked?"red":'#999999'
        border.color: root.checked?"#17a81a":"#cccccc"
        Rectangle {
            x:root.checked?parent.width - width:0
            width: 26;height: 26
            radius: 13;color: root.checked?"white":"white"
            border.color: root.checked?(root.down?"#17a81a":"#21be2b"):"#999999"
        }
    }

    contentItem: Text {
        text: root.text
        font:root.font
        opacity: enabled?1.0:0.3
        color: root.down?"black":"black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        leftPadding: root.indicator.width + root.spacing
    }
}
