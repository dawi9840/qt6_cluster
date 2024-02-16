import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
//import QtGraphicalEffects 1.15
import QtQuick.Timeline 1.0

Item {
    id:root
//    property int speedValue: mainscreenRoot.speedValue
//    property int chargeValue:0
//    property int lostKwh:0
    property int defaultIndex: 0/*右側預設顯示Count 0~4; 3:ismap.png */
    property string currentGear: 'gear_stop'
    property int animateTime:1000
    property alias swipeIndex: swipeview.count
    property alias middle_adasRegion: middleADAS
    property alias middle_bg:middleBG
    property alias middle_NavRegion: middleNav

    property bool switchDoor_FL: false
    property bool switchDoor_FR: false
    property bool switchDoor_RL: false
    property bool switchDoor_RR: false
    property bool switchEngine: false
    property bool switchTrunk: false
    property bool displayMusicInfo:false//-----------------false;true
    property string musicTrackName:"Photograph"
    property string musicArtistName:"紅髮艾德"
    property alias musicDuration: rightMusic.progressbarmaximumValue
    property alias musicCurrPos:rightMusic.progressbarValue
    property alias musicThumbPath:rightMusic.imgMusicAlbum
    property bool switchNaviNext: true
    property real nextRoadDistance: 20 //下一個路口距離
    property string nextRoadName: "Zhongxiao E Rd"//下一個路口名字
    property string oldPlayMode: "" /*當前指定的playMode*/
    property string currentPlayMode: "NORMAL" /*當前指定的playMode*/
    property string normalAnimateStatus: 'IN'
    property string comfortAnimateStatus: 'OUT'
    property string sportAnimateStatus: 'OUT'
    property int radioIdx:0
    property int musicType:0

    states: [
        State {
            name: "NORMAL"
            when: (root.currentPlayMode == 'NORMAL')

            PropertyChanges {
                target: root
                normalAnimateStatus: 'IN'
                comfortAnimateStatus: 'OUT'
                sportAnimateStatus: 'OUT'
            }

            PropertyChanges {
                target: leftRegionBackground
                source: "qrc:/assets/speed_pattern_normal.png"
            }

            PropertyChanges {
                target: middleBG
                source: "qrc:/assets/pattern_a_normal.png"
            }

            PropertyChanges {
                target: root
                imgChargeBlurCenter: "qrc:/assets/power_pattern_charge_normal.png"
            }

            PropertyChanges {
                target: root
                imgEpowerBlurCenter: "qrc:/assets/power_pattern_normal.png"
            }

            PropertyChanges {
                target: root
                tripBackground: "qrc:/assets/did_functionbg_normal.png"
            }

            PropertyChanges {
                target: root
                light_1: "#58AFFF"
            }

            PropertyChanges {
                target: root
                progressBarBgColor: "#15284A"
            }

        },
        State {
            name: "COMFORT"
            when: (root.currentPlayMode == 'COMFORT')

            PropertyChanges {
                target: root
                normalAnimateStatus: 'OUT'
                comfortAnimateStatus: 'IN'
                sportAnimateStatus: 'OUT'
            }

            PropertyChanges {
                target: leftRegionBackground
                source: "qrc:/assets/speed_pattern_comfort.png"
            }

            PropertyChanges {
                target: middleBG
                source: "qrc:/assets/pattern_a_comfort.png"
            }

            PropertyChanges {
                target: root
                imgChargeBlurCenter: "qrc:/assets/power_pattern_charge_comfort.png"
            }

            PropertyChanges {
                target: root
                imgEpowerBlurCenter: "qrc:/assets/power_pattern_comfort.png"
            }

            PropertyChanges {
                target: root
                tripBackground: "qrc:/assets/did_functionbg_comfort.png"
            }

            PropertyChanges {
                target: root
                light_1: "#05C397"
            }

            PropertyChanges {
                target: root
                progressBarBgColor: "#0B302F"
            }

        },
        State {
            name: "SPORT"
            when: (root.currentPlayMode == 'SPORT')

            PropertyChanges {
                target: root
                normalAnimateStatus: 'OUT'
                comfortAnimateStatus: 'OUT'
                sportAnimateStatus: 'IN'
            }

            PropertyChanges {
                target: leftRegionBackground
                source: "qrc:/assets/speed_pattern_sport.png"
            }

            PropertyChanges {
                target: middleBG
                source: "qrc:/assets/pattern_a_sport.png"
            }

            PropertyChanges {
                target: root
                imgChargeBlurCenter: "qrc:/assets/power_pattern_charge_sport.png"
            }

            PropertyChanges {
                target: root
                imgEpowerBlurCenter: "qrc:/assets/power_pattern_sport.png"
            }

            PropertyChanges {
                target: root
                tripBackground: "qrc:/assets/did_functionbg_sport.png"
            }

            PropertyChanges {
                target: root
                light_1: "#89320D"
            }

            PropertyChanges {
                target: root
                progressBarBgColor: "#420100"
            }
        }
    ]

    property string imgEpowerBlurCenter: "qrc:/assets/power_pattern_normal.png"
    property string imgChargeBlurCenter: "qrc:/assets/power_pattern_charge_normal.png"
    property string tripBackground: "assets/did_functionbg_normal.png"
    property string light_1: "#58AFFF"
    property string imgCarTop: "qrc:/assets/img_tpms_car.png"
    property string progressBarBgColor: "#15284A"
    property string imgMapSource: "assets/img_comfort_map.png" // img_comfort_map, testmap

    onSwitchDoor_FLChanged: {
        if (carAnimation.targetStatus === "opendoor") {
            middleCar.switchDoor_FL = root.switchDoor_FL
        } else {
            carAnimation.targetStatus = "opendoor"
        }
    }

    onSwitchDoor_FRChanged: {
        if(carAnimation.targetStatus === "opendoor") {
            middleCar.switchDoor_FR = root.switchDoor_FR
        } else {
            carAnimation.targetStatus = "opendoor"
        }
    }

    onSwitchDoor_RLChanged: {
        if(carAnimation.targetStatus === "opendoor") {
            middleCar.switchDoor_RL = root.switchDoor_RL
        } else {
            carAnimation.targetStatus = "opendoor"
        }
    }

    onSwitchDoor_RRChanged: {
        if(carAnimation.targetStatus === "opendoor") {
            middleCar.switchDoor_RR = root.switchDoor_RR
        } else {
            carAnimation.targetStatus = "opendoor"
        }
    }

    onSwitchEngineChanged: {
        if(carAnimation.targetStatus === "opendoor") {
            middleCar.switchEngine = root.switchEngine
        } else {
            carAnimation.targetStatus = "opendoor"
        }
    }

    onSwitchTrunkChanged: {
        if(carAnimation.targetStatus === "opendoor") {
            middleCar.switchTrunk = root.switchTrunk
        } else {
            carAnimation.targetStatus = "opendoor"
        }
    }

    Image {
        id: leftRegionBackground
        width:660;height:600
        y: 90 //0
        source: "qrc:/assets/speed_pattern_normal.png"
        sourceSize.width: 660
        sourceSize.height: 600
    }

    /*時速表中間當前時速數字*/
    Text {
        x: 266 //mt_test: 210
        y: 312 //(222+90=312), 222
        width: 240 //mt_test: 360
        height: 156
        color: "#ffffff" // white
        text: mainscreenRoot.speedValue
        font.pixelSize: 130
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
    }

    /*時速表中間當前時速單位*/
    Text {
        id: kmh
        x: 266
        y: 468 //(378+90=468), 378
        width: 240
        height: 46
        color: "#FFFFFF"
        opacity: 0.5
        text: "km / h"
        font.pixelSize: 38
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
    }

    /*左側時速表區域*/
    Item {
        width: 660;height: 600
        y: 90 //0
        Loader {
            id:normalSpeedLoader
            sourceComponent: leftRegionItemNormal
            asynchronous: true
            active: true
            opacity: 0.0
            states: [
                State {
                    name: "IN"
                    when: (root.normalAnimateStatus == 'IN')
                    PropertyChanges {
                        target: normalSpeedLoader
                        opacity: 1.0
                        scale:1
                        z:1
                    }
                },
                State {
                    name: "OUT"
                    when: (root.normalAnimateStatus == 'OUT')
                    PropertyChanges {
                        target: normalSpeedLoader
                        opacity: 0.0
                        scale:0.6
                        z:0
                    }
                }
            ]

            transitions: [
                Transition {
                    NumberAnimation {
                        properties: "x,scale"
                        duration: root.animateTime
                        easing {type:Easing.OutQuad}
                    }

                    NumberAnimation {
                        properties: "opacity"
                        duration: root.animateTime/2
                    }
                }
            ]
        }
        Loader {
            id:comfortSpeedLoader
            sourceComponent: leftRegionItemComfort
            asynchronous: true
            active: true
            opacity: 0.0
            states: [
                State {
                    name: "IN"
                    when: (root.comfortAnimateStatus == 'IN')
                    PropertyChanges {
                        target: comfortSpeedLoader
                        opacity: 1.0
                        scale:1
                        z:1
                    }
                },
                State {
                    name: "OUT"
                    when: (root.comfortAnimateStatus == 'OUT')
                    PropertyChanges {
                        target: comfortSpeedLoader
                        opacity: 0.0
                        scale:2.5
                        z:0
                    }
                }
            ]

            transitions: [
                Transition {
                    NumberAnimation {
                        properties: "x,scale"
                        duration: root.animateTime
                        easing {type:Easing.OutQuad}
                    }

                    NumberAnimation {
                        properties: "opacity"
                        duration: root.animateTime/2
                    }
                }
            ]
        }
        Loader {
            id:sportSpeedLoader
            sourceComponent: leftRegionItemSport
            asynchronous: true
            active: true
            opacity: 0.0
            states: [
                State {
                    name: "IN"
                    when: (root.sportAnimateStatus == 'IN')
                    PropertyChanges {
                        target: sportSpeedLoader
                        opacity: 1.0
                        x:0
                        z:1
                    }
                },
                State {
                    name: "OUT"
                    when: (root.sportAnimateStatus == 'OUT')
                    PropertyChanges {
                        target: sportSpeedLoader
                        opacity: 0.0
                        x:-330
                        z:0
                    }
                }
            ]

            transitions: [
                Transition {
                    NumberAnimation {
                        properties: "x,scale"
                        duration: root.animateTime
                        easing {type:Easing.OutQuad}
                    }

                    NumberAnimation {
                        properties: "opacity"
                        duration: root.animateTime/2
                    }
                }
            ]
        }

        Component {
            id:leftRegionItemNormal
            NewSpeedMeter {
                id:normalSpeed
//                nowSpeedValue: root.speedValue
                currentPlayMode:"NORMAL"
                animateStatus: root.normalAnimateStatus
            }
        }

        Component {
            id:leftRegionItemComfort
            NewSpeedMeter {
                id:comfortSpeed
//                nowSpeedValue: root.speedValue
                currentPlayMode:"COMFORT"
                animateStatus: root.comfortAnimateStatus
            }
        }

        Component {
            id:leftRegionItemSport
            NewSpeedMeter {
                id:sportSpeed
//                nowSpeedValue: root.speedValue
                currentPlayMode:"SPORT"
                animateStatus: root.sportAnimateStatus
            }
        }
    }

    /*右側區域*/
    Item {
        width: 660;height: 600
        x:1140;y:90 //0
        SwipeView {
            id:swipeview
            currentIndex: root.defaultIndex
            onCurrentIndexChanged: {
                if(currentIndex == 0){
                    rightPowerRegion.visible = true
                    rightStatusItem.visible = false
                    rightMusicItem.visible = false
                    rightMapItem.visible = false
                    rightTripItem.visible = false
                } else if (currentIndex == 1) {
                    rightPowerRegion.visible = false
                    rightStatusItem.visible = true
                    rightMusicItem.visible = false
                    rightMapItem.visible = false
                    rightTripItem.visible = false
                } else if (currentIndex == 2) {
                    rightPowerRegion.visible = false
                    rightStatusItem.visible = false
                    rightMusicItem.visible = true
                    rightMapItem.visible = false
                    rightTripItem.visible = false
                } else if (currentIndex == 3) {
                    rightPowerRegion.visible = false
                    rightStatusItem.visible = false
                    rightMusicItem.visible = false
                    rightMapItem.visible = true
                    rightTripItem.visible = false
                } else if (currentIndex == 4) {
                    rightPowerRegion.visible = false
                    rightStatusItem.visible = false
                    rightMusicItem.visible = false
                    rightMapItem.visible = false
                    rightTripItem.visible = true
                }
            }

            anchors.fill: parent
            orientation: Qt.Vertical

            clip: false

            Item {
                id:rightPowerRegion
                visible: true
                property int nowChargeValue: mainscreenRoot.chargeValue
                property int nowLostKwhValue: mainscreenRoot.lostKwh

                Image {
                    id: rightRegionBackground
                    width: 660;height: 600
                    source:root.imgEpowerBlurCenter
                    sourceSize.width: 660
                    sourceSize.height: 600
                }

                /*中間當前大字*/
                Text {
                    id:textItem
                    x: 154
                    y: 222
                    width: 240
                    height: 156
                    color: "#ffffff"
                    text: rightPowerRegion.nowLostKwhValue
                    font.pixelSize: 130
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }

                /*中間當前單位*/
                Text {
                    id: percentText
                    x: 154
                    y: 378
                    width: 240
                    height: 46
                    color: "#FFFFFF"
                    opacity: 0.5
                    text: "%"
                    font.pixelSize: 38
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }

                /*右側電量表*/
                Item {
                    width:660;height:600

                    Loader {
                        id:normalPowerLoader
                        sourceComponent: rightRegionItemNormal
                        asynchronous: true
                        active: true
                        opacity: 0.0
                        states: [
                            State {
                                name: "IN"
                                when: (root.normalAnimateStatus == 'IN')
                                PropertyChanges {
                                    target: normalPowerLoader
                                    opacity: 1.0
                                    scale:1.0
                                    z:1
                                }
                            },
                            State {
                                name: "OUT"
                                when: (root.normalAnimateStatus == 'OUT')
                                PropertyChanges {
                                    target: normalPowerLoader
                                    opacity: 0.0
                                    scale:0.6
                                    z:0
                                }
                            }
                        ]

                        transitions: [
                            Transition {
                                NumberAnimation {
                                    properties: "x,scale"
                                    duration: root.animateTime
                                    easing {type:Easing.OutQuad}
                                }
                                NumberAnimation {
                                    properties: "opacity"
                                    duration: root.animateTime/2
                                }
                            }
                        ]
                    }

                    Loader {
                        id:comfortPowerLoader
                        sourceComponent: rightRegionItemComfort
                        asynchronous: true
                        active: true
                        opacity: 0.0
                        states: [
                            State {
                                name: "IN"
                                when: (root.comfortAnimateStatus == 'IN')
                                PropertyChanges {
                                    target: comfortPowerLoader
                                    opacity: 1.0
                                    scale:1
                                    z:1
                                }
                            },
                            State {
                                name: "OUT"
                                when: (root.comfortAnimateStatus == 'OUT')
                                PropertyChanges {
                                    target: comfortPowerLoader
                                    opacity: 0.0
                                    scale:2.5
                                    z:0
                                }
                            }
                        ]

                        transitions: [
                            Transition {
                                NumberAnimation {
                                    properties: "x,scale"
                                    duration: root.animateTime
                                    easing {type:Easing.OutQuad}
                                }

                                NumberAnimation {
                                    properties: "opacity"
                                    duration: root.animateTime/2
                                }
                            }
                        ]
                    }

                    Loader {
                        id:sportPowerLoader
                        sourceComponent: rightRegionItemSport
                        asynchronous: true
                        active: true
                        opacity: 0.0
                        states: [
                            State {
                                name: "IN"
                                when: (root.sportAnimateStatus == 'IN')
                                PropertyChanges {
                                    target: sportPowerLoader
                                    opacity: 1.0
                                    x:0
                                    z:1
                                }
                            },
                            State {
                                name: "OUT"
                                when: (root.sportAnimateStatus == 'OUT')
                                PropertyChanges {
                                    target: sportPowerLoader
                                    opacity: 0.0
                                    x:330
                                    z:0
                                }
                            }
                        ]

                        transitions: [
                            Transition {
                                NumberAnimation {
                                    properties: "x,scale"
                                    duration: root.animateTime
                                    easing {type:Easing.OutQuad}
                                }

                                NumberAnimation {
                                    properties: "opacity"
                                    duration: root.animateTime/2
                                }
                            }
                        ]
                    }

                    Component {
                        id:rightRegionItemNormal
                        NewEpower {
                            currentPlayMode: "NORMAL"
                            animateStatus: root.normalAnimateStatus
                        }
                    }

                    Component {
                        id:rightRegionItemComfort
                        NewEpower {
                            currentPlayMode: "COMFORT"
                            animateStatus: root.comfortAnimateStatus
                        }
                    }

                    Component {
                        id:rightRegionItemSport
                        NewEpower {
                            currentPlayMode: "SPORT"
                            animateStatus: root.sportAnimateStatus
                        }
                    }
                }

                onNowChargeValueChanged: {
                    changeImgAndNumber();
                }

                onNowLostKwhValueChanged: {
                    changeImgAndNumber();
                }

                function changeImgAndNumber() {
                    if (nowChargeValue > 0) {
                        rightRegionBackground.source = root.imgChargeBlurCenter
                        textItem.text = rightPowerRegion.nowChargeValue;
                    } else if (nowLostKwhValue >= 0) {
                        rightRegionBackground.source = root.imgEpowerBlurCenter
                        textItem.text = rightPowerRegion.nowLostKwhValue;
                    }

                }
            }

            Item {
                id:rightStatusItem
                visible: false
                RightStatus {
                    width: 660;height: 600
                    imgCarTop:root.imgCarTop
                }
            }

            Item {
                id:rightMusicItem
                visible: false
                RightMusic {
                    id:rightMusic
                    width: 660;height: 600
//                    imgMusicAlbum: "qrc:/assets/ablum.png"
                    progressBarBgColor:root.progressBarBgColor
                    backgroundImage:root.tripBackground
                    progressbarmaximumValue:120
                    text_artistText:root.musicArtistName
                    text_musicText:root.musicTrackName
                    displayMusicInfo:root.displayMusicInfo
                    radioListIndex:root.radioIdx
                }
            }

            Item {
                id:rightMapItem
                visible: false
                RightMap {
                    width: 660;height: 600
                    imgMapSource:root.imgMapSource
                }
            }

            Item {
                id:rightTripItem
                visible: false
                RightTripinfo {
                    width: 660;height: 600
                    backgroundImage:root.tripBackground
                }
            }
        }
    }



    PageIndicator {
        id:indicator
        count:swipeview.count;currentIndex: swipeview.currentIndex
        x:1780
        anchors.verticalCenter: root.verticalCenter
        rotation: 90
        spacing: 18
        delegate: Rectangle {
            implicitWidth: 9
            implicitHeight: 9

            radius: width / 2
            color: root.light_1

            opacity: index  === indicator.currentIndex ? 0.95 : pressed ? 0.75 : 0.45

            Behavior on opacity { OpacityAnimator { duration: 100 } }
        }
    }

    MiddleCar {
        id:middleCar
        visible: false
        anchors.centerIn: parent

        onBackInitCarTypeChanged: {
            if (backInitCarType) {
                carAnimation.targetStatus = ""
                backInitCarType = false;
                middleCar.visible = false;
            }
        }
    }

    CarAnimation {
        id:carAnimation
        x:-60;y:-60
        width: 1200;height:1080 //720
        onFinishedChanged: {
            if (finished) {
                if(targetStatus === "charge") {
                    console.log("targetStatus === charge")
                } else if (targetStatus === "opendoor") {
                    console.log("targetStatus === opendoor")
                    middleCar.visible = true
                    carAnimation.visible = false
                    middleCar.switchDoor_FL = root.switchDoor_FL
                    middleCar.switchDoor_FR = root.switchDoor_FR;
                    middleCar.switchDoor_RL = root.switchDoor_RL;
                    middleCar.switchDoor_RR = root.switchDoor_RR;
                    middleCar.switchEngine = root.switchEngine;
                    middleCar.switchTrunk = root.switchTrunk;
                } else if (targetStatus === "changegear") {
                    console.log("targetStatus === changegear")
                    if (root.currentGear == "gear_stop" || root.currentGear == "gear_p") {
                        middle_adasRegion.visible = false
                        middle_bg.visible = false
                        middleCar.visible = true
                    } else {
                        middle_adasRegion.visible = true
                        middle_bg.visible = true
                        middleCar.visible = false
                    }
                }
                finished = false;
            }

        }
    }

    Image {
        id: middleBG
        x:0;y:0;z:-1
        width: 1800;height: 600
        source: "qrc:/assets/pattern_a_normal_bg_ADAS_1800x780.png" //pattern_a_normal.png
        sourceSize.width: 1800
        sourceSize.height: 600
    }

    MiddleADAS {
        id:middleADAS
        anchors.horizontalCenter: parent.horizontalCenter
        y:258
        z:-1
        visible: true
        currentGear : root.currentGear
        currentPlayMode:root.currentPlayMode
//        speedValue:root.speedValue
    }

    MiddleNavigation {
        id:middleNav
        x:660;y:30 //(180-150=30),42
        visible: root.switchNaviNext
        nextRoadDistance : root.nextRoadDistance
        nextRoadName: root.nextRoadName
    }

//    onCurrentGearChanged: {
//        if (carAnimation.targetStatus == 'opendoor') {
//            carAnimation.targetStatus = "changegear"
//            middleCar.visible = false;
//        } else if (carAnimation.targetStatus == 'changegear') {
//            if (currentGear == 'gear_stop' || currentGear == 'gear_p') {
//                middle_adasRegion.visible = false
//                middle_bg.visible = false
//            } else {
//                middle_adasRegion.visible = true
//                middle_bg.visible = true
//            }
//        } else {
//            carAnimation.targetStatus = "changegear"
//        }
//    }

//    Component.onCompleted:{
//        /*車輛進場動畫*/
//        if(currentGear == 'gear_stop'){
//            carAnimation.animateType = "carin"
//            carAnimation.startAnimation = true;
//        }
//    }

    function pressKey(key) {
        if (key === Qt.Key_Up) {
            if (root.defaultIndex > 0) {
                root.defaultIndex--;
            } else {
                root.defaultIndex = swipeview.count -1;
            }
        } else if (key === Qt.Key_Down) {
            if (root.defaultIndex === swipeview.count -1) {
                root.defaultIndex = 0;
            } else {
                root.defaultIndex++;
            }
        }
    }
}
