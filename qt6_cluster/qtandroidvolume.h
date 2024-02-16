#ifndef QTANDROIDVOLUME_H
#define QTANDROIDVOLUME_H

#include <QObject>

class QtandroidVolume : public QObject
{
    Q_OBJECT
public:
    QtandroidVolume(QObject *parent = nullptr);

    Q_INVOKABLE void getMusicVolume();

signals:
    void maxVolume(const int value);/*最大音量值*/
    void minVolume(const int value);/*最小音量值*/
    void currentVolume(const int currVol,const int maxVol,const int minVol);/*當前音量值,最大值,最小值*/
};


#endif // QTANDROIDVOLUME_H
