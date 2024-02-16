import QtQuick 2.15

Item {
    Image {
        id: backgroundImg
        anchors.fill: parent
        source: "qrc:/assets/chargeMode.png"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
    }

    SpriteSequence {
        id:chargeSprite
        width: 300/*動畫展示寬度*/
        height: 300/*動畫展示高度*/
        x:980;y:240
        goalSprite: "" //目標動畫


        Sprite{
            name: "falling"
            source: "qrc:/assets/ChargeAnimation.png"
            frameCount: 36
            frameWidth: 300
            frameHeight: 300
            frameDuration: 40
        }
    }
}
