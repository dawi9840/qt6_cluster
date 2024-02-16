#ifndef CLUSTERTOOL_H
#define CLUSTERTOOL_H

#include <QObject>
#include <QFontDatabase>
#include <QDebug>
#include <QGuiApplication>
#include <QScreen>
#include <QQmlApplicationEngine>


class ClusterTool : public QObject
{
    Q_OBJECT
public:
    explicit ClusterTool(QObject *parent = nullptr);
    void configureDpiSettings();
    void configureDisplaySettingsForAVD();
    void configureDisplaySettingsForEVM();
    int CheckLoadFontsIsExist();

private:
    static void printFontLoadResult(int fontId, const QString &fontName);

};

#endif // CLUSTERTOOL_H
