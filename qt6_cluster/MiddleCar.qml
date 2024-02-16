import QtQuick 2.15

Item {
    id: root
    width: 500
    height: 600
    property string carBodyImage:"qrc:/open_close/body.png"
    property string engineImage:"qrc:/open_close/engine/engine_"/*引擎蓋*/
    property string lbDoorImage:"qrc:/open_close/lb_door/lb_door_"/*第二排左側車門*/
    property string lfDoorImage:"qrc:/open_close/lf_door/lf_door_"/*駕駛座車門*/
    property string rfDoorImage:"qrc:/open_close/rf_door/rf_door_"/*副駕駛座車門*/
    property string rbDoorImage:"qrc:/open_close/rb_door/rb_door_"/*第二排右側車門*/
    property string trunkImage:"qrc:/open_close/trunk/trunk_"/*尾門*/

    property bool switchDoor_FL: false
    property bool switchDoor_FR: false
    property bool switchDoor_RL: false
    property bool switchDoor_RR: false
    property bool switchEngine: false
    property bool switchTrunk: false
    property bool backInitCarType: false

    Image {
        id: carBody
        width: parent.width;height:parent.height
        source: root.carBodyImage
        sourceSize.width: parent.width
        sourceSize.height: parent.height
    }

    CarAnimation {
        id:engineAnimate
        width: parent.width;height:parent.height
        visible: true
        currentAnimate: {
            'source':root.engineImage,
            'imageNumber':0,
            'firstNum':0,
            'finalNum':20,
            'positive':true
        }
    }

    CarAnimation {
        id:lfDoorAnimate
        width: parent.width;height:parent.height
        visible: true
        currentAnimate: {
            'source':root.lfDoorImage,
            'imageNumber':0,
            'firstNum':0,
            'finalNum':20,
            'positive':true
        }
    }

    CarAnimation {
        id:lbDoorAnimate
        width: parent.width;height:parent.height
        visible: true
        currentAnimate: {
            'source':root.lbDoorImage,
            'imageNumber':0,
            'firstNum':0,
            'finalNum':20,
            'positive':true
        }
    }

    CarAnimation {
        id:rfDoorAnimate
        width: parent.width;height:parent.height
        visible: true
        currentAnimate: {
            'source':root.rfDoorImage,
            'imageNumber':0,
            'firstNum':0,
            'finalNum':20,
            'positive':true
        }
    }

    CarAnimation {
        id:rbDoorAnimate
        width: parent.width;height:parent.height
        visible: true
        currentAnimate: {
            'source':root.rbDoorImage,
            'imageNumber':0,
            'firstNum':0,
            'finalNum':20,
            'positive':true
        }
    }

    CarAnimation {
        id:trunkAnimate
        width: parent.width;height:parent.height
        visible: true
        currentAnimate: {
            'source':root.trunkImage,
            'imageNumber':0,
            'firstNum':0,
            'finalNum':20,
            'positive':true
        }
    }

    onSwitchDoor_FLChanged: {
        if (switchDoor_FL) {
            lfDoorAnimate.positive = true
            lfDoorAnimate.startAnimation = true
        } else {
            lfDoorAnimate.positive = false
            lfDoorAnimate.startAnimation = true
        }
        startCountdown();
    }

    onSwitchDoor_FRChanged: {
        if (switchDoor_FR) {
            rfDoorAnimate.positive = true
            rfDoorAnimate.startAnimation = true
        } else {
            rfDoorAnimate.positive = false
            rfDoorAnimate.startAnimation = true
        }
        startCountdown();
    }

    onSwitchDoor_RLChanged: {
        if (switchDoor_RL) {
            lbDoorAnimate.positive = true
            lbDoorAnimate.startAnimation = true
        } else {
            lbDoorAnimate.positive = false
            lbDoorAnimate.startAnimation = true
        }
        startCountdown();
    }

    onSwitchDoor_RRChanged: {
        if (switchDoor_RR) {
            rbDoorAnimate.positive = true
            rbDoorAnimate.startAnimation = true
        } else {
            rbDoorAnimate.positive = false
            rbDoorAnimate.startAnimation = true
        }
        startCountdown();
    }

    onSwitchTrunkChanged: {
        if (switchTrunk) {
            trunkAnimate.positive = true
            trunkAnimate.startAnimation = true
        } else {
            trunkAnimate.positive = false
            trunkAnimate.startAnimation = true
        }
        startCountdown();
    }

    onSwitchEngineChanged: {
        if (switchEngine) {
            engineAnimate.positive = true
            engineAnimate.startAnimation = true
        } else {
            engineAnimate.positive = false
            engineAnimate.startAnimation = true
        }
        startCountdown();
    }

    Timer {
        id:middleCarTimer
        interval: 10000; running: false; repeat: false;
        onTriggered: {
            backInitCarType = true;
        }
    }

//    property bool switchDoor_FL: false
//    property bool switchDoor_FR: false
//    property bool switchDoor_RL: false
//    property bool switchDoor_RR: false
//    property bool switchEngine: false
//    property bool switchTrunk: false

    function startCountdown() {
        middleCarTimer.stop();
        if(!switchDoor_FL && !switchDoor_FR && !switchDoor_RL
            && !switchDoor_RR && !switchEngine && !switchTrunk){
            middleCarTimer.start();
        }
    }
}
