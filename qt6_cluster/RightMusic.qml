import QtQuick 2.15
import QtQuick.Timeline 1.0
import QtQuick.Controls 2.15

Item {
    id: root
    width: 660
    height: 600
    property string text_artistText
    property string text_musicText
    property alias text_passText: text_pass.text
    property alias textremainText: textremain.text
    property alias progressbarValue:progressBar.value
    property alias progressbarmaximumValue:progressBar.to
    property alias remainText:textremain.text
    property alias passText:text_pass.text

    property string progressBarBgColor
    property string imgMusicAlbum: "qrc:/assets/img_music_default.png"
    property bool displayMusicInfo:true
    property bool displayRadioInfo:false
    property string backgroundImage
    property int defaultIndex:0
    property int radioListIndex:0

    /* root 定義一個變量，用於跟蹤是否接收到音樂封面_dawi add */
    property bool musicCoverReceived: false


    Image {
        anchors.fill: parent
        source: backgroundImage
        sourceSize.width: 660
        sourceSize.height: 600
    }

    Image {
        id: album
        x:180
        y:111
        width: 300
        height: 300
        cache:false
        source: imgMusicAlbum
        sourceSize.width: 300
        sourceSize.height: 300
    }

    Item {
        id:musicInfo
        visible: root.displayMusicInfo
        anchors.fill: parent
        Text {
            id: textremain
            x: 165
            y: 546
            width: 151
            height: 36
            color: "#FFFFFF"
            opacity: 0.5
            text: "0"
            font.pixelSize: 30
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
            font.weight: Font.Normal
        }

        Text {
            id: text_pass
            x: 345
            y: 546
            width: 151
            height: 36
            color: "#FFFFFF"
            opacity: 0.5
            text: "0"
            font.pixelSize: 30
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
            font.weight: Font.Normal
        }

        ProgressBar {
            id: progressBar
            x: 150
            y: 528
            from:0
            to:120
            value: 0
            implicitWidth: 360
            implicitHeight: 6
            background: Rectangle {
                radius: 3
                color: progressBarBgColor
                implicitWidth: 360
                implicitHeight: 6
            }

            contentItem: Item {
                implicitWidth: 360
                implicitHeight: 6
                Rectangle {
                    width: progressBar.visualPosition * parent.width
                    height: parent.height
                    radius: 3
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop {
                            position: 1.0;color: "#FFEFB7"
                        }
                        GradientStop {
                            position: 0.76;color: "#FFE68D"
                        }
                        GradientStop {
                            position: 0.52;color: "#F6BB6D"
                        }
                        GradientStop {
                            position: 0.26;color: "#94575E"
                        }
                        GradientStop {
                            position: 0.0;color: "#31253F"
                        }
                    }
                }
            }

            onValueChanged: excuteTime(value)
        }

        Text {
            id: text_artist
            x: 90
            y: 468
            width: 481
            height: 36
            color: "#FFFFFF"
            opacity: 0.5
            text: root.text_artistText
            elide: Text.ElideRight
            font.pixelSize: 30
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
            font.weight: Font.Normal
        }

        Text {
            id: text_music
            x: 90
            y: 419
            width: 481
            height: 46
            color: "#ffffff"
            text: root.text_musicText
            elide: Text.ElideRight
            font.pixelSize: 38
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
            font.weight: Font.Normal
        }
    }

    Item {
        id:radioInfo
        visible: root.displayRadioInfo
        anchors.fill: parent

        Text {
            id: text_radioTitle
            x: 90
            y: 468
            width: 481
            height: 36
            color: "#FFFFFF"
            opacity: 0.5
            text: root.text_artistText
            elide: Text.ElideRight
            font.pixelSize: 30
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
            font.weight: Font.Normal
        }

        Text {
            id: text_radio
            x: 90
            y: 419
            width: 481
            height: 46
            color: "#ffffff"
            text: root.text_musicText
            elide: Text.ElideRight
            font.pixelSize: 38
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
            font.weight: Font.Normal
        }
    }

    function excuteTime(){
        var currentTime = progressbarValue.toFixed(0)
        var maxTime = progressbarmaximumValue.toFixed(0)

        var min = Math.floor(currentTime/60)
        var sec = Math.floor(currentTime%60)
        root.remainText = pad(min,2) + ":" + pad(sec,2)

        var lessTime = maxTime - currentTime;

        var less_min = Math.floor(lessTime/60)
        var less_sec = Math.floor(lessTime%60)
        root.passText = "-" + pad(less_min,2) + ":" + pad(less_sec,2)

        currentTime = null;
        maxTime = null;
        min = null;
        sec = null;
        lessTime = null;
        less_min = null;
        less_sec = null;
    }

    function pad(num,n) {
        var len = num.toString().length;
        while(len < n) {
            num = "0"+ num;
            len++;
        }
        len = null;
        return num;

    }

    RadioList {
        id:radioList
        width: parent.width
        height: parent.height
        radioIndex:root.radioListIndex
        visible: false
    }

    onText_artistTextChanged: {
        console.log("onText_artistTextChanged, text_artistText = " + text_artistText)
        text_artist.text = text_artistText;
        text_radioTitle.text = text_artistText;
    }

    onText_musicTextChanged: {
        console.log("onText_artistTextChanged, text_musicText = " + text_musicText)
        text_music.text = text_musicText
        text_radio.text = text_musicText
    }

    onRadioListIndexChanged: {
        animateRadioBar.stop();
        animateRadioBar.start();
    }

    ParallelAnimation {
        id:animateRadioBar
        SequentialAnimation {
            running: false
            PropertyAnimation {
                target: radioList
                properties: "visible"
                to:true
                duration: 200
                easing {
                    type:Easing.OutQuart
                }
            }
            PropertyAnimation {
                target: radioList
                properties: "visible"
                to:true
                duration: 1500
            }

            PropertyAnimation {
                target: radioList
                properties: "visible"
                to: false
                duration: 200
                easing {
                    type:Easing.OutQuart
                }
            }
        }

        SequentialAnimation {
            running: false
            PropertyAnimation {
                target: album
                properties: "visible"
                to:false
                duration: 200
                easing {
                    type:Easing.OutQuart
                }
            }

            PropertyAnimation {
                target: album
                properties: "visible"
                to:false
                duration: 1500
            }

            PropertyAnimation {
                target: album
                properties: "visible"
                to: true
                duration: 200
                easing {
                    type:Easing.OutQuart
                }
            }
        }

        SequentialAnimation {
            running: false
            PropertyAnimation {
                target: radioInfo
                properties: "visible"
                to:false
                duration: 200
                easing {
                    type:Easing.OutQuart
                }
            }
            PropertyAnimation {
                target: radioInfo
                properties: "visible"
                to:false
                duration: 1500
            }

            PropertyAnimation {
                target: radioInfo
                properties: "visible"
                to: true
                duration: 200
                easing {
                    type:Easing.OutQuart
                }
            }
        }
    }

    Connections {
        target: qtAndroidService
        function onMediaInfo(trackName, artistName, albumName, duration) {/*收到Music Service 媒體資訊*/
            console.log("onMediaInfo : " + trackName + ":" + artistName + ":" + albumName + ":" + duration)
            root.text_musicText = trackName;
            root.text_artistText = artistName + " - " + albumName;
            root.progressbarmaximumValue = Number(duration);
            root.displayMusicInfo = true;
            root.displayRadioInfo = false;
        }

        function onMediaThumbPath(thumbPath) {/*收到Music 專輯封面*/
            console.log("thumbPath : " + thumbPath);
            var filepath = "file://"+thumbPath;
            console.log("filepath : " + filepath);

            root.musicCoverReceived = true; // 設置接收到音樂封面的標誌_dawi add

            root.imgMusicAlbum = "";
            root.imgMusicAlbum = filepath;

            filepath = null;
        }

        function onMediaCurrPos(currPos) {/*收到Music Service 播放進度*/
            console.log("收到 Music Service 播放進度: " + currPos + " s");
            root.progressbarValue = currPos;
        }

        function onCleanMedia(){/*Muisc Service 解除綁定*/
            console.log("onCleanMedia")

            // 檢查是否接收到音樂封面，如果沒有則顯示預設圖片 dawi add
            if (!root.musicCoverReceived) {
                root.imgMusicAlbum = "qrc:/assets/img_music_default.png";
            }

            // 重置接收到音樂封面的標誌 dawi add
            root.musicCoverReceived = false;

            // 其他清理操作...
            root.displayMusicInfo = false;
        }

        function onRadioInfo(currIndex,currTitle,currFreq,isUpdateList,radio_list){/*收到Radio播放列表變化*/
            console.log("onRadioInfo, currIndex: " + currIndex + ",currTitle: " + currTitle + ",currFreq: " + currFreq);
            console.log("onRadioInfo, isUpdateList: " + isUpdateList);
            console.log("onRadioInfo, radio_list: " + radio_list);
            root.imgMusicAlbum = "qrc:/assets/img_music_default.png";
            root.text_artistText = currTitle;
            root.text_musicText = currFreq;
            root.displayMusicInfo = false;
            root.displayRadioInfo = true;
        }
    }

//    Timeline {
//        id: timeline
//        animations: [
//            TimelineAnimation {
//                id: timelineAnimation
//                duration: 60000
//                pingPong: true
//                loops: -1
//                running: true
//                to: 60
//                from: 0
//            }
//        ]
//        startFrame: 0
//        endFrame: 1000
//        enabled: false
//        KeyframeGroup {
//            target: progressBar
//            property: "value"
//            Keyframe {
//                value: 60
//                frame: 0
//            }

//            Keyframe {
//                value: 70
//                frame: 10
//            }

//            Keyframe {
//                value: 80
//                frame: 20
//            }
//            Keyframe {
//                value: 90
//                frame: 30
//            }
//            Keyframe {
//                value: 100
//                frame: 40
//            }
//            Keyframe {
//                value: 110
//                frame: 50
//            }
//            Keyframe {
//                value: 120
//                frame: 60
//            }
//        }
//    }

}

