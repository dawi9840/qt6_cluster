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
//    property int nowSpeedValue: mainscreenRoot.speedValue
    property string currentPlayMode: "NORMAL" /*當前指定的playMode*/
    property string animateStatus: 'IN'

    onAnimateStatusChanged: {
        if (animateStatus == 'IN') {
            blur_speed.visible = true;
            blurOprate.visible = false;
        } else {
            blur_speed.visible = false;
            blurOprate.visible = true;
        }
    }

    states: [
        State {
            name: "NORMAL"
            when: (root.currentPlayMode == 'NORMAL')

            PropertyChanges {
                target: blur_speed
                source: "qrc:/assets/speed_background_normal.png"
            }
        },
        State {
            name: "COMFORT"
            when: (root.currentPlayMode == 'COMFORT')

            PropertyChanges {
                target: blur_speed
                source: "qrc:/assets/speed_background_comfort.png"
            }
        },
        State {
            name: "SPORT"
            when: (root.currentPlayMode == 'SPORT')

            PropertyChanges {
                target: blur_speed
                source: "qrc:/assets/speed_background_sport.png"
            }
        }
    ]

    Image {
        id: blur_speed
        width: 660
        height: 600
        source:"qrc:/assets/speed_background_normal.png"
        sourceSize.width: 660
        sourceSize.height: 600
    }

    FastBlur {
        id:blurOprate
        anchors.fill: blur_speed
        source: blur_speed
        radius: 60
        visible: false
    }

    /*金邊打光*/
    ValueMask {
        width: 660;height: 600
        speed: mainscreenRoot.speedValue
        maskSource: "qrc:/assets/speed_mask_line.png"
        source: "qrc:/assets/speed_light_line.png"
        sourceWidth: 78
        sourceHeight: 78
        pointPos: Qt.point(487,501)/*光圈起點pos*/
        posList: [
            {'value':0,'point':Qt.point(487,501)},
            {'value':60,'point':Qt.point(210,498)},
            {'value':120,'point':Qt.point(72,261)},
            {'value':240,'point':Qt.point(208,22)}
        ]
    }

    Item {
        anchors.fill: parent

        /*時速表*/
        SectorCanvas {
            id:speedCanvas
            width: 660;height: 600
            speed: mainscreenRoot.speedValue
            gradientColorList:[
                {'value':0,'color':"#31253F"},
                {'value':0.25,'color':"#94575E"},
                {'value':0.5,'color':"#F6BB6D"},
                {'value':0.75,'color':"#FFE68D"},
                {'value':1,'color':"#FFEFB7"}
            ]
            posList: [
                {'value':0,'x1':496,'y1':488,'x2':523,'y2':534},
                {'value':60,'x1':278,'y1':488,'x2':250,'y2':534},
                {'value':120,'x1':168,'y1':300,'x2':113,'y2':300},
                {'value':240,'x1':277,'y1':113,'x2':250,'y2':66}
            ]
            maskSource:"qrc:/assets/speed_bar_mask.png"
            scaleImgSource:"qrc:/assets/speed_scale.png"
            gradientStartPoint:Qt.point(496,488)
            scaleOpacityMaskVisible:true
        }

        /*時速表內圈柵欄*/
        SectorCanvas {
            width: 660;height: 600
            speed: mainscreenRoot.speedValue
            gradientColorList:[
                {'value':0,'color':"#0031253F"},
                {'value':0.25,'color':"#0031253F"},
                {'value':0.85,'color':"#BFF6BB6D"},
                {'value':1,'color':"#FFFFEFB7"}
            ]
            posList: [
                {'value':0,'x1':476,'y1':454,'x2':523,'y2':534},
                {'value':60,'x1':296,'y1':454,'x2':250,'y2':534},
                {'value':120,'x1':205,'y1':300,'x2':113,'y2':300},
                {'value':240,'x1':296,'y1':145,'x2':250,'y2':66}
            ]
            maskSource:"qrc:/assets/speed_line_mask.png"
            gradientStartPoint:Qt.point(476,454)
            scaleOpacityMaskVisible:false
        }

        /*時速表刻度值打光*/
        ValueMask {
            width: 660;height: 600
            speed: mainscreenRoot.speedValue
            maskSource: "qrc:/assets/speed_mask_value.png"
            source: "qrc:/assets/speed_light_value.png"
            sourceWidth: 360
            sourceHeight: 360
            pointPos: Qt.point(347,387)
            posList: [
                {'value':0,'point':Qt.point(347,387)},
                {'value':60,'point':Qt.point(53,387)},
                {'value':120,'point':Qt.point(-112,118)},
                {'value':240,'point':Qt.point(17,-114)}
            ]
        }

        /*時速表指針*/
        Item {
            width: 660;height:600
            Image {
                id: pointerMask
                anchors.fill: parent
                source: "qrc:/assets/speed_mask_light_front.png"
                visible: false
                sourceSize.width: 660
                sourceSize.height: 600
            }

            Item {
                id:pointerImg
                anchors.fill: parent
                visible: false
                TablePointer {
                    id:pointer
                    x:56;y:-30
                    width: 660;height:660
                    source: "qrc:/assets/speed_light_front.png"
                    initAngle: -120
                    speed: mainscreenRoot.speedValue
                    centerPos:Qt.point(386,300)
                    startPos:Qt.point(523,534)
                    endPos:Qt.point(523,534)
                    posList: [
                        {'value':0,'point':Qt.point(523,534)},
                        {'value':60,'point':Qt.point(250,534)},
                        {'value':120,'point':Qt.point(113,300)},
                        {'value':240,'point':Qt.point(250,66)}
                    ]
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

}
