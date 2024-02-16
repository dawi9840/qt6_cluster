#include "showimage.h"


ShowImage::ShowImage(QObject *parent) : QObject(parent)
{
    m_pImgProvider = new ImageProvider();
}
void ShowImage::setImage(QImage image)
{
    m_pImgProvider->img = image;
    emit callQmlRefeshImg();
}
