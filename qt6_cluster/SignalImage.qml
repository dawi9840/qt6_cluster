import QtQuick 2.15

Image {
    id:root
    property bool signalOn: false
    property bool hasSignal: false
    width: 42;height: 42
    visible: (showAllSignal || signalOn) ? true:false
    sourceSize.width: 42
    sourceSize.height: 42

    Timer {
        id:timer
        interval: 350; running: false; repeat: true;
        onTriggered: signalOn = !signalOn
        triggeredOnStart:true
    }

    onHasSignalChanged: {
        if(hasSignal)
            timer.start()
        else {
            timer.stop()
            signalOn=false
        }
    }

//    4.8.6 電路接線：方向燈必需能獨立開關；位於車輛同一側之方向燈應由
//    同一開關控制且能同步閃爍，其與儀表指示燈或聲響裝置同步。於全
//    長小於六公尺之M1及N1類車輛其配置係由製造廠決定選擇符合圖四
//    者，當裝置橙（琥珀）色側方標識燈時其應與方向燈以相同頻率同步
//    閃爍。
//    4.8.7 每分鐘閃爍次數在六十次以上，一百二十次以下。燈號控制器開啟
//    後一秒內燈具要發光，關閉後一．五秒內熄滅。


}
