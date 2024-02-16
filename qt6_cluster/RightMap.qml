import QtQuick 2.15

Item {
    id: r_Map
    width: 660
    height: 600

    property string imgMapSource

    Image {
        id: map_img
        width: 660
        height: 600
        source: imgMapSource
        sourceSize.width: 660
        sourceSize.height: 600
    }
}
