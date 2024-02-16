import QtQuick 2.15

Item {
    id:root
    width: 1920;height: 1080 //720

    property bool showAllSignal: false/*顯示所有燈號*/ //true----------------------------

    property bool signTURN_L: false/*左轉燈信號*/
    property bool signTURN_R: false/*右轉燈信號*/
    property bool signSeatBelt: false/*安全帶信號*/
    property bool signACC: false /*ACC開關信號*/
    property bool signLDWOccur: false/*車道偏移信號*/
    property bool switchDoorOpen:false/*有車門開啟*/
    property bool signAirBagOff:false/*副駕駛安全氣囊關閉*/
    property int speedValue:0
    property string iconID:root.signalHeadLamp              // default
    property bool iconStatus:false

    property string signalHeadLamp:"Low_Beam_Light"         //Alan: "ZGW_RHeadLampPower_St";index:0
    property string signalHighBeam:"High_Beam_Light"        //Alan: "ZGW_RHighBeamPower_St";index:1
    property string signalTurnLeft:"Direction_Light_Left"   //Alan: "ZGW_LTurnSignal_St";index:3
    property string signalTurnRight:"Direction_Light_Right" //Alan: "ZGW_RTurnSignal_St";index:4
    property string signalFogLightFront:"Fog_Light_Front"   // dawi add;index:2
    property string signalFogLightRear:"Fog_Light_Rear"     // dawi add;index:5
    property string signalHAZARD:"Warning_Light_HAZARD"     // dawi add;index:6

    onIconIDChanged: {
        console.log("dawi_qml_onIconIDChanged");
        if (root.iconID === root.signalHeadLamp) {/*近光燈*/
            headlight.source = "qrc:/signalimg/Category=Lamp, Signal=Low Beam.png"
            headlight.visible = root.iconStatus;

            parkingLight.source = "qrc:/signalimg/Category=Lamp, Signal=Parking Light.png"
            parkingLight.visible = root.iconStatus;

            console.log("近光燈: " + root.iconStatus);

        } else if (root.iconID === root.signalHighBeam) {/*遠光燈*/
            headlight.source = "qrc:/signalimg/Category=Lamp, Signal=High Beam.png"
            headlight.visible = root.iconStatus;
            console.log("遠光燈: " + headlight.visible);

        } else if (root.iconID === root.signalTurnRight) {/*方向燈-右轉燈*/
            signal_right.hasSignal = root.iconStatus;
            console.log("方向燈-右轉燈: " + signal_right.hasSignal);

        } else if (root.iconID === root.signalTurnLeft) {/*方向燈-左轉燈*/
            signal_left.hasSignal = root.iconStatus;
            console.log("方向燈-左轉燈: " + signal_right.hasSignal);

        } else if (root.iconID === root.signalFogLightFront) {/*前霧燈*/
            fogLightFront.source = "qrc:/signalimg/Category=Lamp, Signal=Fog Light-Front.png"
            fogLightFront.visible = root.iconStatus;
            console.log("前霧燈: " + root.iconStatus);

        } else if (root.iconID === root.signalFogLightRear) {/*後霧燈*/
            fogLightRear.source ="qrc:/signalimg/Category=Lamp, Signal=Fog Light-Rear.png"
            fogLightRear.visible = root.iconStatus;
            console.log("後霧燈: " + root.iconStatus);

        } else if (root.iconID === root.signalHAZARD) {/*警示燈*/
            console.log("HAZARD: " + root.iconStatus);
            signal_left.hasSignal = root.iconStatus;
            signal_right.hasSignal = root.iconStatus;

        }
    }

    onIconStatusChanged: {
        console.log("dawi_qml_onIconStatusChanged");
        if (root.iconID === root.signalHeadLamp) {/*近光燈*/
            headlight.source = "qrc:/signalimg/Category=Lamp, Signal=Low Beam.png"
            parkingLight.source = "qrc:/signalimg/Category=Lamp, Signal=Parking Light.png"
            headlight.visible = root.iconStatus;
            parkingLight.visible = root.iconStatus;
            console.log("近光燈: " + root.iconStatus);

        } else if (root.iconID === root.signalHighBeam) {/*遠光燈*/
            headlight.source = "qrc:/signalimg/Category=Lamp, Signal=High Beam.png"
            headlight.visible = root.iconStatus;
            console.log("遠光燈: " + headlight.visible);

        } else if (root.iconID === root.signalTurnRight) {/*方向燈-右轉燈*/
            signal_right.hasSignal = root.iconStatus;
            console.log("方向燈-右轉燈: " + signal_right.hasSignal);

        } else if (root.iconID === root.signalTurnLeft) {/*方向燈-左轉燈*/
            signal_left.hasSignal = root.iconStatus;
            console.log("方向燈-左轉燈: " + signal_right.hasSignal);

        } else if (root.iconID === root.signalFogLightFront) {/*前霧燈*/
            fogLightFront.source = "qrc:/signalimg/Category=Lamp, Signal=Fog Light-Front.png"
            fogLightFront.visible = root.iconStatus;
            console.log("前霧燈: " + root.iconStatus);

        } else if (root.iconID === root.signalFogLightRear) {/*後霧燈*/
            fogLightRear.source = "qrc:/signalimg/Category=Lamp, Signal=Fog Light-Rear.png"
            fogLightRear.visible = root.iconStatus;
            console.log("後霧燈: " + root.iconStatus);

        } else if (root.iconID === root.signalHAZARD) {/*警示燈*/
            console.log("HAZARD: " + root.iconStatus);
            signal_left.hasSignal = root.iconStatus;
            signal_right.hasSignal = root.iconStatus;

        }
    }

    /*車燈區*/
    Image {
        width: 42;height: 42
        x:18;y:18
        source:"qrc:/signalimg/Category=Lamp, Signal=AFS-Alarm.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {
        id:parkingLight // dawi add
        width: 42;height: 42
        x:126;y:18
        source:"qrc:/signalimg/Category=Lamp, Signal=Parking Light.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {
        id:headlight
        width: 42;height: 42
        x:180;y:18
        source:"qrc:/signalimg/Category=Lamp, Signal=Low Beam.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {/*前霧燈*/
        id:fogLightFront // dawi add
        width: 42;height: 42
        x:234;y:18
        source:"qrc:/signalimg/Category=Lamp, Signal=Fog Light-Front.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {/*後霧燈*/
        id:fogLightRear // dawi add
        width: 42;height: 42
        x:288;y:18
        source:"qrc:/signalimg/Category=Lamp, Signal=Fog Light-Rear.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {
        width: 42;height: 42
        x:396;y:18
        source:"qrc:/signalimg/Category=Brake, Signal=Auto Hold.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    /*方向燈區*/
    SignalImage {
        id:signal_left
        x:678;y:18
        source:"qrc:/signalimg/Category=System, Signal=Turn Signal-Left.png"
        hasSignal: signTURN_L
    }

    SignalImage {
        id:signal_right
        x:1200;y:18
        source:"qrc:/signalimg/Category=System, Signal=Turn Signal-Right.png"
        hasSignal: signTURN_R
    }

    /*主要警示區*/
    Image {
        width: 42;height: 42
        x:18;y:1020 //660
        source:"qrc:/signalimg/Category=System, Signal=Wiper-Fluid.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {
        width: 63;height: 42
        x:72;y:1020 //660
        source:"qrc:/signalimg/Category=System, Signal=Wiper-Alarm.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 63
        sourceSize.height: 42
    }

    Image {
        width: 42;height: 42
        x:147;y:1020 //660
        source:"qrc:/signalimg/Category=System, Signal=Airbag-Off.png"
        visible: (showAllSignal || signAirBagOff) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {
        width: 42;height: 42
        x:201;y:1020 //660
        source:"qrc:/signalimg/Category=System, Signal=Airbag-Error.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {
        width: 63;height: 42
        x:255;y:1020 //660
        source:"qrc:/signalimg/Category=System, Signal=Air Suspension-Error.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 63
        sourceSize.height: 42
    }

    Image {
        width: 63;height: 42
        x:330;y:1020 //660
        source:"qrc:/signalimg/Category=System, Signal=EVS-Error.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 63
        sourceSize.height: 42
    }

    Image {
        width: 63;height: 42
        x:405;y:1020 //660
        source:"qrc:/signalimg/Category=System, Signal=Steering Wheel-Error.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 63
        sourceSize.height: 42
    }

    Image {
        width: 42;height: 42
        x:480;y:1020 //660
        source:"qrc:/signalimg/Category=System, Signal=TPMS.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {
        width: 42;height: 42
        x:534;y:1020 //660
        source:"qrc:/signalimg/Category=Brake, Signal=Park-Alarm.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {
        width: 42;height: 42
        x:588;y:1020 //660
        source:"qrc:/signalimg/Category=Brake, Signal=Brake-Error.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {
        width: 42;height: 42
        x:642;y:1020 //660
        source:"qrc:/signalimg/Category=Brake, Signal=ABS.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    /*ADAS燈號區*/
    Image {
        width: 42;height: 42
        x:712;y:1020 //660
        source:"qrc:/signalimg/Category=System, Signal=Seat Belt.png"
        visible: (showAllSignal || signSeatBelt) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {
        width: 42;height: 42
        x:766;y:1020 //660
        source:"qrc:/signalimg/Category=System, Signal=Doors.png"
        visible: (showAllSignal || switchDoorOpen) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {
        id:accsignal
        width: 42;height: 42
        x:820;y:1020 //660
        source:"qrc:/signalimg/Category=ADAS, Signal=ACC 3.png"
        visible: (showAllSignal || signACC) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Row {
        id:signalCruise
        x:874;y:1020 //660
        width: 150;height: 42
        spacing: 6
        visible: (showAllSignal || signACC) ? true:false
        Image {
            height: 42;width: 42
            source:"qrc:/signalimg/Category=ADAS, Signal=Cruise.png"
            sourceSize.width: 42
            sourceSize.height: 42
        }

        Text {
            id:txtSpeed
            width: 47;height: 42
            text: speedValue
            font.pixelSize: 30
            font.weight: Font.Normal
            color: "#21FF79"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            width: 49;height: 42
            text: "km/h"
            font.pixelSize: 22
            font.weight: Font.Normal
            color: "#21FF79"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Image {
        width: 42;height: 42
        x:1036;y:1020 //660
        source:"qrc:/signalimg/Category=ADAS, Signal=LDW.png"
        visible: (showAllSignal || signLDWOccur) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {
        width: 63;height: 42
        x:1090;y:1020 //660
        source:"qrc:/signalimg/Category=ADAS, Signal=Hands On-Error.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 63
        sourceSize.height: 42
    }

    Image {
        width: 42;height: 42
        x:1165;y:1020 //660
        source:"qrc:/signalimg/Category=ADAS, Signal=ESC-Alarm.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    /*次要警示區*/
    Image {
        width: 63;height: 42
        x:1275;y:1020 //660
        source:"qrc:/signalimg/signal_e_motor_error.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 63
        sourceSize.height: 42
    }

    Image {
        width: 42;height: 42
        x:1350;y:1020 //660
        source:"qrc:/signalimg/signal_thermal_error.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {
        width: 63;height: 42
        x:1434;y:1020 //660
        source:"qrc:/signalimg/Category=Battery, Signal=EVB-Temp.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 63
        sourceSize.height: 42
    }

    Image {
        width: 42;height: 42
        x:1509;y:1020 //660
        source:"qrc:/signalimg/Category=Battery, Signal=12V Battery-Error.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }

    Image {
        width: 63;height: 42
        x:1563;y:1020 //660
        source:"qrc:/signalimg/Category=Battery, Signal=EVB-Error.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 63
        sourceSize.height: 42
    }

    Image {
        width: 42;height: 42
        x:1638;y:1020 //660
        source:"qrc:/signalimg/Category=Battery, Signal=EVO.png"
        visible: (showAllSignal) ? true:false
        sourceSize.width: 42
        sourceSize.height: 42
    }
}
