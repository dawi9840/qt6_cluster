#ifndef QTANDROIDSERVICE_H
#define QTANDROIDSERVICE_H

#include <QObject>
#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QJniEnvironment>
#include <QtCore/private/qandroidextras_p.h>
#include <QJniObject>
#include <typeinfo>
#include <QDebug>

class QtAndroidService : public QObject
{
    Q_OBJECT

public:
    explicit QtAndroidService(QObject *parent = nullptr); // Constructor
    static QtAndroidService *instance(){ return m_instance;}
    void startServiceToInvokeAndroidInternet();
    void testConnectSignal();
    Q_INVOKABLE void storeQmlInstance();

signals:
    // Signal emitted when a message is received from the service
    void messageFromService(const QString &message);

//    void signalChange(const QString &signalID, const QString &signalStatus);
//    void mediaInfo(const QString &trackName,const QString &artistName,const QString &albumName,const QString &duration);
//    void mediaCurrPos(const int currentPos);
//    void mediaThumbPath(const QString &thumbPath);
//    void cleanMedia();
//    void currentVolume(const int currVol,const int maxVol,const int minVol);/*當前音量值,最大值,最小值*/
//    void driveModeChange(const QString &mode);
//    void sendKeyCode(const QString &keycode);
//    void kneoUserName(const QString &username);
//    void tripInfos(const QString &odometer,const QString &cardOne,const QString &cardTwo);
//    void radioInfo(const int currIndex,const QString &currTitle,const QString &currFreq,const bool updatelist,const QString &radioList);
//    void speedLimit(const bool status,const int value);
//    void pacosStatus(const bool status);
//    void chargeModeStatus(const QString &status);

public slots:
    void receivedFromAndroidServiceSlot(const QString &message);

private:
    bool registerQJniEnv(const JNINativeMethod methods[], int totalMethods);
    static QtAndroidService *m_instance; // Static pointer to the instance of the QtAndroidService
};

#endif // QTANDROIDSERVICE_H
