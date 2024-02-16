/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Particles 2.15

Rectangle {
    id: root
    width: 200
    height: 200
    color: "transparent"
    property int speedValue: 200
    property real velo : 200
    property int lifeSpan: 2800
    property var magnitudeMap: [
        {'speed':0, 'magnitude':150},
        {'speed':120, 'magnitude':200},
        {'speed':220, 'magnitude':300},
    ]
    property real rate: 100
    property var rateMap: [
        {'speed':0, 'rate':10},
        {'speed':120, 'rate':60},
        {'speed':220, 'rate':100},
    ]
    property string particalImg

    ParticleSystem {
        anchors.fill: parent
        ImageParticle {
            anchors.fill: parent
            source: particalImg
        }
        Emitter {
            anchors.centerIn: parent
            emitRate: rate
            lifeSpan: root.lifeSpan
            size: 1
            sizeVariation: 5
            shape: EllipseShape {fill: false}
            velocity: AngleDirection {
                angleVariation: 180;
                magnitude: velo
            }
        }
    }

    onSpeedValueChanged: {
        //calculate partical lifeCycle
        //calculate velocity magnitude
        //console.log("speed = "+speedValue)
        for(var idx=0; idx<magnitudeMap.length; idx++) {
            if (magnitudeMap[idx]['speed'] > speedValue) {
                break
            }
        }
        if (idx >= magnitudeMap.length) {
            idx = magnitudeMap.length -1
        }
        var start_speed = magnitudeMap[idx-1]['speed']
        var start_value = magnitudeMap[idx-1]['magnitude']
        var end_speed = magnitudeMap[idx]['speed']
        var end_value = magnitudeMap[idx]['magnitude']
//        console.log("start_speed = "+start_speed)
//        console.log("end_speed = "+end_speed)
        if (speedValue > end_speed) {
            velo = end_value;
        } else if (speedValue <= start_speed){
            velo = start_value;
        } else {
            velo = (end_value - start_value)*(speedValue-start_speed)/(end_speed-start_speed)+start_value
        }
//        console.log("velo = "+velo)
//        console.log("lifeSpan = "+lifeSpan)

        if (speedValue > 0 && speedValue < 120) {
            lifeSpan = 1500
        } else if (speedValue >120 && speedValue < 220) {
            lifeSpan = 1200
        } else if (speedValue > 220) {
            lifeSpan = 1000
        }

        //calculate emitRate
        for(idx=0; idx<rateMap.length; idx++) {
            if (rateMap[idx]['speed'] > speedValue) {
                break
            }
        }
        if (idx >= rateMap.length) {
            idx = rateMap.length -1
        }
        start_speed = rateMap[idx-1]['speed']
        start_value = rateMap[idx-1]['rate']
        end_speed = rateMap[idx]['speed']
        end_value = rateMap[idx]['rate']
        //console.log("start_speed = "+start_speed)
        //console.log("end_speed = "+end_speed)
        if (speedValue > end_speed) {
            rate = end_value;
        } else if (speedValue <= start_speed){
            rate = start_value;
        } else {
            rate = (end_value - start_value)*(speedValue-start_speed)/(end_speed-start_speed)+start_value
        }

        idx = null;
        start_speed = null;
        start_value = null;
        end_speed = null;
        end_value = null;
    }
}
