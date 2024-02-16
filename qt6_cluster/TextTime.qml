import QtQuick 2.15

Item {
    id: text_Time
    width: 240
    height: 42
    property alias text_timeText: text_time.text
    property alias text_tempText: text_temp.text

    property var locale: Qt.locale("en_US")

    Text { //text unit: "°C"
        id: text_temp
        x: 0
        y: 0
        width: 100//80
        height: 36
        color: "#ffffff"
        text: "25°C"
        font.pixelSize: 30
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Text {
        id: text_time
        x: 90
        y: 0
        width: 151
        height: 36
        color: "#ffffff"
        text: "HH:MM AM"
        font.pixelSize: 30
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Timer {
        id:timer
        interval: 1000; running: true; repeat: true;
        onTriggered: text_Time.timeChanged()
        triggeredOnStart:true
    }

    function timeChanged() {
        var timeString = new Date().toLocaleTimeString(locale,"h:mm AP");
        text_time.text = timeString.toString();
        timeString = null;
    }
}
