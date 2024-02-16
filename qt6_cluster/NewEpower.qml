import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
//import QtGraphicalEffects 1.15

Item {
    id: root
    clip: false
    width: 660
    height: 600
    transformOrigin: Item.Center
    property int nowKwh: mainscreenRoot.lostKwh
    property int nowChargeValue: mainscreenRoot.chargeValue
    property string currentPlayMode /*當前指定的playMode*/
    property string animateStatus: 'IN'

    onAnimateStatusChanged: {
        if (animateStatus == 'IN') {
            blur_epower.visible = true;
            blurOprate.visible = false;
        } else {
            blur_epower.visible = false;
            blurOprate.visible = true;
        }
    }

    states: [
        State {
            name: "NORMAL"
            when: (root.currentPlayMode == 'NORMAL')
            PropertyChanges {
                target: blur_epower
                source: "qrc:/assets/power_background_normal.png"
            }
        },
        State {
            name: "COMFORT"
            when: (root.currentPlayMode == 'COMFORT')
            PropertyChanges {
                target: blur_epower
                source: "qrc:/assets/power_background_comfort.png"
            }
        },
        State {
            name: "SPORT"
            when: (root.currentPlayMode == 'SPORT')
            PropertyChanges {
                target: blur_epower
                source: "qrc:/assets/power_background_sport.png"
            }
        }
    ]

    Image {
        id: blur_epower
        width: 660
        height: 600
        sourceSize.width: 660
        sourceSize.height: 600
        source:"qrc:/assets/power_background_normal.png"
    }

    FastBlur {
        id:blurOprate
        anchors.fill: blur_epower
        source: blur_epower
        radius: 60
        visible: false
    }

    /*耗電表*/
    Item {
        id: powerItem
        anchors.fill: parent

        /*金邊打光*/
        ValueMask {
            width: 660;height: 600
            speed: nowKwh
            maskSource: "qrc:/assets/power_mask_line.png"
            source: "qrc:/assets/speed_light_line.png"
            sourceWidth: 78
            sourceHeight: 78
            pointPos: Qt.point(372,501)/*source圖左上角起點座標*/
            posList: [
                {'value':0,'point':Qt.point(372,501)},
                {'value':50,'point':Qt.point(510,261)},
                {'value':100,'point':Qt.point(374,22)}
            ]
        }

        SectorCanvas {
            id:pwrCanvas
            width: 660;height: 600
            speed: nowKwh
            gradientColorList:[
                {'value':0,'color':"#31253F"},
                {'value':0.25,'color':"#94575E"},
                {'value':0.5,'color':"#F6BB6D"},
                {'value':0.75,'color':"#FFE68D"},
                {'value':1,'color':"#FFEFB7"}
            ]
            posList: [
                {'value':0,'x1':413,'y1':530,'x2':384.5,'y2':483},
                {'value':50,'x1':547,'y1':300,'x2':492,'y2':300},
                {'value':100,'x1':410,'y1':66,'x2':382.5,'y2':113}
            ]
            maskSource:"qrc:/assets/power_mask_bar.png"
            scaleImgSource:"qrc:/assets/power_scale.png"
            gradientStartPoint:Qt.point(413,530)
            scaleOpacityMaskVisible:true
        }

        /*耗電表內圈柵欄*/
        SectorCanvas {
            width: 660;height: 600
            speed: nowKwh
            gradientColorList:[
                {'value':0,'color':"#0031253F"},
                {'value':0.25,'color':"#0031253F"},
                {'value':0.85,'color':"#BFF6BB6D"},
                {'value':1,'color':"#FFFFEFB7"}
            ]
            posList: [
                {'value':0,'x1':413,'y1':530,'x2':364,'y2':450},
                {'value':50,'x1':547,'y1':300,'x2':454.5,'y2':300},
                {'value':100,'x1':410,'y1':66,'x2':364,'y2':145.5}
            ]
            maskSource:"qrc:/assets/power_mask_decorate.png"
            gradientStartPoint:Qt.point(388.5,490)
            scaleOpacityMaskVisible:false
        }

        /*耗電表刻度值打光*/
        ValueMask {
            width: 660;height: 600
            speed: nowKwh
            maskSource: "qrc:/assets/power_mask_value.png"
            source: "qrc:/assets/speed_light_value.png"
            sourceWidth: 360
            sourceHeight: 360
            pointPos: Qt.point(247,387)/*source圖左上角起點座標*/
            posList: [
                {'value':0,'point':Qt.point(247,387)},
                {'value':50,'point':Qt.point(412,118)},
                {'value':100,'point':Qt.point(283,-114)}
            ]
            visible: true
        }

        /*耗電表指針*/
        Item {
            width: 660;height:600
            Image {
                id: pointerMask
                anchors.fill: parent
                source: "qrc:/assets/power_mask_light_front.png"
                sourceSize.width: 660
                sourceSize.height: 600
                visible: false
            }

            Item {
                id:pointerImg
                anchors.fill: parent
                visible: false
                TablePointer {
                    id:pointer
                    x:-56;y:-30
                    width: 660;height:660
                    source: "qrc:/assets/power_light_front.png"
                    initAngle: -121
                    speed: nowKwh
                    centerPos:Qt.point(274,300)
                    startPos:Qt.point(413,530)
                    endPos:Qt.point(413,530)
                    posList: [
                        {'value':0,'point':Qt.point(413,530)},
                        {'value':50,'point':Qt.point(547,300)},
                        {'value':100,'point':Qt.point(410,66)}
                    ]
                    positive:false
                }
            }

            OpacityMask {
                anchors.fill: parent
                visible: true
                source: pointerImg;maskSource: pointerMask
                clip: false
            }
        }
    }

    /*充電表*/
    Item {
        id: chargeItem
        anchors.fill: parent
        visible: false
        /*金邊打光*/
        ValueMask {
            width: 660;height: 600
            speed: nowChargeValue
            maskSource: "qrc:/assets/power_mask_line.png"
            source: "qrc:/assets/speed_light_line.png"
            sourceWidth: 78
            sourceHeight: 78
            pointPos: Qt.point(372,501)/*source圖左上角起點座標*/
            posList: [
                {'value':0,'point':Qt.point(372,501)},
                {'value':100,'point':Qt.point(95,501)}
            ]
        }

        SectorCanvas {
            id:chgCanvas
            width: 660;height: 600
            speed: nowChargeValue
            gradientColorList:[
                {'value':0,'color':"#113477"},
                {'value':0.33,'color':"#00909E"},
                {'value':0.66,'color':"#25E199"},
                {'value':1,'color':"#AAFFB2"}
            ]
            posList: [
                {'value':0,'x1':375,'y1':488,'x2':400,'y2':534},
                {'value':100,'x1':164,'y1':488,'x2':137,'y2':534}
            ]
            maskSource:"qrc:/assets/power_mask_bar.png"
            scaleImgSource:"qrc:/assets/power_scale.png"
            gradientStartPoint:Qt.point(400,534)
            scaleOpacityMaskVisible:true
        }

        /*耗電表內圈柵欄*/
        SectorCanvas {
            width: 660;height: 600
            speed: nowChargeValue
            gradientColorList:[
                {'value':0,'color':"#0025E199"},
                {'value':0.25,'color':"#0025E199"},
                {'value':0.85,'color':"#25E199"},
                {'value':1,'color':"#AAFFB2"}
            ]
            posList: [
                {'value':0,'x1':357,'y1':454,'x2':400,'y2':534},
                {'value':100,'x1':183,'y1':454,'x2':137,'y2':534}
            ]
            maskSource:"qrc:/assets/power_mask_decorate.png"
            gradientStartPoint:Qt.point(400,534)
            scaleOpacityMaskVisible:false
        }

        /*充電表刻度值打光*/
        ValueMask {
            width: 660;height: 600
            speed: nowChargeValue
            maskSource: "qrc:/assets/power_mask_value.png"
            source: "qrc:/assets/speed_light_value.png"
            sourceWidth: 360
            sourceHeight: 360
            pointPos: Qt.point(247,387)/*source圖左上角起點座標*/
            posList: [
                {'value':0,'point':Qt.point(247,387)},
                {'value':100,'point':Qt.point(-47,387)}
            ]
            visible: true
        }

        /*充電表指針*/
        Item {
            width: 660;height:600
            Image {
                id: pointerMaskCharge
                anchors.fill: parent
                source: "qrc:/assets/power_mask_light_front_charge.png"
                visible: false
                sourceSize.width: 660
                sourceSize.height: 600
            }

            Item {
                id:pointerImgCharge
                anchors.fill: parent
                visible: false
                TablePointer {
                    id:pointerCharge
                    x:-56;y:-30
                    width: 660;height:660
                    source: "qrc:/assets/speed_light_front.png"
                    initAngle: -118
                    speed: nowChargeValue
                    centerPos:Qt.point(274,300)
                    startPos:Qt.point(400,534)
                    endPos:Qt.point(400,534)
                    posList: [
                        {'value':0,'point':Qt.point(400,534)},
                        {'value':100,'point':Qt.point(137,534)}
                    ]
                    positive:true
                }
            }

            OpacityMask {
                anchors.fill: parent
                visible: true
                source: pointerImgCharge;maskSource: pointerMaskCharge
                clip: false
            }
        }
    }

    onNowChargeValueChanged: {
        changeImgAndColor()
    }

    onNowKwhChanged: {
        changeImgAndColor()
    }

    function changeImgAndColor() {
        if (nowKwh > 0) {
            powerItem.visible = true
            chargeItem.visible = false
        } else if (nowChargeValue > 0) {
            powerItem.visible = false
            chargeItem.visible = true
        } else {
            powerItem.visible = true
            chargeItem.visible = false
        }
    }
}
