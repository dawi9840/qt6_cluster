import QtQuick 2.15

Item {
    id: root
    width: 732
    height: 342

    property string currentGear: 'gear_stop'
    property int animateTime:1000
    property bool ldwSwitchStatus: true /*車道偏移開關*/
    property bool ldwRightWarning: false /*車道偏移:右*/
    property bool ldwLeftWarning: false /*車道偏移:左*/
    property var ldwRightLineColor: ldwOffColor
    property var ldwLeftLineColor: ldwOffColor
    property double speedPercent: 0.5 /*0~1:ldw線亮色漸層位置*/
    property bool rctaSwitch: true
    property bool switchBSD: true/*盲點偵測開關*/
    property bool bsd_left: false/*盲點偵測:左*/
    property bool bsd_right: false/*盲點偵測:右*/

    property bool switchRCTA: true/*RCTA開關*/
    property bool rcta_left: false/*RCTA:左後方*/
    property bool rcta_middle: false/*RCTA:後方中間*/
    property bool rcta_right: false/*RCTA:右後方*/

    property bool switchACC: false/*ACC開關*/
    property bool signBrakes: false/*煞車信號*/

    property string currentPlayMode /*當前指定的playMode*/
    property bool timerRunning:false;
    property int speedValue:mainscreenRoot.speedValue

    onSpeedValueChanged: {
        if (speedValue > 0 && timer.running != true) {
            timer.running = true;
        } else if(speedValue == 0 && timer.running == true){
            timer.running = false;
        }
    }

    states: [
        State {
            name: "NORMAL"
            when: (root.currentPlayMode == 'NORMAL')
            PropertyChanges {
                target: root
                betweenMiddleRoadColor: ["#0A1427","#14336B","#0A1427"]
            }

            PropertyChanges {
                target: root
                middleRoadColor: ["#0A1427","#1D4388","#0A1427"]
            }

            PropertyChanges {
                target: root
                ldwWarningColor: ["#00F21856","#FFF21856","#00F21856"]
            }

            PropertyChanges {
                target: root
                ldwOffColor: ["#0015284A","#3B79C3","#0015284A"]
            }

            PropertyChanges {
                target: root
                imgLeftCar:"qrc:/assets/car_left_normal.png"
            }

            PropertyChanges {
                target: root
                imgRightCar:"qrc:/assets/car_right_normal.png"
            }

            PropertyChanges {
                target: root
                imgFrontCar:"qrc:/assets/car_front_normal.png"
            }
        },
        State {
            name: "COMFORT"
            when: (root.currentPlayMode == 'COMFORT')
            PropertyChanges {
                target: root
                betweenMiddleRoadColor: ["#0C1F23","#0A403A","#0C1F23"]
            }

            PropertyChanges {
                target: root
                middleRoadColor: ["#0C1F23","#096051","#0C1F23"]
            }

            PropertyChanges {
                target: root
                ldwWarningColor: ["#00F21856","#FFF21856","#00F21856"]
            }

            PropertyChanges {
                target: root
                ldwOffColor: ["#000B302F","#088169","#000B302F"]
            }

            PropertyChanges {
                target: root
                imgLeftCar:"qrc:/assets/car_left_comfort.png"
            }

            PropertyChanges {
                target: root
                imgRightCar:"qrc:/assets/car_right_comfort.png"
            }

            PropertyChanges {
                target: root
                imgFrontCar:"qrc:/assets/car_front_comfort.png"
            }
        },
        State {
            name: "SPORT"
            when: (root.currentPlayMode == 'SPORT')
            PropertyChanges {/*ADAS兩側馬路底色*/
                target: root
                betweenMiddleRoadColor: ["#000000","#2D2D2D","#000000"]
            }

            PropertyChanges {/*ADAS中間馬路底色*/
                target: root
                middleRoadColor: ["#000000","#5A5A5A","#000000"]
            }

            PropertyChanges {/*ADAS區ldw示警色*/
                target: root
                ldwWarningColor: ["#00F21856","#FFF21856","#00F21856"]
            }

            PropertyChanges {
                target: root
                ldwOffColor: ["#00141414","#5A5A5A","#00141414"]
            }

            PropertyChanges {
                target: root
                imgLeftCar:"qrc:/assets/car_left_sport.png"
            }

            PropertyChanges {
                target: root
                imgRightCar:"qrc:/assets/car_right_sport.png"
            }

            PropertyChanges {
                target: root
                imgFrontCar:"qrc:/assets/car_front_sport.png"
            }
        }
    ]

    property var betweenMiddleRoadColor:["#0A1427","#14336B","#0A1427"]
    property var middleRoadColor:["#0A1427","#14336B","#0A1427"]
    property var ldwWarningColor:["#00F21856","#FFF21856","#00F21856"]
    property var ldwOffColor:["#0015284A","#3B79C3","#0015284A"]
    property string imgLeftCar:"qrc:/assets/car_left_normal.png"
    property string imgRightCar:"qrc:/assets/car_right_normal.png"
    property string imgFrontCar:"qrc:/assets/car_front_normal.png"


    /*ADAS左右線道*/
    Canvas {
        id: road_3
        x: 0
        y: 42
        width: 732
        height: 300
        antialiasing: true
        renderStrategy: Canvas.Threaded
        visible: (currentGear == 'gear_p' || currentGear == 'gear_stop')? false:true
        onPaint: {
            var ctx = getContext("2d")
            var gradient = ctx.createLinearGradient(153,0,153,300)
            gradient.addColorStop(0, betweenMiddleRoadColor[0])
            gradient.addColorStop(0.52,betweenMiddleRoadColor[1])
            gradient.addColorStop(1, betweenMiddleRoadColor[2])
            ctx.fillStyle = gradient
            ctx.beginPath()
            ctx.moveTo(246, 0)
            ctx.lineTo(486, 0)
            ctx.lineTo(732, 300)
            ctx.lineTo(0, 300)
            ctx.closePath()
            ctx.fill()

            ctx = null;
            gradient = null;
        }
    }

    /*中間線道*/
    Canvas {
        id: road_1
        x: 213
        y: 42
        width: 306
        height: 300
        antialiasing: true
        renderStrategy: Canvas.Threaded
        visible: (currentGear == 'gear_p' || currentGear == 'gear_stop')? false:true
        onPaint: {
            var ctx = getContext("2d")
            var gradient = ctx.createLinearGradient(153,0,153,300)
            gradient.addColorStop(0, middleRoadColor[0])
            gradient.addColorStop(0.52,middleRoadColor[1])
            gradient.addColorStop(1, middleRoadColor[2])
            ctx.fillStyle = gradient
            ctx.beginPath()
            ctx.moveTo(113, 0)
            ctx.lineTo(193, 0)
            ctx.lineTo(306, 300)
            ctx.lineTo(0, 300)
            ctx.closePath()
            ctx.fill()

            ctx = null;
            gradient = null;
        }
    }

    /*右邊ldw 車道偏移*/
    Canvas {
        id: ldw_right
        x: 406
        y: 42
        width: 121
        height: 300
        antialiasing: true
        renderStrategy: Canvas.Threaded
        visible: (currentGear == 'gear_p' || currentGear == 'gear_stop')? false:true
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0,0,width,height)
            var graOffset = 600*speedPercent;
            var gradient = ctx.createLinearGradient(1,-300+graOffset,117,300+graOffset)
            gradient.addColorStop(0, ldwRightLineColor[0])
            gradient.addColorStop(0.25,ldwRightLineColor[1])
            gradient.addColorStop(0.5, ldwRightLineColor[2])
            gradient.addColorStop(0.75,ldwRightLineColor[1])
            gradient.addColorStop(1, ldwRightLineColor[2])
            ctx.fillStyle = gradient
            ctx.beginPath()
            ctx.moveTo(2, 0)
            ctx.lineTo(0, 0)
            ctx.lineTo(113, 300)
            ctx.lineTo(121, 300)
            ctx.closePath()
            ctx.fill()

            ctx = null;
            gradient = null;
            graOffset = null;
        }
    }

    /*左邊ldw 車道偏移*/
    Canvas {
        id: ldw_left
        x: 205
        y: 42
        width: 121
        height: 300
        antialiasing: true
        renderStrategy: Canvas.Threaded
        visible: (currentGear == 'gear_p' || currentGear == 'gear_stop')? false:true
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0,0,width,height)
            var graOffset = 600*speedPercent;
            var gradient = ctx.createLinearGradient(1,-300+graOffset,117,300+graOffset)
            gradient.addColorStop(0, ldwLeftLineColor[0])
            gradient.addColorStop(0.25,ldwLeftLineColor[1])
            gradient.addColorStop(0.5, ldwLeftLineColor[2])
            gradient.addColorStop(0.75,ldwLeftLineColor[1])
            gradient.addColorStop(1, ldwLeftLineColor[2])
            ctx.fillStyle = gradient
            ctx.beginPath()
            ctx.moveTo(121, 0)
            ctx.lineTo(119, 0)
            ctx.lineTo(0, 300)
            ctx.lineTo(8, 300)
            ctx.closePath()
            ctx.fill()

            ctx = null;
            gradient = null;
            graOffset = null;
        }
    }

    /*右邊盲點區域*/
    Image {
        visible: root.switchBSD ? root.bsd_right : false
        id: bsd_right
        x: 408
        y: 170
        width: 252
        height: 120
        source: "qrc:/assets/adas_bsd_right.png"
        sourceSize.width: 252
        sourceSize.height: 120
    }

    /*左邊盲點區域*/

    Image {
        visible: root.switchBSD ? root.bsd_left : false
        id: bsd_left
        x: 72
        y: 170
        width: 252
        height: 120
        source: "qrc:/assets/adas_bsd_left.png"
        sourceSize.width: 252
        sourceSize.height: 120
    }

    /*右線車輛*/
    Image {
        id: car_right
        x: 475
        y: 126
        width: 204
        height: 204
        visible: switchACC
        source: imgRightCar
        sourceSize.width: 204
        sourceSize.height: 204
    }

    /*右後方緊急煞停指示燈*/
    Image {
        id: rcta_right
        x: 402
        y: 258
        width: 84
        height: 72
        visible: root.rcta_right
        source: "qrc:/assets/adas_rcta_right.png"
        sourceSize.width: 84
        sourceSize.height: 72
    }

    /*正後方緊急煞停指示燈*/
    Image {
        id: rcta_mid
        x: 293
        y: 272
        width: 146
        height: 58
        visible: root.rcta_middle
        source: "qrc:/assets/adas_rcta_mid.png"
        sourceSize.width: 146
        sourceSize.height: 58
    }

    /*左後方緊急煞停指示燈*/
    Image {
        id: rcta_left
        x: 246
        y: 258
        width: 84
        height: 72
        visible: root.rcta_left
        source: "qrc:/assets/adas_rcta_left.png"
        sourceSize.width: 84
        sourceSize.height: 72
    }

    /*中心汽車後視圖*/
    Image {
        id: car_main
        x: 249
        y: 72
        width: 234
        height: 234
        source: currentGear == 'gear_r'?(root.signBrakes ?"qrc:/assets/car_main_brake.png":"qrc:/assets/car_main_back_up.png"):(root.signBrakes ?"qrc:/assets/car_main_brake.png":"qrc:/assets/car_main.png")
        sourceSize.width: 234
        sourceSize.height: 234
    }

    /*ACC前方汽車標示*/
    Image {
        id: car_front
        x: 321
        y: -3
        width: 90
        height: 90
        visible: switchACC
        source: imgFrontCar
        sourceSize.width: 90
        sourceSize.height: 90
    }

    /*ACC 30m 警示線*/
    Canvas {
        id: acc_1
        x: 336
        y: 122
        width: 60
        height: 4
        antialiasing: true
        renderStrategy: Canvas.Threaded
        visible: switchACC
        onPaint: {
            var ctx = getContext("2d")
            ctx.fillStyle = "#21ff79"
            ctx.beginPath()
            ctx.moveTo(60, 4)
            ctx.lineTo(0, 4)
            ctx.lineTo(1, 0)
            ctx.lineTo(59, 0)
            ctx.closePath()
            ctx.fill()

            ctx = null;
        }
    }

    /*ACC 40m 警示線*/
    Canvas {
        id: acc_2
        x: 339
        y: 106
        width: 54
        height: 4
        antialiasing: true
        renderStrategy: Canvas.Threaded
        visible: switchACC
        onPaint: {
            var ctx = getContext("2d")
            ctx.fillStyle = "#21ff79"
            ctx.beginPath()
            ctx.moveTo(54, 4)
            ctx.lineTo(0, 4)
            ctx.lineTo(1, 0)
            ctx.lineTo(53, 0)
            ctx.closePath()
            ctx.fill()

            ctx = null;
        }
    }

    /*ACC 50m 警示線*/
    Canvas {
        id: acc_3
        x: 342
        y: 90
        width: 48
        height: 4
        antialiasing: true
        renderStrategy: Canvas.Threaded
        visible: switchACC
        onPaint: {
            var ctx = getContext("2d")
            ctx.fillStyle = "#0A403A"
            ctx.beginPath()
            ctx.moveTo(48, 4)
            ctx.lineTo(0, 4)
            ctx.lineTo(1, 0)
            ctx.lineTo(47, 0)
            ctx.closePath()
            ctx.fill()

            ctx = null;
        }
    }

    /*左邊車輛*/
    Image {
        id: car_left
        x: 205
        y: 24
        width: 108
        height: 108
        visible: switchACC
        source: imgLeftCar
        sourceSize.width: 108
        sourceSize.height: 108
    }

    onLdwLeftWarningChanged: {
        ldwLeftLineColor = ldwLeftWarning?ldwWarningColor:ldwOffColor
        ldw_left.requestPaint();
    }

    onLdwRightWarningChanged: {
        ldwRightLineColor = ldwRightWarning?ldwWarningColor:ldwOffColor
        ldw_right.requestPaint();
    }



    Timer {
        id:timer
        interval: 200; running: true; repeat: true;
        onTriggered: root.timeChanged()
        triggeredOnStart:false
    }

    function timeChanged() {
        if (currentGear == 'gear_r') {
            speedPercent = (speedPercent - 0.1).toFixed(1);
            if(speedPercent <= 0){
                speedPercent = 1
            }
        } else {
            speedPercent = (speedPercent + 0.1).toFixed(1);
            if(speedPercent > 1){
                speedPercent = 0
            }
        }

        ldw_right.requestPaint();
        ldw_left.requestPaint();

    }

    onCurrentPlayModeChanged: {
        road_3.requestPaint()
        road_1.requestPaint()
        ldw_right.requestPaint()
        ldw_left.requestPaint()
    }

}
