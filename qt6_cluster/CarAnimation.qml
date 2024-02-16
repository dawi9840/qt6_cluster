import QtQuick 2.15

Item {
    id:root
    width: 1200;height:720
    anchors.horizontalCenter: parent.horizontalCenter
    visible: false
    property bool startAnimation: false
    property bool finished:false
    property var animateList: {
        'carin':{
            'source':"qrc:/car_in_view/car_in_view_",
            'imageNumber':0,
            'firstNum':0,
            'finalNum':21,
            'positive':true
        },
        'carout':{
            'source':"qrc:/car_out/car_out_",
            'imageNumber':0,
            'firstNum':0,
            'finalNum':15,
            'positive':true
        },
        'cartop':{
            'source':"qrc:/car_top_view/car_top_view_",
            'imageNumber':0,
            'firstNum':0,
            'finalNum':17,
            'positive':true
        },
        'cartopinverse':{
            'source':"qrc:/car_top_view/car_top_view_",
            'imageNumber':17,
            'firstNum':0,
            'finalNum':17,
            'positive':false
        }
    }
    property string targetStatus
    property string animateType:'carin'
    property var currentAnimate:animateList[animateType]
    property string imageSource: currentAnimate['source']
    property int imageNumber:currentAnimate['imageNumber']
    property int firstNumber:currentAnimate['firstNum']
    property int finalNumber:currentAnimate['finalNum']
    property bool positive:currentAnimate['positive']

    onTargetStatusChanged: {
        /*目標狀態改變時，檢查當前的animateType，確認下一個animateType該是什麼*/
        checkStatus();
    }

    onStartAnimationChanged: {
        if (startAnimation === true) {
            root.visible = true;
            imageAnimation.stop();
            imageAnimation.start();
            root.startAnimation = false;
        }
    }


    Image {
        id:carImage
        anchors.fill: parent
        source: root.imageSource + root.firstNumber + ".png"
        sourceSize.width: root.width
        sourceSize.height: root.height
    }

    onImageNumberChanged: {
        carImage.source = root.imageSource + root.imageNumber + ".png";
    }

    NumberAnimation {
        id:imageAnimation
        target: root
        property: "imageNumber"
        from: root.positive ? root.firstNumber:root.finalNumber
        to: root.positive ? root.finalNumber:root.firstNumber
        duration: (root.finalNumber - root.firstNumber)*33
        onRunningChanged: {
            if(!imageAnimation.running) {
                checkStatus();
            }
        }
    }

    function checkStatus(){
        if (root.targetStatus === "charge") {
            if (root.animateType === "carin" || root.animateType === "cartopinverse") {
                root.finished = true
            } else if (root.animateType === "carout") {
                root.animateType = "carin";
                root.startAnimation = true;
            } else if (root.animateType === "cartop") {
                root.animateType = "cartopinverse";
                root.startAnimation = true;
            } else {
                root.finished = true
            }
        } else if (root.targetStatus === "opendoor") {
            if (root.animateType === "carin" || root.animateType === "cartopinverse") {
                root.animateType = "cartop";
                root.startAnimation = true;
            } else if (root.animateType === "carout") {
                root.animateType = "carin";
                root.startAnimation = true;
            } else if (root.animateType === "cartop") {
                root.finished = true
            } else {
                root.finished = true
            }
        } else if (root.targetStatus === "changegear") {
            if (root.animateType === "cartop") {
                root.animateType = "cartopinverse";
                root.startAnimation = true;
            } else if (root.animateType === "carout") {
                root.animateType = "carin";
                root.startAnimation = true;
            } else {
                root.finished = true
            }
        } else {
            /*init status*/
            if (root.animateType === "carout") {
                root.animateType = "carin";
                root.startAnimation = true;
            } else if (root.animateType === "cartop") {
                root.animateType = "cartopinverse";
                root.startAnimation = true;
            } else {
                root.finished = true
            }
        }
    }


}
