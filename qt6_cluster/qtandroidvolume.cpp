#include "qtandroidvolume.h"
#include <QAndroidJniObject>
#include <QtAndroid>
#include <QtDebug>


QtandroidVolume::QtandroidVolume(QObject *parent) : QObject(parent)
{

}

void QtandroidVolume::getMusicVolume() {
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject name = QAndroidJniObject::getStaticObjectField("android/content/Context","AUDIO_SERVICE","Ljava/lang/String;");
    QAndroidJniObject service = activity.callObjectMethod("getSystemService","(Ljava/lang/String;)Ljava/lang/Object;",name.object<jstring>());
    const int streamMaxVolume = service.callMethod<jint>("getStreamMaxVolume", "(I)I", 3);
    qDebug()<< "QtandroidVolume::streamMaxVolume = " << streamMaxVolume;
//    emit maxVolume(streamMaxVolume);

    const int streamMinVolume = service.callMethod<jint>("getStreamMinVolume", "(I)I", 3);
    qDebug()<< "QtandroidVolume::streamMinVolume = " << streamMinVolume;
//    emit minVolume(streamMinVolume);

    const int streamcurrVolume = service.callMethod<jint>("getStreamVolume", "(I)I", 3);
    qDebug()<< "QtandroidVolume::streamcurrVolume = " << streamcurrVolume;
    emit currentVolume(streamcurrVolume,streamMaxVolume,streamMinVolume);
}
