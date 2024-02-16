import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Timeline 1.0
import Qt5Compat.GraphicalEffects
//import QtGraphicalEffects 1.15
Window {
    id:root
    width: 1920
    height: 1080 //720
    visible: true
    color: '#ff000000'
    title: qsTr("Cluster 1920x1080")
    property int speedValue: 0
    property int chargeValue:0
    property int lostKwh:0
    property string currentPlayMode: "normal" /*當前指定的playMode*/
    // normal, comfort, sport

    MainScreen {
        width: 1920;height: 1080 //720
        speedValue: root.speedValue
        chargeValue: root.chargeValue
        lostKwh: root.lostKwh
    }
}
