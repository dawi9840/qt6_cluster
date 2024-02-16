#include "clustertool.h"
#include <QDebug>

ClusterTool::ClusterTool(QObject *parent) : QObject(parent)
{

}

void ClusterTool::configureDpiSettings() {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QCoreApplication::setAttribute(Qt::AA_DisableHighDpiScaling);
    if (qgetenv("QT_FONT_DPI").isEmpty()) {
        qputenv("QT_FONT_DPI", "84");
    }
}

void ClusterTool::configureDisplaySettingsForAVD(){
    /*for AVD setting -->*/
    qputenv("QT_SCALE_FACTOR", "0.8");
    QCoreApplication::setAttribute(Qt::AA_DisableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
    /*<--for AVD setting*/
}

void ClusterTool::configureDisplaySettingsForEVM(){
    /*for EVM setting -->*/
    QCoreApplication::setAttribute(Qt::AA_DisableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
    /*<--for EVM setting*/
}

// Check the fonts is exist or not.
int ClusterTool::CheckLoadFontsIsExist() {
    int localFont = QFontDatabase::addApplicationFont(QGuiApplication::applicationDirPath() + "/fonts/MyriadPro-Regular.otf");
/***
    int id1 = QFontDatabase::addApplicationFont(QGuiApplication::applicationDirPath() + "/fonts/MyriadPro-Bold.otf");
    int id2 = QFontDatabase::addApplicationFont(QGuiApplication::applicationDirPath() + "/fonts/MyriadPro-It.otf");
    int id3 = QFontDatabase::addApplicationFont(QGuiApplication::applicationDirPath() + "/fonts/MyriadPro-Light.otf");
    printFontLoadResult(localFont,"MyriadPro-Regular.otf");
    printFontLoadResult(id1,"MyriadPro-Bold.otf");
    printFontLoadResult(id2,"MyriadPro-It.otf");
    printFontLoadResult(id3,"MyriadPro-Light.otf");
    qDebug() << "dawi_applicationDirPath: " << QGuiApplication::applicationDirPath();
*/
    qDebug() << "dawi_localFont: " << localFont << "\n----------\n";
    return localFont;
}

void ClusterTool::printFontLoadResult(int fontId, const QString &fontName) {
    if (fontId != -1) {
        QStringList font_families = QFontDatabase::applicationFontFamilies(fontId);
        qDebug() << "fontFamilies: " << font_families;
    } else {
        qDebug() << "fontName: " << fontName + " null";
    }
}
