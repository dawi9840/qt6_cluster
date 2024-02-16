

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick3D 1.15
import UntitledProject 1.0
import Quick3DAssets.NPC_car 1.0
import Quick3DAssets.Cx7 1.0
import QtQuick.Timeline 1.0
import Quick3DAssets.Wheel 1.0
import Quick3DAssets.NPC_truck 1.0
import QtQuick3D.Materials 1.14
import QtQuick3D.Materials 1.15

Rectangle {
    id: rectangle
    width: 732
    height: 342
    opacity: 1
    color: "#00ffffff"
    border.color: "#7d7d7d"

    View3D {
        id: view3D
        anchors.fill: parent
        layer.format: ShaderEffectSource.RGB
        layer.enabled: false
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        environment: sceneEnvironment

        SceneEnvironment {
            id: sceneEnvironment
            depthPrePassEnabled: true
            aoBias: 36
            aoSampleRate: 4
            aoDistance: 11
            aoStrength: 6
            aoDither: true
            clearColor: "#00000000"
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.Medium
        }

        Node {
            id: scene
            DirectionalLight {
                id: directionalLight
                x: 36.787
                y: 1675.723
                shadowMapFar: 5500
                shadowBias: 0
                ambientColor: "#000000"
                brightness: 97
                shadowFilter: 10
                shadowFactor: 63
                castsShadow: true
                eulerRotation.z: 0.61096
                eulerRotation.y: 1.21702
                eulerRotation.x: -51.6889
                z: 1051.35352
            }

            PerspectiveCamera {
                id: sceneCamera
                x: 0
                y: 629.521
                eulerRotation.z: -0.00011
                eulerRotation.y: 0.00011
                eulerRotation.x: -86.52014
                z: 16.20546
            }

            Model {
                id: acc_alarm
                x: -0
                y: 2
                opacity: 0.6
                source: "#Rectangle"
                isWireframeMode: false
                eulerRotation.y: 0.00008
                scale.z: 4.14006
                scale.y: 4.45121
                materials: rectMaterial6
                eulerRotation.z: -0.00009
                eulerRotation.x: -90
                z: -385.3363
                scale.x: 2.4058
            }

            Node {
                id: car

                Cx7 {
                    id: cx7
                    x: 0
                    y: -0
                    z: -0.00004
                    scale.z: 7.42613
                    scale.y: 7.42613
                    scale.x: 7.42613
                }
            }

            Node {
                id: group

                NPC_car {
                    id: nPC_car
                    x: -100.853
                    y: 15
                    z: -36.42113
                }

                NPC_truck {
                    id: nPC_truck
                    x: -149.293
                    y: 15
                    z: -1241.52393
                }

                NPC_car {
                    id: nPC_car1
                    x: 384.016
                    y: 15
                    z: -1332.94409
                }

                TextureInput {
                    id: textureInput
                    texture: npc
                }

                Texture {
                    id: npc
                    source: "images/npc.jpg"
                }
            }

            Node {
                id: road
                z: 0

                Model {
                    id: road_c
                    x: -0
                    y: -0.1
                    source: "#Rectangle"
                    z: -5000
                    eulerRotation.y: 0.00008
                    scale.z: 4.14006
                    scale.y: 116.57091
                    materials: road_material
                    eulerRotation.z: -0.00009
                    eulerRotation.x: -90
                    scale.x: 2.4058
                }

                Model {
                    id: road_l
                    x: -249.086
                    y: -0.1
                    source: "#Rectangle"
                    eulerRotation.y: 0.00008
                    scale.y: 116.57091
                    scale.z: 4.14006
                    materials: road_material
                    eulerRotation.x: -90
                    eulerRotation.z: -0.00009
                    z: -5000
                    scale.x: 2.4058
                }

                Model {
                    id: road_r
                    x: 249.587
                    y: -0.1
                    source: "#Rectangle"
                    eulerRotation.y: 0.00008
                    scale.z: 4.14006
                    scale.y: 116.57091
                    materials: road_material
                    eulerRotation.z: -0.00009
                    eulerRotation.x: -90
                    z: -5000
                    scale.x: 2.4058
                }

                Model {
                    id: speed_01
                    x: 249.587
                    y: -0
                    source: "#Rectangle"
                    materials: speed_material
                    isWireframeMode: false
                    receivesShadows: true
                    pickable: true
                    castsShadows: false
                    eulerRotation.y: 0.00008
                    scale.y: 116.57091
                    scale.z: 4.14006
                    eulerRotation.x: -90
                    eulerRotation.z: -0.00009
                    z: -5000
                    scale.x: 2.4058
                }

                Model {
                    id: speed_02
                    source: "#Rectangle"
                    materials: speed_material
                    isWireframeMode: false
                    receivesShadows: true
                    pickable: true
                    castsShadows: false
                    z: -5000
                    eulerRotation.z: -0.00009
                    eulerRotation.y: 0.00008
                    eulerRotation.x: -90
                    scale.z: 4.14006
                    scale.y: 116.57091
                    scale.x: 2.4058
                }

                Model {
                    id: speed_03
                    x: -249.086
                    y: 0
                    source: "#Rectangle"
                    materials: speed_material
                    isWireframeMode: false
                    pickable: true
                    receivesShadows: true
                    castsShadows: false
                    z: -5000
                    eulerRotation.y: 0.00008
                    scale.z: 4.14006
                    scale.y: 116.57091
                    eulerRotation.z: -0.00009
                    eulerRotation.x: -90
                    scale.x: 2.4058
                }

                TextureInput {
                    id: speed_textureI
                    texture: line_glow1
                }

                Texture {
                    id: line_glow1
                    source: "images/line_glow.png"
                    scaleV: 3
                    positionV: 0.26
                    tilingModeVertical: Texture.Repeat
                }

                Model {
                    id: line_L
                    x: -123
                    y: 1
                    source: "#Rectangle"
                    castsShadows: false
                    eulerRotation.y: 0.00008
                    scale.y: 116.57091
                    scale.z: 4.14006
                    materials: line_alarm_L
                    eulerRotation.x: -90
                    eulerRotation.z: -0.00009
                    z: -5000
                    scale.x: 0.09269
                }

                Model {
                    id: line_R
                    x: 123
                    y: 1
                    opacity: 1
                    source: "#Rectangle"
                    castsShadows: false
                    eulerRotation.y: 0.00008
                    scale.z: 4.14006
                    scale.y: 116.57091
                    materials: line_alarm_R
                    eulerRotation.z: -0.00009
                    eulerRotation.x: -90
                    z: -5000
                    scale.x: 0.09269
                }

                Model {
                    id: line_R1
                    x: 123
                    y: 1.5
                    opacity: 1
                    source: "#Rectangle"
                    castsShadows: false
                    eulerRotation.y: 0.00008
                    scale.y: 116.57091
                    scale.z: 4.14006
                    materials: line_alarm_R1
                    eulerRotation.x: -90
                    eulerRotation.z: -0.00009
                    z: -5000
                    scale.x: 0.09269
                }
            }

            AreaLight {
                id: lightArea
                x: 1169.522
                y: 1034.998
                width: 1453
                height: 1438
                shadowBias: 0.6
                shadowMapQuality: Light.ShadowMapQualityVeryHigh
                shadowFilter: 100
                shadowFactor: 17
                castsShadow: true
                eulerRotation.z: -138.96567
                eulerRotation.y: 128.68666
                eulerRotation.x: -44.18213
                brightness: 427
                z: -1599.25793
            }
        }
    }

    Timeline {
        id: timeline
        animations: [
            TimelineAnimation {
                id: timelineAnimation
                loops: 1
                duration: 1000
                running: true
                to: 1000
                from: 0
            }
        ]
        endFrame: 7200
        enabled: true
        startFrame: 0

        KeyframeGroup {
            target: sceneCamera
            property: "x"
            Keyframe {
                easing.bezierCurve: [0.39, 0.575, 0.565, 1, 1, 1]
                value: 0.0001
                frame: 8002
            }

            Keyframe {
                easing.bezierCurve: [0.55, 0.085, 0.68, 0.53, 1, 1]
                value: -0.00002
                frame: 7340
            }

            Keyframe {
                easing.bezierCurve: [0.55, 0.085, 0.68, 0.53, 1, 1]
                frame: 0
                value: -0.00002
            }
        }

        KeyframeGroup {
            target: sceneCamera
            property: "y"
            Keyframe {
                easing.bezierCurve: [0.39, 0.575, 0.565, 1, 1, 1]
                value: 718.27789
                frame: 8002
            }

            Keyframe {
                easing.bezierCurve: [0.55, 0.085, 0.68, 0.53, 1, 1]
                value: 351.57684
                frame: 7340
            }

            Keyframe {
                easing.bezierCurve: [0.55, 0.085, 0.68, 0.53, 1, 1]
                frame: 0
                value: 351.57684
            }
        }

        KeyframeGroup {
            target: sceneCamera
            property: "z"
            Keyframe {
                easing.bezierCurve: [0.39, 0.575, 0.565, 1, 1, 1]
                value: 34.8741
                frame: 8002
            }

            Keyframe {
                easing.bezierCurve: [0.55, 0.085, 0.68, 0.53, 1, 1]
                value: 494.79205
                frame: 7340
            }

            Keyframe {
                easing.bezierCurve: [0.55, 0.085, 0.68, 0.53, 1, 1]
                frame: 0
                value: 494.79205
            }
        }

        KeyframeGroup {
            target: sceneCamera
            property: "eulerRotation.x"
            Keyframe {
                easing.bezierCurve: [0.39, 0.575, 0.565, 1, 1, 1]
                value: -86.24557
                frame: 8002
            }

            Keyframe {
                easing.bezierCurve: [0.55, 0.085, 0.68, 0.53, 1, 1]
                value: -24.6931
                frame: 7340
            }

            Keyframe {
                easing.bezierCurve: [0.55, 0.085, 0.68, 0.53, 1, 1]
                frame: 0
                value: -24.6931
            }
        }

        KeyframeGroup {
            target: sceneCamera
            property: "eulerRotation.y"
            Keyframe {
                easing.bezierCurve: [0.39, 0.575, 0.565, 1, 1, 1]
                value: 0.00011
                frame: 8002
            }

            Keyframe {
                easing.bezierCurve: [0.55, 0.085, 0.68, 0.53, 1, 1]
                value: 0.00002
                frame: 7340
            }

            Keyframe {
                easing.bezierCurve: [0.55, 0.085, 0.68, 0.53, 1, 1]
                frame: 0
                value: 0.00002
            }
        }

        KeyframeGroup {
            target: sceneCamera
            property: "eulerRotation.z"

            Keyframe {
                easing.bezierCurve: [0.39, 0.575, 0.565, 1, 1, 1]
                value: -0.00011
                frame: 8002
            }

            Keyframe {
                easing.bezierCurve: [0.55, 0.085, 0.68, 0.53, 1, 1]
                value: -0.00003
                frame: 7340
            }

            Keyframe {
                easing.bezierCurve: [0.55, 0.085, 0.68, 0.53, 1, 1]
                frame: 0
                value: -0.00003
            }
        }

        KeyframeGroup {
            target: speed_02
            property: "opacity"
            Keyframe {
                value: 1
                frame: 7340
            }

            Keyframe {
                value: 0
                frame: 7544
            }
        }

        KeyframeGroup {
            target: nPC_car
            property: "opacity"
            Keyframe {
                value: 1
                frame: 7350
            }

            Keyframe {
                value: 0
                frame: 7486
            }
        }

        KeyframeGroup {
            target: nPC_car
            property: "z"

            Keyframe {
                value: -404.59778
                frame: 745
            }

            Keyframe {
                frame: 7213
                value: -145.75067
            }

            Keyframe {
                frame: 2257
                value: -404.59778
            }

            Keyframe {
                frame: 0
                value: -145.75067
            }

            Keyframe {
                frame: 1509
                value: -523.91663
            }

            Keyframe {
                frame: 4984
                value: -348.76553
            }
        }

        KeyframeGroup {
            target: nPC_car1
            property: "z"
            Keyframe {
                frame: 7223
                value: -816.79688
            }

            Keyframe {
                frame: 0
                value: -816.79688
            }

            Keyframe {
                easing.bezierCurve: [0.445, 0.05, 0.55, 0.95, 1, 1]
                frame: 705
                value: -930.24402
            }

            Keyframe {
                frame: 2811
                value: -792.48889
            }

            Keyframe {
                frame: 5150
                value: -891.35266
            }
        }

        KeyframeGroup {
            target: nPC_truck
            property: "z"
            Keyframe {
                frame: 307
                value: -1221.71301
            }

            Keyframe {
                easing.bezierCurve: [0.39, 0.575, 0.565, 1, 1, 1]
                frame: 750
                value: -1003.57507
            }

            Keyframe {
                easing.bezierCurve: [0.47, 0, 0.745, 0.715, 1, 1]
                frame: 1474
                value: -975.84015
            }

            Keyframe {
                frame: 0
                value: -1221.71301
            }

            Keyframe {
                frame: 2385
                value: -1221.71301
            }

            Keyframe {
                frame: 5539
                value: -1343.61401
            }

            Keyframe {
                frame: 7213
                value: -1221.71301
            }
        }

        KeyframeGroup {
            target: nPC_car1
            property: "opacity"
            Keyframe {
                frame: 7339
                value: 1
            }

            Keyframe {
                frame: 7486
                value: 0
            }
        }

        KeyframeGroup {
            target: nPC_truck
            property: "opacity"
            Keyframe {
                frame: 7340
                value: 1
            }

            Keyframe {
                frame: 7515
                value: 0
            }
        }

        KeyframeGroup {
            target: speed_03
            property: "opacity"
            Keyframe {
                frame: 7340
                value: 1
            }

            Keyframe {
                frame: 7535
                value: 0
            }
        }

        KeyframeGroup {
            target: speed_01
            property: "opacity"
            Keyframe {
                frame: 7535
                value: 0
            }

            Keyframe {
                frame: 7340
                value: 1
            }
        }

        KeyframeGroup {
            target: line_glow1
            property: "positionV"
            Keyframe {
                frame: 0
                value: 0
            }

            Keyframe {
                frame: 7340
                value: 2
            }

            Keyframe {
                frame: 2872
                value: 0.78
            }
        }

        KeyframeGroup {
            target: acc_alarm
            property: "opacity"
            Keyframe {
                frame: 745
                value: 0
            }

            Keyframe {
                frame: 805
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }

            Keyframe {
                frame: 1482
                value: 0.6
            }

            Keyframe {
                frame: 1589
                value: 0
            }
        }

        KeyframeGroup {
            target: cx7
            property: "x"
            Keyframe {
                frame: 3933
                value: 0
            }

            Keyframe {
                easing.bezierCurve: [0.445, 0.05, 0.55, 0.95, 1, 1]
                frame: 4225
                value: 26
            }

            Keyframe {
                easing.bezierCurve: [0.445, 0.05, 0.55, 0.95, 1, 1]
                frame: 4303
                value: 30
            }

            Keyframe {
                easing.bezierCurve: [0.445, 0.05, 0.55, 0.95, 1, 1]
                frame: 4556
                value: 0
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: cx7
            property: "eulerRotation.y"
            Keyframe {
                frame: 3933
                value: 0
            }

            Keyframe {
                easing.bezierCurve: [0.445, 0.05, 0.55, 0.95, 1, 1]
                frame: 4225
                value: -4
            }

            Keyframe {
                easing.bezierCurve: [0.445, 0.05, 0.55, 0.95, 1, 1]
                frame: 4303
                value: -1
            }

            Keyframe {
                easing.bezierCurve: [0.445, 0.05, 0.55, 0.95, 1, 1]
                frame: 4437
                value: 3
            }

            Keyframe {
                easing.bezierCurve: [0.445, 0.05, 0.55, 0.95, 1, 1]
                frame: 4556
                value: 0
            }
        }

        KeyframeGroup {
            target: line_R1
            property: "opacity"
            Keyframe {
                frame: 3960
                value: 0
            }

            Keyframe {
                frame: 4180
                value: 1
            }

            Keyframe {
                frame: 4521
                value: 0
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: line_R
            property: "opacity"
            Keyframe {
                frame: 3960
                value: 1
            }

            Keyframe {
                frame: 4231
                value: 0
            }

            Keyframe {
                frame: 4284
                value: 0
            }

            Keyframe {
                frame: 4521
                value: 1
            }
        }
    }

    Item {
        id: __materialLibrary__
        DefaultMaterial {
            id: rectMaterial6
            opacity: 1
            diffuseColor: "#ebff1d1d"
            cullMode: Material.NoCulling
            translucencyMap: line_glow1
            translucentFalloff: 2
            specularAmount: 0.6
            specularTint: "#ebff5151"
            vertexColorsEnabled: false
            emissiveColor: "#ff7474"
            objectName: "rectMaterial6"
        }

        DefaultMaterial {
            id: car_material
            diffuseColor: "#1facf0"
            objectName: "car_material"
            cullMode: Material.BackFaceCulling
            specularAmount: 0.2
        }

        DefaultMaterial {
            id: road_material
            diffuseColor: "#8da1b3"
            objectName: "road_material"
            cullMode: Material.BackFaceCulling
            specularAmount: 0
            specularTint: "#535353"
        }

        DefaultMaterial {
            id: speed_material
            diffuseColor: "#ffffff"
            objectName: "speed_material"
            cullMode: Material.BackFaceCulling
            specularAmount: 0.2
            diffuseMap: line_glow1
        }

        DefaultMaterial {
            id: line_alarm_R
            emissiveColor: "#ffffff"
            objectName: "line_alarm_R"
            cullMode: Material.BackFaceCulling
            specularAmount: 0
            diffuseColor: "#20e620"
        }

        DefaultMaterial {
            id: line_alarm_L
            diffuseColor: "#20e620"
            objectName: "line_alarm_L"
            cullMode: Material.BackFaceCulling
            emissiveColor: "#ffffff"
        }

        DefaultMaterial {
            id: line_alarm_R1
            diffuseColor: "#f7ff6100"
            blendMode: DefaultMaterial.SourceOver
            cullMode: Material.BackFaceCulling
            lighting: DefaultMaterial.NoLighting
            specularAmount: 1
            vertexColorsEnabled: false
            objectName: "line_alarm_R1"
            emissiveColor: "#ff6400"
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}D{i:34;invisible:true}D{i:38;invisible:true}D{i:43;property:"x";target:"sceneCamera"}
D{i:47;property:"y";target:"sceneCamera"}D{i:51;property:"z";target:"sceneCamera"}
D{i:55;property:"eulerRotation.x";target:"sceneCamera"}D{i:59;property:"eulerRotation.y";target:"sceneCamera"}
D{i:63;property:"eulerRotation.z";target:"sceneCamera"}D{i:69;property:"opacity";target:"nPC_car"}
D{i:70;property:"opacity";target:"nPC_car"}D{i:72;property:"z";target:"nPC_car"}D{i:75;property:"z";target:"nPC_car"}
D{i:80;property:"z";target:"nPC_car1"}D{i:85;property:"z";target:"nPC_truck"}D{i:86;property:"z";target:"nPC_truck"}
D{i:88;property:"z";target:"nPC_truck"}D{i:110;property:"opacity";target:"acc"}D{i:39}
}
##^##*/

