import QtQuick 2.15
import Qt5Compat.GraphicalEffects
//import QtGraphicalEffects 1.15

//用於在指定的區域繪製一個帶有漸變效果的圓形形狀，通常用於顯示速度或進度條。
//使用 Canvas 元件根據速度變化來繪製一個漸變形狀，並使用遮罩和透明度遮罩來顯示特定區域的效果。
Item {
    id: root
    property var posList/*保存位置信息的屬性。*/
    property point gradientStartPoint/*漸變的起始點*/
    property string backgroundSource/*背景圖片的來源*/
    property string maskSource/*遮罩圖片的來源*/
    property string scaleImgSource//遮罩圖片的來源
    property alias  scaleOpacityMaskVisible:scaleOpacityMask.visible
    /*定義 scaleOpacityMaskVisible 的屬性，並設置為 scaleOpacityMask.visible 的別名。
    scaleOpacityMaskVisible 屬性的值會與 scaleOpacityMask.visible 的值同步。
    當更改 scaleOpacityMaskVisible 的值時，會同步更新 scaleOpacityMask 元件的 visible 屬性的值。
    方便在需要時直接訪問和修改 scaleOpacityMask 的可見性。*/
    property var gradientColorList//漸變顏色的列表
    property int speed/*當前時速*/
    clip: false

    /*圓心(386,300)*/

    Canvas {
        id:speedAreaCanvas
        width: root.width;height: root.height
        antialiasing: true
        renderStrategy: Canvas.Threaded
        visible: false
        onPaint: {
            // get context to draw with
            var spd = root.speed;
            var ctx = getContext("2d")
            //clear canvas before paint
            ctx.clearRect(0,0,width,height)

            //find posIdx
            for(var posIdx=0; posIdx<posList.length; posIdx++) {
                if (posList[posIdx]['value'] >= spd) {
                    break
                }
            }

            if (posIdx == 0){
//                console.log("posIdx = 0, don't draw fg")
                return
            }

//            console.log("posIdx = "+posIdx)
            //caculate fg end pos
            var start_pos = posList[posIdx-1]['value']
            var start_x1 = posList[posIdx-1]['x1']
            var start_y1 = posList[posIdx-1]['y1']
            var start_x2 = posList[posIdx-1]['x2']
            var start_y2 = posList[posIdx-1]['y2']
            var end_pos = posList[posIdx]['value']
            var end_x1 = posList[posIdx]['x1']
            var end_y1 = posList[posIdx]['y1']
            var end_x2 = posList[posIdx]['x2']
            var end_y2 = posList[posIdx]['y2']
            var percent = 0.0
            if (spd > end_pos) {
                percent = 1.0
            } else if (spd > start_pos){
                percent = (spd-start_pos)/(end_pos-start_pos)
            } else {
                percent = 0
            }
//            console.log("percent = "+percent)
            var pos_x1 = (end_x1 - start_x1)*percent +start_x1
            var pos_y1 = (end_y1 - start_y1)*percent +start_y1
            var pos_x2 = (end_x2 - start_x2)*percent +start_x2
            var pos_y2 = (end_y2 - start_y2)*percent +start_y2
            var gradient = ctx.createLinearGradient(gradientStartPoint.x,gradientStartPoint.y,pos_x1,pos_y1)
            for(var i=0;i<gradientColorList.length;i++){
                gradient.addColorStop(gradientColorList[i]['value'], gradientColorList[i]['color'])
            }
            ctx.fillStyle = gradient
            //fill gradient fg
            //console.log("-------------- foreground --------------")
            ctx.beginPath()
            ctx.moveTo(posList[0]['x1'],posList[0]['y1'])
            for(i=0; i<posIdx; i++) {
                ctx.lineTo(posList[i]['x2'],posList[i]['y2'])
            }
            ctx.lineTo(pos_x2,pos_y2)
            ctx.lineTo(pos_x1,pos_y1)
            i--
            for(; i>0; i--) {
                ctx.lineTo(posList[i]['x1'],posList[i]['y1'])
            }
            ctx.closePath()
            ctx.fill()

            spd = null;
            ctx = null;
            posIdx = null;
            start_pos = null;
            start_x1 = null;
            start_y1 = null;
            start_x2 = null;
            start_y2 = null;
            end_pos = null;
            end_x1 = null;
            end_y1 = null;
            end_x2 = null;
            end_y2 = null;
            percent = null;
            pos_x1 = null;
            pos_y1 = null;
            pos_x2 = null;
            pos_y2 = null;
            gradient = null;
            i = null;
        }
    }

    Image {
        id: speedMask
        anchors.fill: parent
        source: maskSource
        sourceSize.height: parent.height
        sourceSize.width: parent.width
        visible: false
    }

    OpacityMask {
        id:speedOpacityMask
        anchors.fill: parent
        visible: true
        source: speedAreaCanvas;maskSource: speedMask
    }

    Image {
        id:scaleImg
        anchors.fill: parent
        source: scaleImgSource
        sourceSize.height: parent.height
        sourceSize.width: parent.width
        visible: false
    }

    OpacityMask {
        id:scaleOpacityMask
        anchors.fill: parent
        visible: false
        source: scaleImg;maskSource: speedAreaCanvas
        clip: false
    }

    onSpeedChanged: {
        speedAreaCanvas.requestPaint();
    }
}

