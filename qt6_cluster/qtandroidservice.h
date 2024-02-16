#ifndef QTANDROIDSERVICE_H
#define QTANDROIDSERVICE_H

#include <QObject>
#include <QJniObject>
#include <QCoreApplication>
#include <QJniEnvironment>


class QtAndroidService : public QObject
{
    Q_OBJECT

public:
    QtAndroidService(QObject *parent = nullptr);

    static QtAndroidService *instance() { return m_instance; }
    Q_INVOKABLE void sendToService(const QString &name);
    QString converToQstring(JNIEnv *env, jstring inputJString);

signals:
    void gearInfoFromService(const QString &message);            // dawi add
    void oduTempValueFromService(const QString &valueMessage);   // dawi add
    void speedValueFromService(const QString &valueMessage);     // dawi add
    void socValueFromService(const QString &valueMessage);       // dawi add
    void drivingMileageFromService(const QString &valueMessage); // dawi add

    void messageFromService(const QString &message);
    void mediaInfo(const QString &trackName,const QString artistName,const QString &albumName,const QString &duration);
    void mediaCurrPos(const int currentPos);
    void mediaThumbPath(const QString &thumbPath);
    void signalChange(const QString &signalID,const QString &signalStatus);
    void cleanMedia();
    void currentVolume(const int currVol,const int maxVol,const int minVol);/*當前音量值,最大值,最小值*/
    void driveModeChange(const QString &mode);
    void sendKeyCode(const QString &keycode);
    void kneoUserName(const QString &username);
    void tripInfos(const QString &odometer,const QString &cardOne,const QString &cardTwo);
    void radioInfo(const int currIndex,const QString &currTitle,const QString &currFreq,const bool updatelist,const QString &radioList);
    void speedLimit(const bool status,const int value);
    void pacosStatus(const bool status);
    void chargeModeStatus(const QString status);

private:
    bool registerQJniEnv(const JNINativeMethod methods[], int totalMethods);
    static QtAndroidService *m_instance; // Static pointer to the instance of the QtAndroidService
};

#endif // QTANDROIDSERVICE_H
