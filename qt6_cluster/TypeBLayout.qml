import QtQuick 2.15
import Qt5Compat.GraphicalEffects
//import QtGraphicalEffects 1.15

Item {
    id: root
    width: 1800;height: 600
//    property alias num_0Text: num_0.text
//    property alias num_240Text: num_240.text
    property int speedValue: 60
    property int chargeValue:0
    property int lostKwh:0
    property real scaleValue: 0.02
    property int powerValue: lostKwh-chargeValue

    property bool switchNaviNext: true
    property real nextRoadDistance: 20 //下一個路口距離
    property string nextRoadName: "Zhongxiao E Rd"//下一個路口名字


    property var displayModeList /*由main指定含有的playMode*/
    property string currentPlayMode /*當前指定的playMode*/

    property bool switchBackgroundAnimate: true
    property string startColor:"#F8B171"
    property string endColor:"#FFDCB0"

    property var modeContentList: {
        'NORMAL':{
            'light_1':"#7FFFFFFF",
            'pattern':"qrc:/assets/pattern_b_normal.png",
            'pattern_blur':"qrc:/assets/pattern_power_normal.png",
            'pattern_blur_charge':"qrc:/assets/pattern_charge_normal.png",
            'light_left':"qrc:/assets/light_left_power_normal.png",
            'light_left_charge':"qrc:/assets/light_left_charge_normal.png",
            'light_right':"qrc:/assets/light_right_power_normal.png",
            'light_right_charge':"qrc:/assets/light_right_charge_normal.png",
            'light_updown':"qrc:/assets/light_up_down_power_normal.png",
            'light_updown_charge':"qrc:/assets/light_up_down_charge_normal.png",
            'pattern_point':"qrc:/assets/point_power_normal.png",
            'pattern_point_charge':"qrc:/assets/point_charge_normal.png",
        },
        'COMFORT':{
            'light_1':"#05C397",
            'pattern':"qrc:/assets/pattern_b_comfort.png",
            'pattern_blur':"qrc:/assets/pattern_power_comfort.png",
            'pattern_blur_charge':"qrc:/assets/pattern_charge_comfort.png",
            'light_left':"qrc:/assets/light_left_power_comfort.png",
            'light_left_charge':"qrc:/assets/light_left_charge_comfort.png",
            'light_right':"qrc:/assets/light_right_power_comfort.png",
            'light_right_charge':"qrc:/assets/light_right_charge_comfort.png",
            'light_updown':"qrc:/assets/light_up_down_power_comfort.png",
            'light_updown_charge':"qrc:/assets/light_up_down_charge_comfort.png",
            'pattern_point':"qrc:/assets/point_power_comfort.png",
            'pattern_point_charge':"qrc:/assets/point_charge_comfort.png",
        },
        'SPORT':{
            'light_1':"#F8B171",
            'pattern':"qrc:/assets/pattern_b_sport.png",
            'pattern_blur':"qrc:/assets/pattern_power_sport.png",
            'pattern_blur_charge':"qrc:/assets/pattern_charge_sport.png",
            'light_left':"qrc:/assets/light_left_power_sport.png",
            'light_left_charge':"qrc:/assets/light_left_charge_sport.png",
            'light_right':"qrc:/assets/light_right_power_sport.png",
            'light_right_charge':"qrc:/assets/light_right_charge_sport.png",
            'light_updown':"qrc:/assets/light_up_down_power_sport.png",
            'light_updown_charge':"qrc:/assets/light_up_down_charge_sport.png",
            'pattern_point':"qrc:/assets/point_power_sport.png",
            'pattern_point_charge':"qrc:/assets/point_charge_sport.png",
        }
    }

    property var currentModeContent: modeContentList[currentPlayMode]

    property var powerAnimationParameters: {
        'powerStep':100,
        'chargeStep':100,
        'main':{
            'maxScale':1.55,
            'indexZeroScale':0.835,
            'minScale':0.51,
            'powerFadeOut':1.0,
            'powerTransparent':0.672,
            'chargeFadeOut':0.672,
            'chargeTransparent':0.835
        },
        'light_left_right':{
            'minX_left':510,
            'indexZero_left':318,
            'maxX_left':-60,
            'minX_right':900,
            'indexZero_right':1092,
            'maxX_right':1470,
            'powerFadeOut_left':230,
            'powerTransparent_left':390,
            'chargeFadeOut_left':390,
            'chargeTransparent_left':318,
            'powerFadeOut_right':1180,
            'powerTransparent_right':1020,
            'chargeFadeOut_right':1020,
            'chargeTransparent_right':1092
        },
        'light_up_down':{
            'maxScale':1.0,
            'indexZeroScale':0.708333333,
            'minScale':0.5,
            'powerFadeOut':0.833333333,
            'powerTransparent':0.583333333,
            'chargeFadeOut':0.583333333,
            'chargeTransparent':0.708333333
        },
        'value_bar':{
            'maxX':388,
            'indexZeroX':102,
            'minX':-51,
            'maxY':113,
            'indexZeroY':-13,
            'minY':-65,
        }
    }
    property var powerData: {
        'main':{
            'power':(powerAnimationParameters['main']['maxScale']-powerAnimationParameters['main']['indexZeroScale'])/powerAnimationParameters['powerStep']*powerValue+powerAnimationParameters['main']['indexZeroScale'],
            'charge':(powerAnimationParameters['main']['indexZeroScale']-powerAnimationParameters['main']['minScale'])/powerAnimationParameters['chargeStep']*powerValue+powerAnimationParameters['main']['indexZeroScale']
        },
        'light_left_right':{
            'left_power':(powerAnimationParameters['light_left_right']['maxX_left']-powerAnimationParameters['light_left_right']['indexZero_left'])/powerAnimationParameters['powerStep']*powerValue+powerAnimationParameters['light_left_right']['indexZero_left'],
            'left_charge':(powerAnimationParameters['light_left_right']['indexZero_left']-powerAnimationParameters['light_left_right']['minX_left'])/powerAnimationParameters['chargeStep']*powerValue+powerAnimationParameters['light_left_right']['indexZero_left'],
            'right_power':(powerAnimationParameters['light_left_right']['maxX_right']-powerAnimationParameters['light_left_right']['indexZero_right'])/powerAnimationParameters['powerStep']*powerValue+powerAnimationParameters['light_left_right']['indexZero_right'],
            'right_charge':(powerAnimationParameters['light_left_right']['indexZero_right']-powerAnimationParameters['light_left_right']['minX_right'])/powerAnimationParameters['chargeStep']*powerValue+powerAnimationParameters['light_left_right']['indexZero_right']
        },
        'light_up_down':{
            'power':(powerAnimationParameters['light_up_down']['maxScale']-powerAnimationParameters['light_up_down']['indexZeroScale'])/powerAnimationParameters['powerStep']*powerValue+powerAnimationParameters['light_up_down']['indexZeroScale'],
            'charge':(powerAnimationParameters['light_up_down']['indexZeroScale']-powerAnimationParameters['light_up_down']['minScale'])/powerAnimationParameters['chargeStep']*powerValue+powerAnimationParameters['light_up_down']['indexZeroScale']
        },
        'value_bar':{
            'powerX':(powerAnimationParameters['value_bar']['maxX']-powerAnimationParameters['value_bar']['indexZeroX'])/powerAnimationParameters['powerStep']*powerValue+powerAnimationParameters['value_bar']['indexZeroX'],
            'chargeX':(powerAnimationParameters['value_bar']['indexZeroX']-powerAnimationParameters['value_bar']['minX'])/powerAnimationParameters['chargeStep']*powerValue+powerAnimationParameters['value_bar']['indexZeroX'],
            'powerY':(powerAnimationParameters['value_bar']['maxY']-powerAnimationParameters['value_bar']['indexZeroY'])/powerAnimationParameters['powerStep']*powerValue+powerAnimationParameters['value_bar']['indexZeroY'],
            'chargeY':(powerAnimationParameters['value_bar']['indexZeroY']-powerAnimationParameters['value_bar']['minY'])/powerAnimationParameters['chargeStep']*powerValue+powerAnimationParameters['value_bar']['indexZeroY']
        }
    }

    property real mainScaleValue: (powerValue >0)?powerData['main']['power']:powerData['main']['charge']
    property real lightLeftValue: (powerValue >0)?powerData['light_left_right']['left_power']:powerData['light_left_right']['left_charge']
    property real lightRightValue: (powerValue >0)?powerData['light_left_right']['right_power']:powerData['light_left_right']['right_charge']
    property real lightUpDownScaleValue: (powerValue >0)?powerData['light_up_down']['power']:powerData['light_up_down']['charge']
    property real valueBarXValue: (powerValue >0)?powerData['value_bar']['powerX']:powerData['value_bar']['chargeX']
    property real valueBarYValue: (powerValue >0)?powerData['value_bar']['powerY']:powerData['value_bar']['chargeY']

    function calculateOpc(data,slope,b){
        //var result = data*3.040003-6.0;//data*12.159976-23.99995;

        data = slope*data+b
        if(data > 1)
            return 1;
        else if(data < 0)
            return 0;
        else
            return data;
    }

    /* 背景 */
    Image {
        id:backgroundImage
        width: 1800;height: 600
        source: currentModeContent['pattern']
        visible: true
        sourceSize.width: 1800
        sourceSize.height: 600
    }

    /* 左右充電光暈 (綠色) */
    OpacityMask {
        id:light_rightCharge
        width: 1800;height: 600
        anchors.centerIn: parent
        source: sourceImg_rightCharge;maskSource: maskImg
    }

    OpacityMask {
        id:light_leftCharge
        width: 1800;height: 600
        anchors.centerIn: parent
        source: sourceImg_leftCharge;maskSource: maskImg
    }

    /* 左右放電光暈 (金色) */
    OpacityMask {
        id:light_rightPower
        width: 1800;height: 600
        anchors.centerIn: parent
        source: sourceImg_rightPower;maskSource: maskImg
    }

    OpacityMask {
        id:light_leftPower
        width: 1800;height: 600
        anchors.centerIn: parent
        source: sourceImg_leftPower;maskSource: maskImg
    }

    // 上下放電光條 (金色)
    OpacityMask {
        id:opacityMask_updownPower
        width: 1800;height: 600
        anchors.centerIn: parent
        source: sourceImg_updownPower;maskSource: maskImg_updown
    }

    // 上下充電光條 (綠色)
    OpacityMask {
        id:opacityMask_updownCharge
        width: 1800;height: 600
        anchors.centerIn: parent
        source: sourceImg_updownCharge;maskSource: maskImg_updown
    }

    // 充放電數字顯示
    OpacityMask {
        id:opacityMask_value
        width: 570;height: 240
        x:1050
        y:360
        source: sourceImg_value;maskSource: maskImg_value
    }



    Image {
        id:power_image
        width: 1200;height: 600
        source: currentModeContent['pattern_point']
        visible: true
        anchors.centerIn: parent
        sourceSize.width: 1200
        sourceSize.height: 600
        opacity: root.calculateOpc(mainScaleValue,1/(powerAnimationParameters['main']['powerFadeOut']-powerAnimationParameters['main']['powerTransparent']),1/(powerAnimationParameters['main']['powerFadeOut']-powerAnimationParameters['main']['powerTransparent'])*-powerAnimationParameters['main']['powerTransparent'])
        transformOrigin: Item.Center

                 transform: Scale{
                    id: powerScale
                    origin.x: power_image.width/2
                    origin.y: power_image.height/2
                    xScale: mainScaleValue
                    yScale: mainScaleValue
                }

    }
    Image {
        id:charge_image
        width: 1200;height: 600
        source: currentModeContent['pattern_point_charge']
        visible: true
        anchors.centerIn: parent
        sourceSize.width: 1200
        sourceSize.height: 600
        opacity: root.calculateOpc(mainScaleValue,1/(powerAnimationParameters['main']['chargeFadeOut']-powerAnimationParameters['main']['chargeTransparent']),1/(powerAnimationParameters['main']['chargeFadeOut']-powerAnimationParameters['main']['chargeTransparent'])*-powerAnimationParameters['main']['chargeTransparent'])
        transformOrigin: Item.Center

                 transform: Scale{
                    id: chargeScale
                    origin.x: charge_image.width/2
                    origin.y: charge_image.height/2
                    xScale: mainScaleValue
                    yScale: mainScaleValue
                }

    }



    MiddleNavigation {
        id:middleNav
        x:660;y:45
        visible: root.switchNaviNext
        nextRoadDistance : root.nextRoadDistance
        nextRoadName: root.nextRoadName
    }

    Image{
        id:speed_blur
        width:480
        height:480
        x:660
        y:60
        source:(powerValue>=0)?currentModeContent['pattern_blur']:currentModeContent['pattern_blur_charge']
        sourceSize.width: 480
        sourceSize.height: 480
    }

    Text {
        id: speedText
        x: 770 // 770, my_test: 650
        y: 210
        width: 260  //260, my_test: 480
        height: 180
        color: "#FFFFFF"  // white
        text: speedValue
        font.pixelSize: 150
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
        font.weight: Font.Normal
    }

    Text {
        id: kmh
        anchors.top: speedText.bottom
        anchors.horizontalCenter: speedText.horizontalCenter
        color: "#7FFFFFFF"
        text: "km / h"
        font.pixelSize: 38
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
    }

    Item {
        id: sourceImg_leftPower
        width: 1800;height: 600
        anchors.centerIn: parent
        visible: false

        Image {
            id: source_leftPower
            x:lightLeftValue
            y:-60
            width: 390
            height: 720
            source: currentModeContent['light_left']
            sourceSize.width: 390
            sourceSize.height: 720
            opacity: root.calculateOpc(lightLeftValue,1/(powerAnimationParameters['light_left_right']['powerFadeOut_left']-powerAnimationParameters['light_left_right']['powerTransparent_left']),1/(powerAnimationParameters['light_left_right']['powerFadeOut_left']-powerAnimationParameters['light_left_right']['powerTransparent_left'])*-powerAnimationParameters['light_left_right']['powerTransparent_left'])


        }

    }

    Item {
        id: sourceImg_rightPower
        width: 1800;height: 600
        anchors.centerIn: parent
        visible: false

        Image {
            id: source_rightPower
            x:lightRightValue
            y:-60
            width: 390
            height: 720
            source: currentModeContent['light_right']
            sourceSize.width: 390
            sourceSize.height: 720
            opacity: root.calculateOpc(lightRightValue,1/(powerAnimationParameters['light_left_right']['powerFadeOut_right']-powerAnimationParameters['light_left_right']['powerTransparent_right']),1/(powerAnimationParameters['light_left_right']['powerFadeOut_right']-powerAnimationParameters['light_left_right']['powerTransparent_right'])*-powerAnimationParameters['light_left_right']['powerTransparent_right'])


        }

    }

    Item {
        id: sourceImg_leftCharge
        width: 1800;height: 600
        anchors.centerIn: parent
        visible: false

        Image {
            id: source_leftCharge
            x:lightLeftValue
            y:-60
            width: 390
            height: 720
            sourceSize.width: 390
            sourceSize.height: 720
            source: currentModeContent['light_left_charge']
            opacity: root.calculateOpc(lightLeftValue,1/(powerAnimationParameters['light_left_right']['chargeFadeOut_left']-powerAnimationParameters['light_left_right']['chargeTransparent_left']),1/(powerAnimationParameters['light_left_right']['chargeFadeOut_left']-powerAnimationParameters['light_left_right']['chargeTransparent_left'])*-powerAnimationParameters['light_left_right']['chargeTransparent_left'])
        }

    }

    Item {
        id: sourceImg_rightCharge
        width: 1800;height: 600
        anchors.centerIn: parent
        visible: false

        Image {
            id: source_rightCharge
            x:lightRightValue
            y:-60
            width: 390
            height: 720
            sourceSize.width: 390
            sourceSize.height: 720
            source: currentModeContent['light_right_charge']
            opacity: root.calculateOpc(lightRightValue,1/(powerAnimationParameters['light_left_right']['chargeFadeOut_right']-powerAnimationParameters['light_left_right']['chargeTransparent_right']),1/(powerAnimationParameters['light_left_right']['chargeFadeOut_right']-powerAnimationParameters['light_left_right']['chargeTransparent_right'])*-powerAnimationParameters['light_left_right']['chargeTransparent_right'])

        }

    }

    Image {
        id: maskImg
        width: 1800;height: 600
        anchors.centerIn: parent
        source: "qrc:/assets/mask_light_left_right.png"
        visible: false
        sourceSize.width: 1800
        sourceSize.height: 600
    }

    Item {
        id: sourceImg_updownPower
        width: 1800;height: 600
        anchors.centerIn: parent
        visible: false

        Image {
            id: source_updownPower
            x:300
            y:-60
            width: 1200
            height: 720
            source: currentModeContent['light_updown']
            sourceSize.width: 1200
            sourceSize.height: 720
            opacity: root.calculateOpc(lightUpDownScaleValue,1/(powerAnimationParameters['light_up_down']['powerFadeOut']-powerAnimationParameters['light_up_down']['powerTransparent']),1/(powerAnimationParameters['light_up_down']['powerFadeOut']-powerAnimationParameters['light_up_down']['powerTransparent'])*-powerAnimationParameters['light_up_down']['powerTransparent'])
            transformOrigin: Item.Center

                     transform: Scale{
                        id: scale_updownPower
                        origin.x: source_updownPower.width/2
                        origin.y: source_updownPower.height/2
                        yScale: lightUpDownScaleValue
                        xScale:1
                    }

        }

    }

    Item {
        id: sourceImg_updownCharge
        width: 1800;height: 600
        anchors.centerIn: parent
        visible: false

        Image {
            id: source_updownCharge
            x:300
            y:-60
            width: 1200
            height: 720
            source: currentModeContent['light_updown_charge']
            sourceSize.width: 1200
            sourceSize.height: 720
            opacity: root.calculateOpc(lightUpDownScaleValue,1/(powerAnimationParameters['light_up_down']['chargeFadeOut']-powerAnimationParameters['light_up_down']['chargeTransparent']),1/(powerAnimationParameters['light_up_down']['chargeFadeOut']-powerAnimationParameters['light_up_down']['chargeTransparent'])*-powerAnimationParameters['light_up_down']['chargeTransparent'])
            transformOrigin: Item.Center

                     transform: Scale{
                        id: scale_updownCharge
                        origin.x: source_updownPower.width/2
                        origin.y: source_updownPower.height/2
                        yScale: lightUpDownScaleValue
                        xScale:1
                    }

        }

    }

    Image {
        id: maskImg_updown
        width: 1800;height: 600
        anchors.centerIn: parent
        source: "qrc:/assets/mask_light_up_down.png"
        visible: false
        sourceSize.width: 1800
        sourceSize.height: 600
    }

    Item {
        id: sourceImg_value
        width: 570;height: 240
        anchors.centerIn: parent
        visible: false

        Image {
            id: source_value
            x:valueBarXValue
            y:valueBarYValue
            width: 200
            height: 200
            source: "qrc:/assets/light_value.png"
            sourceSize.width: 200
            sourceSize.height: 200

        }



    }

    Image {
        id: maskImg_value
        width: 570;height: 240
        source: "qrc:/assets/mask_value.png"
        visible: false
        sourceSize.width: 570
        sourceSize.height: 240
    }

}
