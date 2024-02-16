#ifndef SHOWIMAGE_H
#define SHOWIMAGE_H
#include <QObject>
#include <imageprovider.h>
#include <QImage>

class ShowImage : public QObject
{
    Q_OBJECT
public:
    explicit ShowImage(QObject *parent = 0);
    ImageProvider *m_pImgProvider;
public slots:
    void setImage(QImage image);
signals:
    void callQmlRefeshImg();
};

#endif // SHOWIMAGE_H
