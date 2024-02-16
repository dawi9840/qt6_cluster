import QtQuick 2.15

Item {
    id: battery_regular
    width: 42
    height: 42
    property real batteryPowerWidth: 30;

    Rectangle {
        id: icon_battery_regular
        x: 0
        y: 0
        width: 42
        height: 42
        color: "transparent"
        Item {
            id: icon_battery_regular_merged_child
            x: 0
            y: 0
            width: 42
            height: 42
            Image {
                id: icon_battery_regular_merged_child1
                x: 0
                y: 0
                source: "qrc:/assets/icon_battery_regular_merged_child1.png"
                sourceSize.width: 42
                sourceSize.height: 42
            }
        }
    }

    Rectangle {
        id: icon_battery_regular_power // battery
        x: 4
        y: 14
        width: batteryPowerWidth // default 30
        height: 14
        color: "#21ff79"
        radius: 2
    }
}
