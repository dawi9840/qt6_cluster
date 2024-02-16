import QtQuick 2.0

Canvas {
    id: canvas02
    // canvas size
    width: 400; height: 320
//    renderTarget: Canvas.FramebufferObject
//    antialiasing: true
//    smooth: false
    property bool gradientEn: true
    property bool animationEn: true
    property int speed : 60
    property var position : [
        //value, [x1,y1][x2,y2]
        [0, [359,283,], [366,268]],
        [80, [162,283], [171,254]],
        [160, [40,186], [79,180]],
        [260, [145,20], [178,20]],
//        [0, [160,200], [165,190]],
//        [80, [70,200], [95,180]],
//        [160, [0,110], [50,105]],
//        [260, [100,0], [140,0]],
    ]

    property var posList: [
        {'value':0,'x1':160,'y1':200,'x2':165,'y2':190},
        {'value':80,'x1':70,'y1':200,'x2':95,'y2':180},
        {'value':160,'x1':0,'y1':110,'x2':50,'y2':105},
        {'value':240,'x1':100,'y1':0,'x2':140,'y2':0}
    ]
    property string bgStartColor : "#1b3974"
    property string bgEndColor : "#070a25"
    property string speedBgColor: "#40000000"//"black 25% trans"
    property string speedBgColor2: "#20808080"//"black 50% trans"
    property string startColor: "#c0016acc"//"blue"
    property string endColor: "#c08be1f8"//"lightsteelblue"
    property string lightColor: "white"
    property int lightSize : 20

    Text {
        id: text1
        x: 190
        y: 90
        width: 160
        height: 100
        text: speed
        color: 'white'
        font.pixelSize: 80
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    Text {
        id: text2
        x: 190
        y: 200
        width: 160
        height: 30
        text: "km/h"
        color: '#1979c0'
        font.pixelSize: 20
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    // handler to override for drawing
    onPaint: {
        console.log("["+this+"] speed = "+speed)

        // get context to draw with
        var ctx = getContext("2d")
        ctx.save();
        //clear canvas before paint
        ctx.clearRect(0,0,width,height)

        //draw background
        //object createRadialGradient(real x0, real y0, real r0, real x1, real y1, real r1)
        var gradientBg = ctx.createRadialGradient(265,140,0,265,140,width)
        gradientBg.addColorStop(0.0, bgStartColor)
        gradientBg.addColorStop(1.0, bgEndColor)
        ctx.fillStyle = gradientBg
        ctx.fillRect(0, 0, width, height);

        //console.log("-------------- background --------------")
        ctx.fillStyle = speedBgColor
        ctx.beginPath()
        ctx.moveTo(position[0][1][0],position[0][1][1])
        for(var i=0; i<position.length; i++) {
            ctx.lineTo(position[i][2][0],position[i][2][1])
        }
        i--
        for(; i>0; i--) {
            ctx.lineTo(position[i][1][0],position[i][1][1])
        }
        ctx.closePath()
        ctx.fill()
        ctx.strokeStyle = speedBgColor2
        ctx.stroke()

        //find posIdx
        for(var posIdx=0; posIdx<position.length; posIdx++) {
            if (position[posIdx][0] >= speed) {
                break
            }
        }

        if (posIdx == 0){
            console.log("posIdx = 0, don't draw fg")
            return
        }

        console.log("posIdx = "+posIdx)
        //caculate fg end pos
        var start_pos = position[posIdx-1][0]
        var start_x1 = position[posIdx-1][1][0]
        var start_y1 = position[posIdx-1][1][1]
        var start_x2 = position[posIdx-1][2][0]
        var start_y2 = position[posIdx-1][2][1]
        var end_pos = position[posIdx][0]
        var end_x1 = position[posIdx][1][0]
        var end_y1 = position[posIdx][1][1]
        var end_x2 = position[posIdx][2][0]
        var end_y2 = position[posIdx][2][1]
        var percent = 0.0
        if (speed > end_pos) {
            percent = 1.0
        } else if (speed > start_pos){
            percent = (speed-start_pos)/(end_pos-start_pos)
        } else {
            percent = 0
        }
        console.log("percent = "+percent)
        var pos_x1 = (end_x1 - start_x1)*percent +start_x1
        var pos_y1 = (end_y1 - start_y1)*percent +start_y1
        var pos_x2 = (end_x2 - start_x2)*percent +start_x2
        var pos_y2 = (end_y2 - start_y2)*percent +start_y2
        console.log("str( "+start_x1+" , "+start_y1+" ) ( "+start_x2+" , "+start_y2+" )")
        console.log("end( "+end_x1+" , "+end_y1+" ) ( "+end_x2+" , "+end_y2+" )")
        console.log("pos( "+pos_x1+" , "+pos_y1+" ) ( "+pos_x2+" , "+pos_y2+" )")

        //draw foreground
        var pos_m = (pos_y2-pos_y1)/(pos_x2-pos_x1)
        var gra_deg = Math.atan(pos_m)+Math.PI/2
        //console.log("pos_m = "+pos_m+" = "+(pos_y2-pos_y1)+"/"+(pos_x2-pos_x1))
        console.log("gra_deg = "+gra_deg/Math.PI*180)
        var offset_x = lightSize * Math.cos(gra_deg)
        var offset_y = lightSize * Math.sin(gra_deg)
        console.log("offset( "+offset_x+","+offset_y+")")
        var gra_x1 = pos_x1+offset_x
        var gra_y1 = pos_y1+offset_y
        var gra_x2 = pos_x1
        var gra_y2 = pos_y1
        var gradient = ctx.createLinearGradient(gra_x1,gra_y1,gra_x2,gra_y2)
        console.log("gra( "+gra_x1+" , "+gra_y1+" ) ( "+gra_x2+" , "+gra_y2+" )")

        gradient.addColorStop(0.3, startColor)
        gradient.addColorStop(0.7, endColor)
        gradient.addColorStop(0.8, lightColor)
        gradient.addColorStop(1.0, lightColor)
        ctx.fillStyle = gradient
        //fill gradient fg
        //console.log("-------------- foreground --------------")
        ctx.beginPath()
        ctx.moveTo(position[0][1][0],position[0][1][1])
        for(i=0; i<posIdx; i++) {
            ctx.lineTo(position[i][2][0],position[i][2][1])
        }
        ctx.lineTo(pos_x2,pos_y2)
        ctx.lineTo(pos_x1,pos_y1)
        i--
        for(; i>0; i--) {
            ctx.lineTo(position[i][1][0],position[i][1][1])
        }
        ctx.closePath()
        ctx.fill()
    }

    onSpeedChanged: {
        if (!animationEn)
            return
        if (speed > 260)
            speed = 0
        canvas02.requestPaint();
    }

}

