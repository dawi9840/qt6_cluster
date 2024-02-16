import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id:root
    property string batteryStatus: "Regular" /* Regular:未充電;Charge:充電中;Unstable:充電不穩定;Completed:充電完成;Error:充電異常;Scheduled:排程中*/
    property alias kmvalue: kmValue.text
    property alias batteryPercent: batteryPercent.text
    property alias kmminValue:kmminValue.text
    property alias ampereValue:ampereValue.text
    property alias kwValue:kwValue.text
    property alias distanceValue:distanceValue.text
    property alias remainValue:remainValue.text
    property alias estimateValue:estimateValue.text
    property alias paidValue:paidValue.text


    onBatteryStatusChanged: {
        if (unstableDialog.visible === true) {
            unstableDialog.visible = false;
        }

        if (root.batteryStatus === "Completed") {
            chargeStatus.text = "Charging Complete"
            chargeStatus.color = "#31C75C"
            ampereValue.color = "#FFFFFF"
            info.visible = false;
        } else if (root.batteryStatus === "Charge") {
            chargeStatus.text = "Super Charging..."
            chargeStatus.color = "#31C75C"
            ampereValue.color = "#FFFFFF"
            info.visible = true;
        } else if (root.batteryStatus === "Unstable") {
            chargeStatus.text = "Unstable Current"
            chargeStatus.color = "#EDAD43"
            ampereValue.color = "#EDAD43"
            info.visible = true;
        } else if (root.batteryStatus === "Error") {
            chargeStatus.text = "Unstable Current"
            chargeStatus.color = "#EDAD43"
            unstableDialog.visible = true
            ampereValue.color = "#EDAD43"
            info.visible = true;
            showUnstableDlg.stop();
            showUnstableDlg.start();
        }
    }

    Item {
        x:300;y:217
        width: 630;height:286
        Label {
            id: chargeStatus
            width: parent.width
            text: "Super Charging..."
            font.pixelSize:48
            color: "#31C75C"
        }

        Label {
            id: kmValue
            height:108
            anchors.top: chargeStatus.bottom
            anchors.topMargin: 42
            text: "123"
            font.pixelSize: 90
            color: "#FFFFFF"
        }

        Label {
            width:51;height:46
            anchors {
                bottom: kmValue.bottom
                bottomMargin: 18
                left: kmValue.right
                leftMargin: 18
            }
            text: "km"
            font.pixelSize: 38
            color: "#FFFFFF"
            opacity: 0.5
        }

        Label {
            id: batteryPercent
            height:108
            anchors {
                top: kmValue.top
                left: parent.left
                leftMargin: 328
            }
            text: "50"
            font.pixelSize: 90
            color: "#FFFFFF"
        }

        Label {
            width:31;height:46
            anchors {
                bottom: batteryPercent.bottom
                bottomMargin: 18
                left: batteryPercent.right
                leftMargin: 18
            }
            text: "%"
            font.pixelSize: 38
            color: "#FFFFFF"
            opacity: 0.5
        }

        Label {
            id:kmminValue
            height: 36
            anchors {
                bottom: parent.bottom
                left: parent.left
            }
            text: "15"
            font.pixelSize: 30
            color: "#FFFFFF"
            opacity: 0.75
        }

        Label {
            height: 36
            anchors {
                bottom: parent.bottom
                left: kmminValue.right
                leftMargin: 12
            }
            text: "km/min"
            font.pixelSize: 30
            color: "#FFFFFF"
            opacity: 0.5
        }

        Label {
            id:ampereValue
            height: 36
            anchors {
                bottom: parent.bottom
                left: parent.left
                leftMargin: 212
            }
            text: "190"
            font.pixelSize: 30
            color: "#FFFFFF"
            opacity: 0.75
        }

        Label {
            height: 36
            anchors {
                bottom: parent.bottom
                left: ampereValue.right
                leftMargin: 12
            }
            text: "A"
            font.pixelSize: 30
            color: "#FFFFFF"
            opacity: 0.5
        }

        Label {
            id:kwValue
            height: 36
            anchors {
                bottom: parent.bottom
                left: parent.left
                leftMargin: 360
            }
            text: "166"
            font.pixelSize: 30
            color: "#FFFFFF"
            opacity: 0.75
        }

        Label {
            height: 36
            anchors {
                bottom: parent.bottom
                left: kwValue.right
                leftMargin: 12
            }
            text: "kW"
            font.pixelSize: 30
            color: "#FFFFFF"
            opacity: 0.5
        }

        Label {
            id:distanceValue
            height: 36
            anchors {
                bottom: parent.bottom
                left: parent.left
                leftMargin: 529
            }
            text: "+23"
            font.pixelSize: 30
            color: "#FFFFFF"
            opacity: 0.75
        }

        Label {
            height: 36
            anchors {
                bottom: parent.bottom
                left: distanceValue.right
                leftMargin: 12
            }
            text: "km"
            font.pixelSize: 30
            color: "#FFFFFF"
            opacity: 0.5
        }
    }

    Item {
        id: info
        x:1140;y:261
        width:471;height: 198
        Row {
            spacing: 60
            Column {
                spacing: 30
                Item {
                    width: 233;height: 46
                    Image {
                        id: remainingIcon
                        width: 36;height: 36
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        source: "qrc:/assets/iconRemaining.png"
                        sourceSize.width: 36
                        sourceSize.height: 36
                    }

                    Label {
                        height: parent.height
                        anchors {
                            left: remainingIcon.right
                            leftMargin: 18
                        }
                        text: "Remaining:"
                        font.pixelSize: 38
                        color: "#FFFFFF"
                        opacity: 0.5
                    }
                }

                Item {
                    width: 233;height: 46
                    Image {
                        id: estimatedIcon
                        width: 36;height: 36
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        source: "qrc:/assets/iconEstimated.png"
                        sourceSize.width: 36
                        sourceSize.height: 36
                    }

                    Label {
                        height: parent.height
                        anchors {
                            left: estimatedIcon.right
                            leftMargin: 18
                        }
                        text: "Estimated:"
                        font.pixelSize: 38
                        color: "#FFFFFF"
                        opacity: 0.5
                    }
                }

                Item {
                    width: 233;height: 46
                    Image {
                        id: paidIcon
                        width: 36;height: 36
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        source: "qrc:/assets/iconPaid.png"
                        sourceSize.width: 36
                        sourceSize.height: 36
                    }

                    Label {
                        height: parent.height
                        anchors {
                            left: paidIcon.right
                            leftMargin: 18
                        }
                        text: "Paid:"
                        font.pixelSize: 38
                        color: "#FFFFFF"
                        opacity: 0.5
                    }
                }
            }

            Column {
                spacing: 30
                Item {
                    width: 178;height: 46
                    Label {
                        id:remainValue
                        height: parent.height
                        text: "1 hr 30 min"
                        font.pixelSize: 38
                        color: "#FFFFFF"
                    }
                }

                Item {
                    width: 178;height: 46
                    Label {
                        id:estimateValue
                        height: parent.height
                        text: "00:00"
                        font.pixelSize: 38
                        color: "#FFFFFF"
                    }
                }

                Item {
                    width: 178;height: 46
                    Label {
                        id:paidValue
                        height: parent.height
                        text: "$ 00.0"
                        font.pixelSize: 38
                        color: "#FFFFFF"
                    }
                }
            }
        }
    }

    Item {
        id: unstableDialog
        visible: false
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            color: "#000000"
            opacity: 0.5
        }

        Rectangle {
            id:dialogbg
            width: 648
            height: 328
            color: "#14336B"
            anchors.centerIn: parent
        }

        Image {
            width: 60;height: 60
            sourceSize.width: 60
            sourceSize.height: 60
            anchors {
                top: dialogbg.top
                topMargin: 45
                horizontalCenter: dialogbg.horizontalCenter
            }
            source: "qrc:/assets/iconError.png"
        }

        Label {
            width: 558;height: 46
            anchors {
                top: dialogbg.top
                topMargin: 135
                horizontalCenter: dialogbg.horizontalCenter
            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Unexpected problems occur"
            font.pixelSize: 38
            color: "#FFFFFF"
        }

        Label {
            width: 558;height: 72
            anchors {
                top: dialogbg.top
                topMargin: 211
                horizontalCenter: dialogbg.horizontalCenter
            }

            clip: true
//            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Please follow the directions which showed  \n  at center screen to solve the problems."
            font.pixelSize: 30
            color: "#FFFFFF"
        }
    }

    PropertyAnimation {
        id: showUnstableDlg
        target: unstableDialog
        properties: "visible"
        to: true
        duration: 200
        easing {
            type:Easing.OutQuart
        }
    }

    PropertyAnimation {
        id: hideUnstableDlg
        target: unstableDialog
        properties: "visible"
        to: false
        duration: 200
        easing {
            type:Easing.OutQuart
        }
    }
}
