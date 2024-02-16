import QtQuick 2.15

Item {
    id: r_Status
    width: 660
    height: 600
    property alias text_tpms_4Text: text_tpms_4.text
    property alias text_tpms_2Text: text_tpms_2.text
    property alias text_temp_motorText: text_temp_motor.text
    property alias text_temp_3Text: text_temp_3.text
    property alias text_tpms_3Text: text_tpms_3.text
    property alias text_tpms_1Text: text_tpms_1.text
    property alias text_temp_1Text: text_temp_1.text
    property alias text_temp_2Text: text_temp_2.text
    property alias text_temp_4Text: text_temp_4.text
    property alias text_motorText: text_motor.text

    property string imgCarTop

    Image {
        id: blur_tire_4
        x: 321
        y: 324
        width: 120
        height: 120
        visible: false
        source: "qrc:/assets/blur_tire_41.png"
        sourceSize.width: 120
        sourceSize.height: 120
    }

    Image {
        id: blur_tire_3
        x: 219
        y: 324
        width: 120
        height: 120
        visible: false
        source: "qrc:/assets/blur_tire_31.png"
        sourceSize.width: 120
        sourceSize.height: 120
    }

    Image {
        id: blur_tire_2
        x: 321
        y: 156
        width: 120
        height: 120
        visible: false
        source: "qrc:/assets/blur_tire_21.png"
        sourceSize.width: 120
        sourceSize.height: 120
    }

    Image {
        id: blur_tire_1
        x: 219
        y: 156
        width: 120
        height: 120
        visible: false
        source: "qrc:/assets/blur_tire_11.png"
        sourceSize.width: 120
        sourceSize.height: 120
    }

    Image {
        id: car_top
        width: parent.width
        height: parent.height
        source: imgCarTop
        sourceSize.width: parent.width
        sourceSize.height: parent.height
    }

    Text {
        id: text_temp_motor
        x: 392
        y: 525
        width: 58
        height: 36
        color: "#ffffff"
        opacity: 0.5
        text: "98°C"
        font.pixelSize: 30
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Text {
        id: text_motor
        x: 210
        y: 525
        width: 152
        height: 36
        color: "#ffffff"
        opacity: 0.5
        text: "Motor Temp"
        font.pixelSize: 30
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Text {
        id: text_temp_4
        x: 438
        y: 399
        width: 126
        height: 36
        color: "#ffffff"
        opacity: 0.5
        text: "89°C"
        font.pixelSize: 30
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Text {
        id: text_tpms_4
        x: 438
        y: 345
        width: 126
        height: 46
        color: "#ffffff"
        text: "38 psi"
        font.pixelSize: 38
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Rectangle {
        id: tire_4
        x: 582
        y: 354
        width: 3
        height: 72
        color: "#21FF79"
    }

    Text {
        id: text_temp_3
        x: 96
        y: 399
        width: 126
        height: 36
        color: "#ffffff"
        opacity: 0.5
        text: "89°C"
        font.pixelSize: 30
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Text {
        id: text_tpms_3
        x: 96
        y: 345
        width: 126
        height: 46
        color: "#ffffff"
        text: "38 psi"
        font.pixelSize: 38
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Rectangle {
        id: tire_3
        x: 75
        y: 354
        width: 3
        height: 72
        color: "#21FF79"
    }

    Text {
        id: text_temp_2
        x: 438
        y: 219
        width: 126
        height: 36
        color: "#ffffff"
        opacity: 0.5
        text: "90°C"
        font.pixelSize: 30
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Text {
        id: text_tpms_2
        x: 438
        y: 165
        width: 126
        height: 46
        color: "#ffffff"
        text: "39 psi"
        font.pixelSize: 38
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
        font.bold: true
    }

    Rectangle {
        id: tire_2
        x: 582
        y: 174
        width: 3
        height: 72
        color: "#21FF79"
    }

    Text {
        id: text_temp_1
        x: 96
        y: 219
        width: 126
        height: 36
        color: "#ffffff"
        opacity: 0.5
        text: "90°C"
        font.pixelSize: 30
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Text {
        id: text_tpms_1
        x: 96
        y: 165
        width: 126
        height: 46
        color: "#ffffff"
        text: "39 psi"
        font.pixelSize: 38
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Rectangle {
        id: tire_1
        x: 75
        y: 174
        width: 3
        height: 72
        color: "#21FF79"
    }
}
