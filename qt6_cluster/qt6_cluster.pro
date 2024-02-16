QT += quick \
    qml

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        clustertool.cpp \
        main.cpp \

RESOURCES += \
#    $$files(adas/*) \
    qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += \
#    adas/imports \
#    adas/asset_imports

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

DISTFILES += \
    android/src/com/foxconn/MediaPlaybackHandler.java \
    android/src/com/foxconn/util/HexValueLookup.java \
    android/src/com/foxconn/util/SignalCANInfo.java \
    android/src/com/foxconn/util/SignalReceiver.java \
    android/src/com/foxconn/util/SpecificCanIdDataset.java \
    fonts/MyriadPro-Bold.otf \
    fonts/MyriadPro-It.otf \
    fonts/MyriadPro-Light.otf \
    fonts/MyriadPro-Regular.otf \
    fonts/MyriadPro-Semibold.otf \
    fonts/fonts.txt

#Android build setting
android {
    QT += \
        core \
        core-private

    HEADERS += \
        qtandroidservice.h

    SOURCES += \
        qtandroidservice.cpp

    DISTFILES += \
        android/AndroidManifest.xml \
        android/aidl/com/fxc/libCanWrapperNDK/ICanStCallback.aidl \
        android/aidl/com/fxc/libCanWrapperNDK/IMyAidlInterface2.aidl \
        android/aidl/com/fxc/ev/mediacenter/datastruct/MediaItem.aidl \
        android/aidl/com/fxc/ev/mediacenter/IDataChangeListener.aidl \
        android/aidl/com/fxc/ev/mediacenter/IMyAidlInterface.aidl \
        android/aidl/com/fxc/ev/driverprofile/IDriverAidlInterface.aidl \
        android/aidl/com/fxc/ev/driverprofile/IDriverCallback.aidl \
        android/build.gradle \
        android/gradle.properties \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/gradlew \
        android/gradlew.bat \
        android/res/values/libs.xml \
        android/src/com/foxconn/QtAndroidService.java \
        android/src/com/foxconn/ClusterActivity.java \
        android/src/com/fxc/ev/mediacenter/datastruct/MediaItem.java \
        android/src/com/fxc/ev/util/SystemPropUtil.java \
        android/libs/car_intermediates.jar \
        android/libs/car_broadcastradio.jar \
        android/libs/car_framework.jar
}

HEADERS += \
    clustertool.h \
