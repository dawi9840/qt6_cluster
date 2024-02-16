import QtQuick 2.15

Item {
    id: text_Battery
    width: 414
    height: 42

//    property alias text_batteryText: text_battery.text
    property alias text_milageText: text_milage.text
    property alias text_SocText: text_soc.text
    property string batteryStatus: "Regular" /* Regular:未充電;Charge:充電中;Unstable:充電異常;Completed:充電完成;Error:充電異常;Scheduled:排程中*/
    property alias power_w_BatteryRegular: battery_regular.batteryPowerWidth

    // battery_regular
    onBatteryStatusChanged: {
        if (batteryStatus === "Regular" ||batteryStatus === "Completed") {
            battery_charge.visible = false;
            battery_regular.visible = true;
            battery_unstable.visible = false;
            text_battery.visible = false;
        } else if (batteryStatus === "Charge") {
            battery_charge.visible = true;
            battery_regular.visible = false;
            battery_unstable.visible = false;
            text_battery.visible = false;
        } else if (batteryStatus === "Unstable") {
            battery_charge.visible = false;
            battery_regular.visible = false;
            battery_unstable.visible = true;
            text_battery.visible = false;
        } else if (batteryStatus === "Error") {
            battery_charge.visible = false;
            battery_regular.visible = false;
            battery_unstable.visible = true;
            text_battery.visible = false;
        } else if (batteryStatus === "Scheduled") {
            text_battery.visible = true;
            battery_charge.visible = false;
            battery_regular.visible = true;
            battery_unstable.visible = false;
        }
    }

    Text {
        id: text_battery
        x: 0
        y: 6
        width: 255
        height: 36
        color: "#ffffff"
        opacity: 0.5
        text: "Scheduled Charging"
        visible: false
        font.pixelSize: 30
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Text {
        id: text_soc
        x: 280//267
        y: 6
        height: 36
        color: "#ffffff"
        text: "100" + " %"
        font.pixelSize: 30
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Text {
        id: text_milage
        x: 150//267
        y: 6
        height: 36
        color: "#ffffff"
        text: "1023" + " km"
        font.pixelSize: 30
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    BatteryRegular {
        id: battery_regular
        x: 372
        y: 0
        width: 42
        height: 42
        visible:true
    }

    Image {
        id: battery_charge
        x: 372
        y: 0
        width: 42
        height: 42
        visible:false
        source:"qrc:/assets/icon_battery_charge.png"
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {
        id: battery_unstable
        x: 372
        y: 0
        width: 42
        height: 42
        visible:false
        source:"qrc:/assets/icon_charge_unstabled.png"
        sourceSize.width: 42
        sourceSize.height: 42
    }
}
