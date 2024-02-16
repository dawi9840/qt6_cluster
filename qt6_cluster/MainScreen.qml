import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Timeline 1.0
import Qt5Compat.GraphicalEffects
//import QtGraphicalEffects 1.15 // for Qt5

Item {
    id:mainscreenRoot
    width: 1920
    height: 1080 //720
    visible: true
    focus:true
    property bool autoRun: true
    property int speedValue: 0
    property int chargeValue:0
    property int lostKwh:0

    property bool signTURN_L: false
    property bool signTURN_R: false
    property bool signSeatBelt: false
    property bool signBrakes: false

    property bool switchDoorOpen:false
    property bool switchDoor_FL: false
    property bool switchDoor_FR: false
    property bool switchDoor_RL: false
    property bool switchDoor_RR: false
    property bool switchEngine: false
    property bool switchTrunk: false

    //ADAS status
    property bool switchACC: false
    property bool signACC: false
    property bool switchLDW: true
    property bool signLDWOccur:false
    property bool signLDW_L: false
    property bool signLDW_R: false
    property bool switchBSD: true
    property bool signBSD_L: false
    property bool signBSD_R: false
    property bool switchRCTA: true
    property bool signRCTA_L: false
    property bool signRCTA_C: false
    property bool signRCTA_R: false
    property bool signFCW: false
    property bool signDAM: false
    property bool signAEB: false
    property bool signAEBP: false
    property bool signAirBagOff:false

    property bool signSpeedLimit: false
    property int limitSpeedValue:0

    // DMS info
    property bool signDMS_Yaw: fales
    property bool signDMS_PhoneCall: fales

    //Navi info
    property bool switchNaviRemain: false
    property string costTime: "40 min" //抵達目的地所需分鐘數
    property int totalKm: 180 //抵達目的地所需公里數
    property string arrivalTime: "12:50 AM"//抵達目的地的時間

    property bool switchNaviNext: false
    property real nextRoadDistance: 60 //下一個路口距離
    property string nextRoadName: "Zhongxiao E Rd"//下一個路口名字

    property double oldTimeStemp:0
    property int oldSpeed: 0
    property int defaultIndex: 0 //預設Type頁面 index 0

    property color switch_offColor : "gray"
    property color switch_OnColor : "white"

    property int currentSec: 0

    property string currentPlayMode: 'NORMAL' // COMFORT, NORMAL, SPORT

    property string currentGear: "gear_d"/*當前檔位*/
    property bool showCtrlPanel: false   //true: for debug.;false: default.
    property bool showCtrlAdv: true
    property bool startTimeline:true
    property bool signBrakeLamp:false

    property int tempSpeed:100
    property int tempPWR:0
    property int tempCHG:0

    onSignBrakeLampChanged: {
        if(mainscreenRoot.signBrakeLamp == true){
            if (timelineAnimation.paused !== true) {
                timelineAnimation.pause();
                mainscreenRoot.tempSpeed = mainscreenRoot.speedValue;
                mainscreenRoot.tempPWR = mainscreenRoot.lostKwh;
                mainscreenRoot.tempCHG = mainscreenRoot.chargeValue;
                console.log("tempSpeed = " + mainscreenRoot.tempSpeed);
            }

            if (speedUpAnimation.running) {
                speedUpAnimation.stop();
            }
            speedDownAnimation.startValue = mainscreenRoot.speedValue;
            speedDownAnimation.start();
        } else {
            if (speedDownAnimation.running) {
                speedDownAnimation.stop();
            }

            speedUpAnimation.startValue = mainscreenRoot.speedValue;
            speedUpAnimation.start();
        }
    }

    property var modeContentList: {
        'COMFORT':{
            'toast_takebreak':"qrc:/assets/toast_tired_comfort.png",
            'toast_emptyDlg':"qrc:/assets/toast_empty_comfort.png",
            // dms
            'toast_time_for_a_break':"qrc:/assets/toast_time_for_a_break_comfort.png",
            'toast_focus_on_driving':"qrc:/assets/toast_focus_on_driving_comfort.png",
        },
        'NORMAL':{
            'toast_takebreak':"qrc:/assets/toast_tired_normal.png",
            'toast_emptyDlg':"qrc:/assets/toast_empty_normal.png",
            // dms
            'toast_time_for_a_break':"qrc:/assets/toast_time_for_a_break_normal.png",
            'toast_focus_on_driving':"qrc:/assets/toast_focus_on_driving_normal.png",
        },
        'SPORT':{
            'toast_takebreak':"qrc:/assets/toast_tired_sport.png",
            'toast_emptyDlg':"qrc:/assets/toast_empty_sport.png",
            // dms
            'toast_time_for_a_break':"qrc:/assets/toast_time_for_a_break_sport.png",
            'toast_focus_on_driving':"qrc:/assets/toast_focus_on_driving_sport.png",
        }
    }

    property var currentModeContent: modeContentList[currentPlayMode]/*當前Mode: normal/comfort/sport */

    property int radioIdx:0/*電台列表 當前播放Index*/

    property string chargeStatus:"Regular" /* Regular:未充電;Charge:充電中;Unstable:充電不穩定;Error:充電異常;Completed:充電完成;Scheduled:排程中*/

    property string currCarAnimateStatus: "" /*in,out,top,charge,dooropen*/

    states: [
        State {
            name: "NORMAL"
            when: (mainscreenRoot.currentPlayMode == 'NORMAL')
            PropertyChanges {
                target: backgroundColor
                color: "#0A1427"
            }

            PropertyChanges {
                target: backgroundImg
                source: "qrc:/assets/bg_normal_1920x1080.png" //720: background_normal.png
            }

            PropertyChanges {
                target: volumepProgressBar
                volumeBgColor:'#14336B'
            }
        },
        State {
            name: "COMFORT"
            when: (mainscreenRoot.currentPlayMode == 'COMFORT')
            PropertyChanges {
                target: backgroundColor
                color: "#071A1E"
            }

            PropertyChanges {
                target: backgroundImg
                source: "qrc:/assets/background_comfort.png" // .png, bg_comfort_1920x1080
            }

            PropertyChanges {
                target: volumepProgressBar
                volumeBgColor:'#0A403A'
            }
        },
        State {
            name: "SPORT"
            when: (mainscreenRoot.currentPlayMode == 'SPORT')
            PropertyChanges {
                target: backgroundColor
                color: "#000000"
            }

            PropertyChanges {
                target: backgroundImg
                source: "qrc:/assets/background_sport.png" // background_sport.png, bg_sport_1920x1080
            }

            PropertyChanges {
                target: volumepProgressBar
                volumeBgColor:'#2D2D2D'

            }
        }
    ]

    Rectangle {
        id:backgroundColor
        width: parent.width
        height: parent.height
        color: "#0A1427"
    }

    Image {
        id:backgroundImg
        width: 1920;height: 1080 //720
        source: "qrc:/assets/bg_normal_1920x1080.png" // background_normal.png
        sourceSize.height: 1080 //720
        sourceSize.width: 1920
    }

    Item {
        id:swipeview
        property int currentIndex: mainscreenRoot.defaultIndex
        property int count: 4
        width: 1920;height: 1080 //720

        Loader {
            id:typeALoader
            sourceComponent: typeAComponent
            asynchronous: true
            active: false
            Component {
                id:typeAComponent
                TypeALayout {
                    id:typeApage
                    width: 1800;height: 780 //600
                    x:60;y:150 //60
//                    speedValue: mainscreenRoot.speedValue
//                    lostKwh: mainscreenRoot.lostKwh
//                    chargeValue: mainscreenRoot.chargeValue
                    currentGear : mainscreenRoot.currentGear
                    currentPlayMode :mainscreenRoot.currentPlayMode
                    switchDoor_FL: mainscreenRoot.switchDoor_FL
                    switchDoor_FR: mainscreenRoot.switchDoor_FR
                    switchDoor_RL: mainscreenRoot.switchDoor_RL
                    switchDoor_RR: mainscreenRoot.switchDoor_RR
                    switchNaviNext : mainscreenRoot.switchNaviNext
                    nextRoadDistance : mainscreenRoot.nextRoadDistance
                    nextRoadName : mainscreenRoot.nextRoadName
                    radioIdx:mainscreenRoot.radioIdx

                    Connections {
                        target:mainscreenRoot
                        function onKeyPressed(key) {
                            typeApage.pressKey(key);
                        }
                    }

                }
            }

            onStatusChanged: {
                if (status == Component.Null) {
                    console.log("typeALoader Component.Null");
                } else if (status == Component.Ready) {
                    console.log("typeALoader Component.Ready");
                } else if (status == Component.Loading) {
                    console.log("typeALoader Component.Loading");
                }
            }

            states: [
                State {
                    name: "IN"
                    when: (mainscreenRoot.defaultIndex == 0)
                    PropertyChanges {
                        target: typeALoader
                        opacity: 1.0
                    }
                },
                State {
                    name: "OUT"
                    when: (mainscreenRoot.defaultIndex != 0)
                    PropertyChanges {
                        target: typeALoader
                        opacity: 0.0
                    }
                }
            ]

            transitions: [
                Transition {
                    NumberAnimation {
                        properties: "opacity"
                        duration: 500
                    }
                }
            ]
        }

        Loader {
            id:typeBLoader
            sourceComponent: typeBComponent
            asynchronous: true
            active: false
            Component {
                id:typeBComponent
                TypeBLayout {
                    width: 1800;height: 600
                    x:60;y:240 //60
                    speedValue: mainscreenRoot.speedValue
                    lostKwh: mainscreenRoot.lostKwh
                    chargeValue: mainscreenRoot.chargeValue
                    displayModeList : mainscreenRoot.typeBdisplayModeList
                    currentPlayMode :mainscreenRoot.currentPlayMode
                    switchNaviNext : mainscreenRoot.switchNaviNext
                    nextRoadDistance : mainscreenRoot.nextRoadDistance
                    nextRoadName : mainscreenRoot.nextRoadName

                }
            }

            onStatusChanged: {
                if (status == Component.Null) {
                    console.log("typeBLoader Component.Null");
                } else if (status == Component.Ready) {
                    console.log("typeBLoader Component.Ready");
                } else if (status == Component.Loading) {
                    console.log("typeBLoader Component.Loading");
                }
            }

            states: [
                State {
                    name: "IN"
                    when: (mainscreenRoot.defaultIndex == 1)
                    PropertyChanges {
                        target: typeBLoader
                        opacity: 1.0
                    }
                },
                State {
                    name: "OUT"
                    when: (mainscreenRoot.defaultIndex != 1)
                    PropertyChanges {
                        target: typeBLoader
                        opacity: 0.0
                    }
                }
            ]

            transitions: [
                Transition {
                    NumberAnimation {
                        properties: "opacity"
                        duration: 500
                    }
                }
            ]
        }

        Loader {
            id:typeDLoader
            sourceComponent: typeDComponent
            asynchronous: true
            active: false
            Component {
                id:typeDComponent
                TypeDLayout {
                    width: 1800;height:960 //600
                    x:60;y:60 //90
                    speedValue: mainscreenRoot.speedValue
                    displayModeList : mainscreenRoot.typeDdisplayModeList
                    currentPlayMode :mainscreenRoot.currentPlayMode
                    switchNaviNext : mainscreenRoot.switchNaviNext
                    nextRoadDistance : mainscreenRoot.nextRoadDistance
                    switchNaviRemain : mainscreenRoot.switchNaviRemain
                    costTime : mainscreenRoot.costTime
                    totalKm : mainscreenRoot.totalKm
                    arrivalTime : mainscreenRoot.arrivalTime
                }
            }

            onStatusChanged: {
                if (status == Component.Null) {
                    console.log("typeDLoader Component.Null");
                } else if (status == Component.Ready) {
                    console.log("typeDLoader Component.Ready");
                } else if (status == Component.Loading) {
                    console.log("typeDLoader Component.Loading");
                }
            }

            states: [
                State {
                    name: "IN"
                    when: (mainscreenRoot.defaultIndex == 2)
                    PropertyChanges {
                        target: typeDLoader
                        opacity: 1.0
                    }
                },
                State {
                    name: "OUT"
                    when: (mainscreenRoot.defaultIndex != 2)
                    PropertyChanges {
                        target: typeDLoader
                        opacity: 0.0
                    }
                }
            ]

            transitions: [
                Transition {
                    NumberAnimation {
                        properties: "opacity"
                        duration: 500
                    }
                }
            ]
        }

        Loader {
            id:typeCLoader
            sourceComponent: typeCComponent
            asynchronous: true
            active: false
            Component {
                id:typeCComponent
                TypeCLayout {
                    id:typeCpage
                    width: 1800;height:960 //540
                    x:60;y:60 //90
                    speedValue: mainscreenRoot.speedValue
                    displayModeList : mainscreenRoot.typeCdisplayModeList
                    currentPlayMode :mainscreenRoot.currentPlayMode
                    switchNaviNext : mainscreenRoot.switchNaviNext
                    nextRoadDistance : mainscreenRoot.nextRoadDistance
                    switchNaviRemain : mainscreenRoot.switchNaviRemain
                    costTime : mainscreenRoot.costTime
                    totalKm : mainscreenRoot.totalKm
                    arrivalTime : mainscreenRoot.arrivalTime

                    Connections {
                        target:mainscreenRoot
                        function onKeyPressed(key) {
                            typeCpage.pressKey(key);
                        }
                    }
                }
            }

            onStatusChanged: {
                if (status == Component.Null) {
                    console.log("typeCLoader Component.Null");
                } else if (status == Component.Ready) {
                    console.log("typeCLoader Component.Ready");
                } else if (status == Component.Loading) {
                    console.log("typeCLoader Component.Loading");
                }
            }

            states: [
                State {
                    name: "IN"
                    when: (mainscreenRoot.defaultIndex == 3)
                    PropertyChanges {
                        target: typeCLoader
                        opacity: 1.0
                    }
                },
                State {
                    name: "OUT"
                    when: (mainscreenRoot.defaultIndex != 3)
                    PropertyChanges {
                        target: typeCLoader
                        opacity: 0.0
                    }
                }
            ]

            transitions: [
                Transition {
                    NumberAnimation {
                        properties: "opacity"
                        duration: 500
                    }
                }
            ]
        }

        Loader {
            id: signalPageLoader
            source: "SignalPage.qml"
        }

        onCurrentIndexChanged: {
            currentPlayMode = 'NORMAL'
            mainscreenRoot.defaultIndex = currentIndex
            console.log("onCurrentIndexChanged:" + currentIndex);
            if (currentIndex == 0) {
                typeALoader.active = true;
                typeBLoader.active = false;
                typeDLoader.active = false;
                typeCLoader.active = false;
            } else if (currentIndex == 1) {
                typeALoader.active = false;
                typeBLoader.active = true;
                typeDLoader.active = false;
                typeCLoader.active = false;
            } else if (currentIndex == 2) {
                typeALoader.active = false;
                typeBLoader.active = false;
                typeDLoader.active = true;
                typeCLoader.active = false;
            } else if (currentIndex == 3) {
                typeALoader.active = false;
                typeBLoader.active = false;
                typeDLoader.active = false;
                typeCLoader.active = true;
            }
        }

        Component.onCompleted: {
            typeALoader.active = true;
            typeBLoader.active = false;
            typeDLoader.active = false;
            typeCLoader.active = false;
        }
    }

    Image {/*中間上方 檔位*/
        id:gearImage
        width: 120;height: 58
        x:900;y:18
        sourceSize.width: 120
        sourceSize.height: 58
        source: "signalimg/gear_park.png"
        property string gear: mainscreenRoot.currentGear
        onGearChanged: {
            if(gear == 'gear_stop') {
                source = "signalimg/gear_park.png"
            } else if (gear == 'gear_p') {
                source = "signalimg/gear_p.png"
            } else if (gear == 'gear_d') {
                source = "signalimg/gear_d.png"
            } else if (gear == 'gear_n') {
                source = "signalimg/gear_n.png"
            } else if (gear == 'gear_r') {
                source = "signalimg/gear_r.png"
            }
        }
    }

    TextTime {/*右上角 時間 溫度資訊*/
        id: text_Time
        x: 1662
        y: 18
        width: 240
        height: 42
    }

    TextBattery {/*右下角剩餘電量及可行駛公里數資訊*/
        id: text_Battery
        x: 1488
        y: 1020 //660 ------------------------
        width: 414
        height: 42
        batteryStatus:mainscreenRoot.chargeStatus
    }

    onSignFCWChanged: {
        updateSmallADAS()
    }

    onSignDAMChanged: {
        updateToastInfo()
    }

    onSignAEBChanged: {
        updateToastInfo()
        updateSmallADAS()
    }

    onSignSpeedLimitChanged: {
        if(mainscreenRoot.signSpeedLimit === false && main_toast.visible) {
            main_toast.visible = false
        }
    }

    function updateToastInfo(){
        if (signAEB) {
            main_toast.source = "qrc:/assets/toast_aeb.png"
            main_toast.toastTitle = ""
            main_toast.toastContent = ""
            main_toast.visible = true
        } else if (signDAM){
            main_toast.source = currentModeContent['toast_takebreak']
            main_toast.toastTitle = ""
            main_toast.toastContent = ""
            main_toast.visible = true
        } else if (signSpeedLimit && speedValue > limitSpeedValue) {
            main_toast.source = currentModeContent['toast_emptyDlg']
            main_toast.toastTitle = limitSpeedValue
            main_toast.toastContent = "SPEED LIMIT"
            main_toast.visible = true
        } else if (signDMS_Yaw){//dawi add
            main_toast.source = currentModeContent['toast_takebreak']
            main_toast.toastTitle = ""
            main_toast.toastContent = ""
            main_toast.visible = true
        }else if (signDMS_PhoneCall){//dawi add
            main_toast.source = currentModeContent['toast_focus_on_driving']
            main_toast.toastTitle = ""
            main_toast.toastContent = ""
            main_toast.visible = true
        }else {
            main_toast.visible = false
        }
    }

    Image {/*彈窗Toast*/
        id: main_toast
        width: 1800;height: 600
        x:60;y:180 //60
        visible: false
        source: ""
        sourceSize.width: 1800
        sourceSize.height: 600
        property alias toastTitle:titleText.text;
        property alias toastContent:contentText.text;

        Label {
            id:titleText
            height: 72
            text: "Value"
            font.pixelSize: 60
            color: "#FFFFFF"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 81
        }

        Label {
            id:contentText
            height: 36
            text: "SPEED LIMIT"
            font.pixelSize: 30
            color: "#FFFFFF"
            opacity: 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: titleText.bottom
        }

    }

    /*將key透過signal傳送給其他需要的qml接收*/
    signal keyPressed(int key)

    onKeyPressed: {
        if(key === Qt.Key_Left){
            console.log("key = Key_Left");
            if(defaultIndex > 0){
                defaultIndex--
            } else {
                defaultIndex = swipeview.count-1
            }
            console.log("defaultIndex = " + defaultIndex);
        } else if (key === Qt.Key_Right) {
            console.log("key = Key_Right");
            if (defaultIndex < swipeview.count-1) {
                defaultIndex++
            } else {
                defaultIndex = 0
            }
            console.log("defaultIndex = " + defaultIndex);
        } else if (key === Qt.Key_S) {
            mainscreenRoot.currentGear = "gear_stop"
        } else if (key === Qt.Key_P) {
            mainscreenRoot.currentGear = "gear_p"
        } else if (key === Qt.Key_R) {
            mainscreenRoot.currentGear = "gear_r"
        } else if (key === Qt.Key_D) {
            mainscreenRoot.currentGear = "gear_d"
        } else if (key === Qt.Key_VolumeUp) {
            console.log("key = Qt.Key_VolumeUp");
        } else if (key === Qt.Key_VolumeDown) {
            console.log("key = Qt.Key_VolumeDown");
        } else if (key === Qt.Key_VolumeMute) {
            console.log("key = Qt.Key_VolumeMute");
        } else if (key === Qt.Key_MediaNext) {
            mainscreenRoot.radioIdx = mainscreenRoot.radioIdx + 1;
            console.log("key = Qt.Key_MediaNext");
        } else if (key === Qt.Key_MediaPrevious) {
            mainscreenRoot.radioIdx = mainscreenRoot.radioIdx - 1;
            console.log("key = Qt.Key_MediaPrevious");
        } else if (key === Qt.Key_L) {
            mainscreenRoot.signSpeedLimit = !mainscreenRoot.signSpeedLimit
        } else if (key === Qt.Key_A) {
            mainscreenRoot.signAirBagOff = !mainscreenRoot.signAirBagOff
        } else if (key === Qt.Key_1) {
            mainscreenRoot.currentPlayMode = 'NORMAL';
        } else if (key === Qt.Key_2) {
            mainscreenRoot.currentPlayMode = 'COMFORT';
        } else if (key === Qt.Key_3) {
            mainscreenRoot.currentPlayMode = 'SPORT';
        } else if (key === Qt.Key_C) {
            /*stop the car*/
            mainscreenRoot.signBrakeLamp = true;
        } else if (key === Qt.Key_V) {
            /*start animation*/
            mainscreenRoot.signBrakeLamp = false;
        } else if (key === Qt.Key_N) {
            console.log("press Key_N,open second App Screen");
            navidata.callSecondApp();
        }else if (key === Qt.Key_Q){
            Qt.quit();
        }else if (key === Qt.Key_Z){
            mainscreenRoot.showCtrlPanel = true;
        }else if (key === Qt.Key_X){
            mainscreenRoot.showCtrlPanel = false;
        }else if (key === Qt.Key_M){
            if (signalPageLoader.item) {
                signalPageLoader.item.showAllSignal = true;
            }
        }else if (key === Qt.Key_B){
            if (signalPageLoader.item) {
                signalPageLoader.item.showAllSignal = false;
            }
        }
    }

    Keys.onPressed: (event)=> {
        if (!chargePage.show) {/*非充電頁面*/
            mainscreenRoot.keyPressed(event.key);
        }
    }

    function updateSmallADAS(){
        //only TypeB/C show small ADAS
        if (defaultIndex == 1 || defaultIndex == 3) {
            if (signAEB) {
                small_toast.source = "qrc:/assets/adas_aeb.png"
                small_toast.visible = true
            } else if (signFCW){
                small_toast.source = "qrc:/assets/adas_fcw.png"
                small_toast.visible = true
            } else {
                small_toast.visible = false
            }
        } else {
            small_toast.visible = false
        }
    }

    Image {/*左上角 ADAS警示Icon*/
        id: small_toast
        width: 180;height: 180
        sourceSize.width: 180
        sourceSize.height: 180
        x:72;y:72
        visible: false
    }

    ChargePage {/*充電模式*/
        id:chargePage
        width: backgroundImg.width ; height: backgroundImg.height
        property bool show : false
        opacity : 0
        batteryStatus:mainscreenRoot.chargeStatus
        onShowChanged: {
            chargefadeIn.stop()
            if (chargePage.show) {
                chargefadeIn.to = 1
                swipeview.visible = false;
            } else {
                chargefadeIn.to = 0
                swipeview.visible = true;
            }
            chargefadeIn.start()
        }
    }

    NumberAnimation {
        id: chargefadeIn
        target: chargePage
        property: "opacity"
        to:1
        duration: 400
        easing.type: Easing.OutCubic
        running: false
    }

    SignalPage {
        id:signelPage
        width: 1920;height: 1080 //720
        signTURN_L:mainscreenRoot.signTURN_L
        signTURN_R:mainscreenRoot.signTURN_R
        signSeatBelt:mainscreenRoot.signSeatBelt
        signACC:mainscreenRoot.signACC
        speedValue:mainscreenRoot.speedValue
        signLDWOccur:mainscreenRoot.signLDWOccur
        switchDoorOpen:mainscreenRoot.switchDoorOpen
        signAirBagOff:mainscreenRoot.signAirBagOff/*反向關係*/
    }

    Item {/*下排控制面板------------------------*/
        id: controlTable
        y:710
        width: mainscreenRoot.width;
        height: 200
        visible: mainscreenRoot.showCtrlPanel
        Rectangle {
            anchors.fill: parent
            color: "gainsboro"
        }

        ControlBarButton {/*加速 油門*/
            id:speedUpKey
            x:300;y:10
            text: qsTr("加速")
            contentItem: Text {
                text: speedUpKey.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onPressed: {
                animateSpeedDown.stop()
                animateChargeUp.stop()
                animateSpeedUp.stop()
                console.log("[speedUp onPressed] speedValue : "+speedValue)
                if (currentGear == 'gear_d') {
                    animateSpeedUp.to = 240
                    animateSpeedUp.duration = (240 - speedValue) * 100
                    animateSpeedUp.start()
                } else if (currentGear === 'gear_r') {
                    if (speedValue > 40) {
                        speedValue = 0
                    }
                    animateSpeedUp.to = 40
                    animateSpeedUp.duration = (40 - speedValue) * 100
                    animateSpeedUp.start()
                }
                animatePowerUp.power = 100
                animatePowerUp.duration = 10000
                animatePowerUp.start()
            }
            onPressAndHold: {
                console.log("speedUp onPressAndHold")
            }
            onReleased: {
                animateSpeedUp.stop()
                animatePowerUp.stop()
                console.log("[speedUp onReleased] speedValue : "+speedValue)
                animateSpeedDown.stop()
                if (!signACC) {
                    animateSpeedDown.duration = speedValue*200
                    animateSpeedDown.start()
                    animateChargeUp.stop()
                    if (speedValue == 0) {
                        animateChargeUp.charge = 0
                    } else {
                        animateChargeUp.charge = 50
                    }
                    animateChargeUp.duration = 1000
                    animateChargeUp.start()
                }
            }
        }

        ControlBarButton {/*煞車*/
            id:speedDownKey
            anchors.top: speedUpKey.bottom
            anchors.left: speedUpKey.left
            anchors.topMargin: 5
            text: qsTr("煞車")
            contentItem: Text {
                text: speedDownKey.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onPressed: {
                console.log("[speedDown onPressed] speedValue : "+speedValue)
                if (speedValue != 0) {
                    animateSpeedDown.stop()
                    animateSpeedDown.to = 0
                    animateSpeedDown.duration = speedValue*5
                    animateSpeedDown.start()
                    console.log("[speedDown onPressed] chargeValue : "+chargeValue)
                    animateChargeUp.stop()
                    animateChargeUp.charge = 100
                    animateChargeUp.duration = 500
                    animateChargeUp.start()
                }
                signACC = false /*踩煞車，停止ACC功能*/
                signBrakes = true/*煞車信號*/
            }
            onPressAndHold: {
            }
            onReleased: {
                console.log("[speedDown onReleased] speedValue : "+speedValue)
                if (speedValue != 0) {
                    animateSpeedDown.stop()
                    animateSpeedDown.to = 0
                    animateSpeedDown.duration = speedValue*200
                    animateSpeedDown.start()
                    console.log("[speedDown onReleased] chargeValue : "+chargeValue)
                    animateChargeUp.stop()
                    animateChargeUp.charge = 50
                    animateChargeUp.duration = 1000
                    animateChargeUp.start()
                }
                signBrakes = false/*煞車信號*/
            }
        }

        ControlBarButton {/*左轉燈*/
            id:turnLeftKey
            visible: showCtrlAdv
            anchors.top: speedUpKey.bottom
            anchors.right: speedDownKey.left
            anchors.topMargin: 5
            anchors.rightMargin: 5
            text: qsTr("左轉")
            contentItem: Text {
                text: turnLeftKey.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onPressed: {
                if(signTURN_R){
                    signTURN_R = false;
                }
                signTURN_L = !signTURN_L
            }
        }

        ControlBarButton {/*右轉燈*/
            id:turnRightKey
            visible: showCtrlAdv
            anchors.top: speedUpKey.bottom
            anchors.left: speedDownKey.right
            anchors.topMargin: 5
            anchors.leftMargin: 5
            text: qsTr("右轉")
            contentItem: Text {
                text: turnRightKey.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onPressed: {
                if(signTURN_L){
                    signTURN_L = false;
                }
                signTURN_R = !signTURN_R
            }
        }

        Label {
            id:labelTitle
            visible: showCtrlAdv
            anchors.left: turnLeftKey.left
            anchors.top: turnLeftKey.bottom
            anchors.topMargin: 10
            text: "[駕駛模式]"
            font.pixelSize: 20
        }

        Item {
            id : dirveMode
            anchors.top: labelTitle.bottom
            anchors.left: labelTitle.left
            visible: showCtrlAdv
            ControlBarButton {/*Normal 模式*/
                id:normalMode
                anchors.top: parent.top
                anchors.left: parent.left
                width: 80;
                anchors.topMargin: 5
                text: qsTr("Normal")
                contentItem: Text {
                    text: normalMode.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onPressed: {
                    currentPlayMode = 'NORMAL'
                }
            }

            ControlBarButton {/*Sport 模式*/
                id:sportMode
                anchors.top: normalMode.top
                anchors.left: normalMode.right
                anchors.leftMargin: 5
                width: 80;
                text: qsTr("Sport")
                contentItem: Text {
                    text: sportMode.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onPressed: {
                    currentPlayMode = 'SPORT'
                }
            }

            ControlBarButton {/*Comfort 模式*/
                id:comfortMode
                anchors.top: sportMode.top
                anchors.left: sportMode.right
                anchors.leftMargin: 5
                width: 80;
                text: qsTr("Comfort")
                contentItem: Text {
                    text: comfortMode.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onPressed: {
                    currentPlayMode = 'COMFORT'
                }
            }
        }

        ButtonGroup {/*排檔桿*/
            id:buttonGroup;
            buttons: column_gear.children
        }

        Column {
            id:column_gear
            x:20;y:20
            spacing: -7
            RadioButton {
                id:radiobtn
                font.pixelSize: 20;checked: true;text: qsTr("P+拉起手煞")
                onCheckedChanged: {
                    if(checked) {
                        currentGear = 'gear_stop'
                    }
                }
            }
            RadioButton {
                font.pixelSize: 20;checked: false;text: qsTr("P")
                onCheckedChanged: {
                    if(checked) {
                        currentGear = 'gear_p'
                    }
                }
            }
            RadioButton {
                font.pixelSize: 20;text: qsTr("R")
                onCheckedChanged: {
                    if(checked) {
                        currentGear = 'gear_r'
                    }
                }
            }
            RadioButton {
                font.pixelSize: 20;text: qsTr("N")
                onCheckedChanged: {
                    if(checked) {
                        currentGear = 'gear_n'
                    }
                }
            }
            RadioButton {
                font.pixelSize: 20;text: qsTr("D")
                onCheckedChanged: {
                    if(checked) {
                        currentGear = 'gear_d'
                    }
                }
            }
        }

        ControlBarButton {/*方向鍵:上*/
            id:upKey
            x:600;y:10
            text: qsTr("上")
            autoRepeatDelay: 100
            contentItem: Text {
                text: upKey.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onPressed: {
                mainscreenRoot.keyPressed(Qt.Key_Up);
            }
        }

        ControlBarButton {/*方向鍵:下*/
            id:downKey
            anchors.top: upKey.bottom
            anchors.left: upKey.left
            anchors.topMargin: 50
            text: qsTr("下")
            contentItem: Text {
                text: downKey.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onPressed: {
                mainscreenRoot.keyPressed(Qt.Key_Down);
            }
        }

        ControlBarButton {/*方向鍵:左*/
            id:leftKey
            anchors.top: upKey.bottom
            anchors.right: downKey.left
            anchors.topMargin: 5
            anchors.rightMargin: 5
            text: qsTr("左")
            contentItem: Text {
                text: leftKey.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onPressed: {
                /*切換模式A-B-C-D*/
                mainscreenRoot.keyPressed(Qt.Key_Left);
            }
        }

        ControlBarButton {/*方向鍵:右*/
            id:rightKey
            anchors.top: upKey.bottom
            anchors.left: downKey.right
            anchors.topMargin: 5
            anchors.leftMargin: 5
            text: qsTr("右")
            contentItem: Text {
                text: rightKey.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onPressed: {
                /*切換模式A-B-C-D*/
                mainscreenRoot.keyPressed(Qt.Key_Right);
            }
        }

        Column {
            id:column_adas
            spacing: 5
            anchors.left: leftKey.left
            anchors.top: downKey.bottom
            anchors.topMargin: 5
            visible: showCtrlAdv
            Row {
                spacing: 5
                ControlBarButton {
                    id:btn_tired
                    x:10;y:10
                    width: 80;
                    text: qsTr("疲勞提示")
                    contentItem: Text {
                        text: btn_tired.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onPressed: {
                        signDAM = true
                    }
                    onPressAndHold: {
                    }
                    onReleased: {
                        signDAM = false
                    }
                }

                ControlBarButton {
                    id:btn_BrakeStop
                    x:10;y:10
                    width: 80;
                    text: qsTr("自動煞停")
                    contentItem: Text {
                        text: btn_BrakeStop.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onPressed: {
                        signAEB = true
                    }
                    onPressAndHold: {
                    }
                    onReleased: {
                        signAEB = false
                    }
                }

                ControlBarButton {
                    id:btn_brakeHint
                    x:10;y:10
                    width: 80;
                    text: qsTr("碰撞提醒")
                    contentItem: Text {
                        text: btn_brakeHint.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onPressed: {
                        signFCW = true
                    }
                    onPressAndHold: {
                    }
                    onReleased: {
                        signFCW = false
                    }
                }
            }
        }

        Column {
            id:column_1
            spacing: 5
            x:800
            visible: showCtrlAdv
            DemoSwitch {
                id:accSwitch
                text: qsTr("ACC開關")
                checked: signACC
                onCheckedChanged: {
                    console.log("[accSwitch onCheckedChanged] signACC: "+ signACC)
                    if(checked) {
                        signACC = true
                    } else {
                        signACC = false
                    }
                }
            }

            DemoSwitch {/*安全帶*/
                id:seatBeltSwitch
                text: qsTr("安全帶")
                checked: signSeatBelt
                onCheckedChanged: {
                    if(checked) {
                        signSeatBelt = true
                    } else {
                        signSeatBelt = false
                    }
                }
            }

            DemoSwitch {/*開駕駛座車門*/
                id:driver_door
                text: qsTr("駕駛座門")
                checked: switchDoor_FL
                onCheckedChanged: {
                    if (checked) {
                        switchDoor_FL = true
                        switchDoorOpen = true
                    } else {
                        switchDoor_FL = false
                        switchDoorOpen = false
                    }
                }
            }

            DemoSwitch {
                id:naviSwitch
                text: qsTr("導航顯示")
                checked: switchNaviNext
                onCheckedChanged: {
                    if (checked) {
                        switchNaviNext = true
                        switchNaviRemain = true
                    } else {
                        switchNaviNext = false
                        switchNaviRemain = false
                    }
                }
            }
        }

        Column {
            id:column_3
            spacing: 5
            anchors.left: column_1.right
            Row {
                spacing: 5
                visible: showCtrlAdv
                DemoSwitch {
                    id:ldwSwitch
                    text: qsTr("車道偏移")
                    checked: switchLDW
                    onCheckedChanged: {
                        if (checked) {
                            switchLDW = true
                        } else {
                            switchLDW = false
                        }
                    }
                }

                ControlBarButton {/*車道偏移:偏左邊*/
                    id:ldw_left
                    x:10;y:10
                    width: 70
                    text: qsTr("偏左邊")
                    contentItem: Text {
                        text: ldw_left.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onPressed: {
                        if(typeApage.typeALdwSwitch){
                            signLDW_L = true
                            signLDWOccur = true
                        }
                    }
                    onPressAndHold: {
                    }
                    onReleased: {
                        if(typeApage.typeALdwSwitch){
                            signLDW_L = false
                            signLDWOccur = false
                        }
                    }
                }

                ControlBarButton {/*車道偏移:偏右邊*/
                    id:ldw_right
                    x:10;y:10
                    width: 70
                    text: qsTr("偏右邊")
                    contentItem: Text {
                        text: ldw_right.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onPressed: {
                        if(typeApage.typeALdwSwitch){
                            signLDW_R = true
                            signLDWOccur = true
                        }
                    }
                    onPressAndHold: {
                    }
                    onReleased: {
                        if(typeApage.typeALdwSwitch){
                            signLDW_R = false
                            signLDWOccur = false
                        }
                    }
                }
            }

            Row {/*盲點控制面板*/
                spacing: 5
                visible: showCtrlAdv
                DemoSwitch {
                    id:bsdSwitch
                    text: qsTr("盲點偵測")
                    checked: switchBSD
                    onCheckedChanged: {
                        if (checked) {
                            switchBSD = true
                        } else {
                            switchBSD = false
                        }
                    }
                }

                ControlBarButton {/*盲點BSD:左邊*/
                    id:button_bsd_left
                    x:10;y:10
                    text: qsTr("左邊")
                    contentItem: Text {
                        text: button_bsd_left.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onPressed: {
                        if(typeApage.bsd_Switch){
                            signBSD_L = true
                        }
                    }
                    onPressAndHold: {
                    }
                    onReleased: {
                        if(typeApage.bsd_Switch){
                            signBSD_L = false
                        }
                    }
                }

                ControlBarButton {/*盲點BSD:右邊*/
                    id:button_bsd_right
                    x:10;y:10
                    text: qsTr("右邊")
                    contentItem: Text {
                        text: button_bsd_right.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onPressed: {
                        if(typeApage.bsd_Switch){
                            signBSD_R = true
                        }
                    }
                    onPressAndHold: {
                    }
                    onReleased: {
                        if(typeApage.bsd_Switch){
                            signBSD_R = false
                        }
                    }
                }
            }

            Row {/*後方碰撞偵測控制面板*/
                visible: showCtrlAdv
                spacing: 5
                DemoSwitch {
                    id:rctaSwitch
                    text: qsTr("倒車警示")
                    checked: switchRCTA
                    onCheckedChanged: {
                        if (checked) {
                            switchRCTA = true
                        } else {
                            switchRCTA = false
                        }
                    }
                }

                ControlBarButton {/*RCTA:左邊*/
                    id:button_rcta_left
                    x:10;y:10
                    text: qsTr("左邊")
                    contentItem: Text {
                        text: button_rcta_left.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onPressed: {
                        if(switchRCTA){
                            signRCTA_L = true
                        }
                    }
                    onPressAndHold: {
                    }
                    onReleased: {
                        if(switchRCTA){
                            signRCTA_L = false
                        }
                    }
                }

                ControlBarButton {/*RCTA:中間*/
                    id:button_rcta_middle
                    x:10;y:10
                    text: qsTr("中間")
                    contentItem: Text {
                        text: button_rcta_middle.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onPressed: {
                        if(switchRCTA){
                            signRCTA_C = true
                        }
                    }
                    onPressAndHold: {
                    }
                    onReleased: {
                        if(switchRCTA){
                            signRCTA_C = false
                        }
                    }
                }

                ControlBarButton {/*RCTA:右邊*/
                    id:button_rcta_right
                    x:10;y:10
                    text: qsTr("右邊")
                    contentItem: Text {
                        text: button_rcta_right.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onPressed: {
                        if(switchRCTA){
                            signRCTA_R = true
                        }
                    }
                    onPressAndHold: {
                    }
                    onReleased: {
                        if(switchRCTA){
                            signRCTA_R = false
                        }
                    }
                }
            }

            DemoSwitch {
                id:chargeSwitch
                text: qsTr("充電槍插入")
                checked: chargePage.show
                onCheckedChanged: {
                    if (checked) {
                        chargePage.show = true
                    } else {
                        chargePage.show = false
                    }
                }
            }
        }
    }

    NumberAnimation {/*加速*/
        id:animateSpeedUp
        target: mainscreenRoot
        properties: "speedValue"
        from:mainscreenRoot.speedValue
        to:240
        duration: 24000
        easing {
            type:Easing.OutQuart
        }
    }

    PropertyAnimation {/*減速*/
        id: animateSpeedDown
        target: mainscreenRoot
        properties: "speedValue"
        to: 0
        duration: mainscreenRoot.speedValue*200
    }

    SequentialAnimation {
        id:animatePowerUp
        running: false
        property int power: 100
        property int duration: 500
        NumberAnimation {
            target: mainscreenRoot
            properties: "chargeValue"
            to:0
            duration: mainscreenRoot.chargeValue*5
        }
        NumberAnimation {
            target: mainscreenRoot
            properties: "lostKwh"
            to: animatePowerUp.power
            duration: animatePowerUp.duration
            easing {
                type:Easing.OutQuart
            }
        }
    }

    SequentialAnimation {
        id:animateChargeUp
        running: false
        property int charge: 100
        property int duration: 500
        NumberAnimation {
            target: mainscreenRoot
            properties: "lostKwh"
            to:0
            duration: mainscreenRoot.lostKwh*5
        }
        NumberAnimation {
            target: mainscreenRoot
            properties: "chargeValue"
            to: animateChargeUp.charge
            duration: animateChargeUp.duration
        }
    }

    Button {/*開機畫面*/
        id: bootupScreen
        x: 0
        y: 0
        width: parent.width
        height: 1080  //720
        visible: false
        Rectangle {
            width: parent.width
            height: parent.height
            color: '#ff000000'
        }
        Text {
            id: bootText
            text: qsTr("E事業群")
            color: '#ffc0c0c0'
            anchors.centerIn : parent
            anchors.topMargin: 50
            font.pixelSize: 200
            font.family: '微軟正黑體'
        }
        Text {
            id: bootText2
            text: qsTr("Qt軟體開發數位儀表板 實作展示影片")
            color: '#ffc0c0c0'
            anchors.horizontalCenter : parent.horizontalCenter
            anchors.top: bootText.bottom
            anchors.topMargin: 20
            font.pixelSize: 80
            font.family: '微軟正黑體'
        }
        NumberAnimation on opacity {
            id: animateBoot
            to:0
            duration: 2000
            easing.type: Easing.InOutQuad
            running: false
        }
        onPressed: {
            animateBoot.stop()
            bootupScreen.visible = false
            topicText.content = ''
            topicText.hint = ''
        }
    }

    onSpeedValueChanged: {
        if (signSpeedLimit) {
            updateToastInfo();
        }
    }

    function switchType(key){/* 切換 Type A/Type B/Type C/Type D/Type E*/
        if(key === Qt.Key_Left){
            console.log("key = Key_Left");
            if(defaultIndex > 0){
                defaultIndex--
            } else {
                defaultIndex = swipeview.count-1
            }
            console.log("defaultIndex = " + defaultIndex);
        } else if (key === Qt.Key_Right) {
            console.log("key = Key_Right");
            if (defaultIndex < swipeview.count-1) {
                defaultIndex++
            } else {
                defaultIndex = 0
            }
            console.log("defaultIndex = " + defaultIndex);
        }
    }

    onSwitchNaviNextChanged: {
        if(!switchNaviNext) {
            nextRoadDistance = 60
            roadDistancetimer.stop()
        } else {
            roadDistancetimer.start()
        }
    }

 /* //Speed value and charge value for default demo animation
    Timeline {
        id: timeline
        animations: [
            TimelineAnimation {
                id: timelineAnimation
                duration: 10000
                pingPong: false
                loops: -1
                running: true
                from: 0
                to: 200

            }
        ]
        startFrame: 0
        endFrame: 200
        enabled: mainscreenRoot.startTimeline
        KeyframeGroup {
            target: mainscreenRoot
            property: "speedValue"

            Keyframe {
                value: 101
                frame: 0
            }

            Keyframe {
                value: 125
                frame: 50
            }

            Keyframe {
                value: 110
                frame: 100
            }

            Keyframe {
                value: 135
                frame: 150
            }

            Keyframe {
                value: 100
                frame: 200
            }
        }
        KeyframeGroup {
            target: mainscreenRoot
            property: "lostKwh"

            Keyframe {
                value: 31
                frame: 0
            }

            Keyframe {
                value: 40
                frame: 50
            }

            Keyframe {
                value: 35
                frame: 100
            }

            Keyframe {
                value: 50
                frame: 140
            }

            Keyframe {
                value: 30
                frame: 200
            }
        }
    }
*/

    Timer {
        id:timer
        interval: 5000; running: true; repeat: true;
        onTriggered: mainscreenRoot.gcMemory();
        triggeredOnStart:true
    }

    function gcMemory() {
        gc();
    }

    ParallelAnimation {/*車子減速動畫*/
        id:speedDownAnimation
        property int startValue:100
        property int durationTime:startValue*20

        NumberAnimation {
            target: mainscreenRoot
            property: "speedValue"
            from: speedDownAnimation.startValue
            to:0
            duration: speedDownAnimation.durationTime
        }

        SequentialAnimation {
            NumberAnimation {
                target: mainscreenRoot
                properties: "lostKwh"
                from:mainscreenRoot.lostKwh
                to:0
                duration: speedDownAnimation.durationTime*0.1
            }
            NumberAnimation {
                target: mainscreenRoot
                properties: "chargeValue"
                from:0
                to: 30
                duration: speedDownAnimation.durationTime*0.15
            }

            NumberAnimation {
                target: mainscreenRoot
                properties: "chargeValue"
                from:30
                to: 40
                duration: speedDownAnimation.durationTime*0.7
            }

            NumberAnimation {
                target: mainscreenRoot
                properties: "chargeValue"
                from:40
                to: 0
                duration: speedDownAnimation.durationTime*0.05
            }
        }
    }

    ParallelAnimation {/*車子加速動畫*/
        id:speedUpAnimation
        property int startValue:100
        property int durationTime:3000-(startValue*20)

        onRunningChanged: {
            if(!speedUpAnimation.running) {
                if (mainscreenRoot.signBrakeLamp != true){
                    timelineAnimation.resume();
                }
            }
        }

        NumberAnimation {
            target: mainscreenRoot
            property: "speedValue"
            from: speedUpAnimation.startValue
            to:mainscreenRoot.tempSpeed
            duration: speedUpAnimation.durationTime
        }

        SequentialAnimation {
            NumberAnimation {
                target: mainscreenRoot
                properties: "chargeValue"
                from:mainscreenRoot.chargeValue
                to:0
                duration: speedUpAnimation.durationTime*0.15
            }
            NumberAnimation {
                target: mainscreenRoot
                properties: "lostKwh"
                from:mainscreenRoot.lostKwh
                to: mainscreenRoot.tempPWR
                duration: speedUpAnimation.durationTime*0.85
            }
        }
    }

    Connections {
        target: qtAndroidService  // The qtAndroidService here is set through setContextProperty

        function onMessageFromService(message) {/* For test*/
            console.log("dawi_qml_onMessageFromService");
             console.log("message: " + message);
        }

        function onGearInfoFromService(gearInfo){/*收到 Gear:P, R, N, D 信號改變*/
            console.log("dawi_onGearInfoFromService");
            console.log("dawi_gear: " + gearInfo);
            gearImage.gear = gearInfo;

            if(gearImage.gear === 'gear_stop') {
                gearImage.source = "signalimg/gear_park.png"

            } else if (gearImage.gear === 'gear_p') {
                gearImage.source = "signalimg/gear_p.png"

            } else if (gearImage.gear === 'gear_d') {
                gearImage.source = "signalimg/gear_d.png"

            } else if (gearImage.gear === 'gear_n') {
                gearImage.source = "signalimg/gear_n.png"

            } else if (gearImage.gear === 'gear_r') {
                gearImage.source = "signalimg/gear_r.png"

            }
        }

        function onOduTempValueFromService(oduTempValue){/*收到 ODU Temp 信號改變*/
            console.log("dawi_onOduTempValueFromService");
            console.log("dawi_ODU_Temp: " + oduTempValue + " degC");
            text_Time.text_tempText = oduTempValue + " °C"
        }

        function onSpeedValueFromService(speedValue){/*收到 Speed value 信號改變*/
            console.log("dawi_onSpeedValueFromService");
            console.log("dawi_speed: " + speedValue + " km/h");
            var intSpeedValue = parseInt(speedValue);
            mainscreenRoot.speedValue = intSpeedValue;
        }

        function onSocValueFromService(socValue){/*收到 Battery SOC value 信號改變*/
            console.log("dawi_onSocValueFromService");
            console.log("dawi_SOC: " + socValue + " %");
            var intSocValue = parseInt(socValue);
            text_Battery.text_SocText = intSocValue + " %";
            text_Battery.power_w_BatteryRegular = intSocValue*0.3; //30*0.1
        }

        function onDrivingMileageFromService(drivingMileageValue){/*收到 Driving Mileage 信號改變*/
            console.log("dawi_onDrivingMileageFromService");
            console.log("dawi_drivingMileage: " + drivingMileageValue + " km");
            var intDrivingMileageValue= parseInt(drivingMileageValue);
            text_Battery.text_milageText = intDrivingMileageValue + " km";
        }

        function onSignalChange(iconId, iconStatus){/*收到 Can Service 信號改變*/
            console.log("dawi_mainScreen_onSignalChange")
            //console.log("CanId: " + iconId + ", CanStatus: " + iconStatus + "\n======\n")
            if(iconId === "ZGW_BrakeLamp_Req"){
                /*Can 煞車燈*/
                if(iconStatus === "Open") {
                    mainscreenRoot.signBrakeLamp = true;
                } else if (iconStatus === "Close") {
                    mainscreenRoot.signBrakeLamp = false;
                }
            } else {
                signelPage.iconID = iconId;
                if (iconStatus === "Opened") {
                    console.log("Signal: " + iconId );
                    console.log("Status: " + iconStatus + "\n======\n");
                    signelPage.iconStatus = true;

                } else if (iconStatus === "Closed") {
                    console.log("Signal: " + iconId );
                    console.log("Status: " + iconStatus + "\n======\n");
                    signelPage.iconStatus = false;

                } else if (iconStatus === "Yaw_Alarm") {
                    console.log("dawi_Status: " + iconStatus + "\n======\n");
                    mainscreenRoot.signDMS_Yaw = true;
                    updateToastInfo();

                } else if (iconStatus === "Yaw_NotAlarm") {
                    console.log("dawi_Status: " + iconStatus + "\n======\n");
                    mainscreenRoot.signDMS_Yaw = false;
                    updateToastInfo();

                } else if (iconStatus === "PhoneCall_Alarm") {
                    console.log("dawi_Status: " + iconStatus + "\n======\n");
                    mainscreenRoot.signDMS_PhoneCall = true;
                    updateToastInfo();

                } else if (iconStatus === "PhoneCall_NotAlarm") {
                    console.log("dawi_Status: " + iconStatus + "\n======\n");
                    mainscreenRoot.signDMS_PhoneCall = false;
                    updateToastInfo();

                }
            }
        }

        function onCurrentVolume(currVol,maxVol,minVol){/*收到音量變化*/
            console.log("qml_onCurrentVolume");
            console.log("currVol: " + currVol);
            console.log("maxVol: " + maxVol);
            console.log("minVol: " + minVol + "\n======\n");
            volumepProgressBar.maxVol = maxVol;
            volumepProgressBar.minVol = minVol;
            volumepProgressBar.currVol = currVol;
            animateVolumeBar.stop();
            animateVolumeBar.start();
        }

        function onDriveModeChange(driveMode){/*收到行車模式變更*/
            console.log("onDriveModeChange, (driveMode: " + driveMode + ")")
            if (driveMode === 'normal') {
                mainscreenRoot.currentPlayMode = 'NORMAL';
            } else if (driveMode === 'comfort') {
                mainscreenRoot.currentPlayMode = 'COMFORT';
            } else if (driveMode === 'sport') {
                mainscreenRoot.currentPlayMode = 'SPORT';
            }
        }

        function onSendKeyCode(keycode){/*收到KeyCode*/
            console.log("onSendKeyCode, (keycode: " + keycode + ")");
            if (keycode === "DPAD_UP") {
                mainscreenRoot.keyPressed(Qt.Key_Up);
            } else if (keycode === "DPAD_DOWN") {
                mainscreenRoot.keyPressed(Qt.Key_Down);
            } else if (keycode === "DPAD_LEFT") {
                /*切換模式A-B-C-D*/
                mainscreenRoot.keyPressed(Qt.Key_Left);
            } else if (keycode === "DPAD_RIGHT") {
                /*切換模式A-B-C-D*/
                mainscreenRoot.keyPressed(Qt.Key_Right);
            } else if (keycode === "KEYCODE_C") {
                /*減速*/
                mainscreenRoot.signBrakeLamp = true;
            } else if (keycode === "KEYCODE_V") {
                /*加速*/
                mainscreenRoot.signBrakeLamp = false;
            }
        }

        function onKneoUserName(userName){/*收到耐能解鎖用戶名*/
            console.log("onDriveModeChange, (userName: " + userName + ")");
            bootAnimation.start();
        }

        function onSpeedLimit(limitstatus,limitvalue){/*收到限速模式狀態變化*/
            console.log("onSpeedLimit, (limitstatus = " + limitstatus
                        + ", limitValue = " + limitvalue + ")");
            mainscreenRoot.signSpeedLimit = limitstatus;
            mainscreenRoot.limitSpeedValue = limitvalue;
        }

        function onPacosStatus(bagStatus){/*收到副駕駛安全氣囊開關*/
            console.log("onPacosStatus, (status = " + bagStatus + ")");
            mainscreenRoot.signAirBagOff = !bagStatus;/*ture:開啟安全氣囊 false:關閉安全氣囊*/
        }

        function onChargeModeStatus(status){/*收到充電頁狀態改變*/
            console.log("onChargeModeStatus, status = " + status);
            if (status === "0") {
                /*退出充電模式*/
                chargePage.show = false
                mainscreenRoot.chargeStatus = "Regular"
            } else if (status === "1") {
                /*開始充電*/
                chargePage.show = true
                mainscreenRoot.chargeStatus = "Charge"
            } else if (status === "2") {
                /*充電完成*/
                chargePage.show = true
                mainscreenRoot.chargeStatus = "Completed"
            } else if (status === "3") {
                /*排程充電*/
                if(chargePage.show === false)
                    mainscreenRoot.chargeStatus = "Scheduled"
            } else if (status === "4") {
                /*充電不穩定*/
                if(chargePage.show)
                    mainscreenRoot.chargeStatus = "Unstable"
            } else if (status === "5") {
                /*充電異常*/
                if(chargePage.show)
                    mainscreenRoot.chargeStatus = "Error"
            }
        }
    }

    VolumeProgressBar {/*音量bar*/
        id: volumepProgressBar
        x:30;y:120
        volumeBgColor:'#14336B'
    }

    SequentialAnimation {
        id:animateVolumeBar
        running: false
        PropertyAnimation {
            target: volumepProgressBar
            properties: "visible"
            to:true
            duration: 200
            easing {
                type:Easing.OutQuart
            }
        }

        PropertyAnimation {
            target: volumepProgressBar
            properties: "visible"
            to:true
            duration: 1500
        }

        PropertyAnimation {
            target: volumepProgressBar
            properties: "visible"
            to: false
            duration: 200
            easing {
                type:Easing.OutQuart
            }
        }
    }

    Component.onCompleted:{
//        console.log("Component.onCompleted");
//        typeApage.middle_CarY = 450
//        typeApage.middle_CarVisible = false
//        mainscreenRoot.signBrakeLamp = false;
    }
}
