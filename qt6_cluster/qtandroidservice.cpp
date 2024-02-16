#include "qtandroidservice.h"
#include "private/qandroidextras_p.h"

// Initialize the singleton instance of QtAndroidService
QtAndroidService *QtAndroidService::m_instance = nullptr;

static void receivedFromAndroidService(JNIEnv *env, jobject /*thiz*/, jstring value)
{
    qDebug() << "cpp_receivedFromAndroidService";

    const QString valueQString = QtAndroidService::instance()->converToQstring(env, value);

    // Emit a signal to the QtAndroidService instance
    if (QtAndroidService::instance() != nullptr) {

        qDebug() << "Before emit";
        emit QtAndroidService::instance()->messageFromService(valueQString);
        qDebug() << "invoke messageFromService()";
        qDebug() << "After emit";
    }
}

static void receivedMediaInfo(JNIEnv *env, jobject /*thiz*/, jstring trackName,
                              jstring artistName, jstring albumName, jstring duration)
{
    const QString trackNameQString = QtAndroidService::instance()->converToQstring(env, trackName);
    const QString artistNameQString = QtAndroidService::instance()->converToQstring(env, artistName);
    const QString albumNameQString = QtAndroidService::instance()->converToQstring(env, albumName);
    const QString durationQString = QtAndroidService::instance()->converToQstring(env, duration);

    if (QtAndroidService::instance() != nullptr) {
        emit QtAndroidService::instance()->mediaInfo(trackNameQString,
                                                     artistNameQString,
                                                     albumNameQString,
                                                     durationQString);
    }
}

static void receivedMediaCurrPos(JNIEnv /*env*/, jobject /*thiz*/, int currPos)
{
    if (QtAndroidService::instance() != nullptr) {
        emit QtAndroidService::instance()->mediaCurrPos(currPos);
    }
}

static void receivedSignalChange(JNIEnv *env, jobject /*thiz*/, jstring id, jstring status)
{
    const QString idQString = QtAndroidService::instance()->converToQstring(env, id);
    const QString statusQString = QtAndroidService::instance()->converToQstring(env, status);

    if (QtAndroidService::instance() != nullptr) {
        emit QtAndroidService::instance()->signalChange(idQString, statusQString);
    }
}

static void receivedThumb(JNIEnv *env, jobject /*thiz*/, jstring bitmapData)
{
    const QString bitmapDataStrQString = QtAndroidService::instance()->converToQstring(env, bitmapData);

    if (QtAndroidService::instance() != nullptr) {
        emit QtAndroidService::instance()->mediaThumbPath(bitmapDataStrQString);
    }
}

static void cleanMeida()
{
    if (QtAndroidService::instance() != nullptr) {
        emit QtAndroidService::instance()->cleanMedia();
    }
}

static void musicVolume(JNIEnv /*env*/, jobject /*thiz*/,
                        int currVol, int maxVol, int minVol)
{
    if (QtAndroidService::instance() != nullptr) {
        emit QtAndroidService::instance()->currentVolume(currVol, maxVol, minVol);
    }
}

static void receivedDriveMode(JNIEnv *env, jobject /*thiz*/, jstring mode)
{
    const QString modeQString = QtAndroidService::instance()->converToQstring(env, mode);

    if (QtAndroidService::instance() != nullptr) {
        emit QtAndroidService::instance()->driveModeChange(modeQString);
    }
}

static void receivedKeyCode(JNIEnv *env, jobject /*thiz*/, jstring keycode)
{
    const QString keycodeQString = QtAndroidService::instance()->converToQstring(env, keycode);

    if (QtAndroidService::instance() != nullptr) {
        emit QtAndroidService::instance()->sendKeyCode(keycodeQString);
    }
}

static void receivedKneoUserName(JNIEnv *env, jobject /*thiz*/, jstring username)
{
    const QString usernameQString = QtAndroidService::instance()->converToQstring(env, username);

    if (QtAndroidService::instance() != nullptr) {
        emit QtAndroidService::instance()->kneoUserName(usernameQString);
    }
}

static void receivedTripCards(JNIEnv *env, jobject /*thiz*/,
                              jstring odometer ,jstring cardOne, jstring cardTwo)
{
    const QString odometerQString = QtAndroidService::instance()->converToQstring(env, odometer);
    const QString cardOneQString = QtAndroidService::instance()->converToQstring(env, cardOne);
    const QString cardTwoQString = QtAndroidService::instance()->converToQstring(env, cardTwo);

    if (QtAndroidService::instance() != nullptr) {
        emit QtAndroidService::instance()->tripInfos(odometerQString, cardOneQString, cardTwoQString);
    }
}

static void receivedRadioInfo(JNIEnv *env, jobject /*thiz*/, int currradioidx,
                              jstring currradiotitle, jstring currradiofrq,
                              bool updateradiolist, jstring radiolist)
{
    const QString currradiotitleQString = QtAndroidService::instance()->converToQstring(env, currradiotitle);
    const QString currradiofrqQString = QtAndroidService::instance()->converToQstring(env, currradiofrq);
    const QString radiolistQString = QtAndroidService::instance()->converToQstring(env, radiolist);

    if (QtAndroidService::instance() != nullptr) {
        emit QtAndroidService::instance()->radioInfo(currradioidx,
                                                     currradiotitleQString,
                                                     currradiofrqQString,
                                                     updateradiolist,
                                                     radiolistQString);
    }
}

static void receivedSpeedLimit(JNIEnv /*env*/, jobject /*thiz*/, bool status,int value)
{
    if (QtAndroidService::instance() != nullptr) {
        emit QtAndroidService::instance()->speedLimit(status, value);
    }
}

static void receivedChargeModeStatus(JNIEnv *env, jobject /*thiz*/, jstring status)
{
    const QString statusQString = QtAndroidService::instance()->converToQstring(env, status);
    if (QtAndroidService::instance() != nullptr) {
        emit QtAndroidService::instance()->chargeModeStatus(statusQString);
    }
}

static void receivedPacosStatus(JNIEnv /*env*/, jobject /*thiz*/, bool status)
{
    if (QtAndroidService::instance() != nullptr) {
        emit QtAndroidService::instance()->pacosStatus(status);
    }
}

static void receivedGearInfo(JNIEnv *env, jobject /*thiz*/, jstring value)// dawi add
{
    qDebug() << "dawi_cpp_receivedGearInfo";
    const QString valueQString = QtAndroidService::instance()->converToQstring(env, value);
    if (QtAndroidService::instance() != nullptr) {
        qDebug() << "dawi_valueQString: " << valueQString << "\n--------------------\n";
        emit QtAndroidService::instance()->gearInfoFromService(valueQString);
    }
}

static void receivedOduTempValue(JNIEnv *env, jobject /*thiz*/, jstring value)// dawi add
{
    qDebug() << "dawi_cpp_receivedOduTempValue";
    const QString valueQString = QtAndroidService::instance()->converToQstring(env, value);
    if (QtAndroidService::instance() != nullptr) {
        qDebug() << "dawi_valueQString: " << valueQString << "\n--------------------\n";
        emit QtAndroidService::instance()->oduTempValueFromService(valueQString);
    }
}

static void receivedSpeedValue(JNIEnv *env, jobject /*thiz*/, jstring value)// dawi add
{
    qDebug() << "dawi_cpp_receivedSpeedValue";
    const QString valueQString = QtAndroidService::instance()->converToQstring(env, value);
    if (QtAndroidService::instance() != nullptr) {
        qDebug() << "dawi_valueQString: " << valueQString << "\n--------------------\n";
        emit QtAndroidService::instance()->speedValueFromService(valueQString);
    }
}

static void receivedSocValue(JNIEnv *env, jobject /*thiz*/, jstring value)// dawi add
{
    qDebug() << "dawi_cpp_receivedSocValue";
    const QString valueQString = QtAndroidService::instance()->converToQstring(env, value);
    if (QtAndroidService::instance() != nullptr) {
        qDebug() << "dawi_valueQString: " << valueQString << "\n--------------------\n";
        emit QtAndroidService::instance()->socValueFromService(valueQString);
    }
}

static void receivedDrivingMileage(JNIEnv *env, jobject /*thiz*/, jstring value)// dawi add
{
    qDebug() << "dawi_cpp_receivedDrivingMileage";
    const QString valueQString = QtAndroidService::instance()->converToQstring(env, value);
    if (QtAndroidService::instance() != nullptr) {
        qDebug() << "dawi_valueQString: " << valueQString << "\n--------------------\n";
        emit QtAndroidService::instance()->drivingMileageFromService(valueQString);
    }
}

// QtAndroidService class constructor
QtAndroidService::QtAndroidService(QObject *parent) : QObject(parent)
{
    m_instance = this;
    JNINativeMethod methods[] {
        {"sendToQt", "(Ljava/lang/String;)V", reinterpret_cast<void *>(receivedFromAndroidService)},
        {"sendToQtMediaInfo","(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",reinterpret_cast<void *>(receivedMediaInfo)},
        {"sendToQtSignalChange","(Ljava/lang/String;Ljava/lang/String;)V",reinterpret_cast<void *>(receivedSignalChange)},
        {"sendToQtMediaCurrPos","(I)V",reinterpret_cast<void *>(receivedMediaCurrPos)},
        {"sendToQtThumb","(Ljava/lang/String;)V",reinterpret_cast<void *>(receivedThumb)},
        {"sendToQtCleanMedia","()V",reinterpret_cast<void *>(cleanMeida)},
        {"sendToQtMusicVolume","(III)V",reinterpret_cast<void *>(musicVolume)},
        {"sendToQtDriverMode","(Ljava/lang/String;)V",reinterpret_cast<void *>(receivedDriveMode)},
        {"sendToQtKeyCode","(Ljava/lang/String;)V",reinterpret_cast<void *>(receivedKeyCode)},
        {"sendToQtKneoUserID","(Ljava/lang/String;)V",reinterpret_cast<void *>(receivedKneoUserName)},
        {"sendTripCards","(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",reinterpret_cast<void *>(receivedTripCards)},
        {"sendRadioInfo","(ILjava/lang/String;Ljava/lang/String;ZLjava/lang/String;)V",reinterpret_cast<void *>(receivedRadioInfo)},
        {"sendLimitSpeed","(ZI)V",reinterpret_cast<void *>(receivedSpeedLimit)},
        {"sendPacosStatus","(Z)V",reinterpret_cast<void *>(receivedPacosStatus)},
        {"sendChargeModeStatus","(Ljava/lang/String;)V",reinterpret_cast<void *>(receivedChargeModeStatus)},
        // dawi add
        {"sendGearInfoToQt", "(Ljava/lang/String;)V", reinterpret_cast<void *>(receivedGearInfo)},
        {"sendOduTempValueToQt","(Ljava/lang/String;)V",reinterpret_cast<void *>(receivedOduTempValue)},
        {"sendSpeedValueToQt","(Ljava/lang/String;)V",reinterpret_cast<void *>(receivedSpeedValue)},
        {"sendSocValueToQt","(Ljava/lang/String;)V",reinterpret_cast<void *>(receivedSocValue)},
        {"sendDrivingMileageValueToQt","(Ljava/lang/String;)V",reinterpret_cast<void *>(receivedDrivingMileage)},
    };
    int totalMethods = sizeof(methods)/sizeof(methods[0]);
    bool registerQJniEnvStatus = QtAndroidService::registerQJniEnv(methods, totalMethods);
    if(registerQJniEnvStatus == true){
        m_instance->sendToService("Qt");
    }
}

bool QtAndroidService::registerQJniEnv(const JNINativeMethod methods[], int totalMethods){
    // Create a QJniEnvironment to registe the registerNativeMethods.
    QJniEnvironment env;
    jclass clazz = env.findClass("com/foxconn/QtAndroidService");
    jint ret = env.registerNativeMethods(clazz, methods, totalMethods);
    // Check the Register QJNI and return the status.
    //qDebug()<< "ret: " << ret;
    if(ret > 0){
        qDebug()<< "registerQJniEnv(): Register success!\n----------\n";
        // Return the ret value after registering the JNI method
        return true;
    }else{
        qDebug()<< "registerQJniEnv(): Register failed.\n----------\n";
        return false;
    }
}

// Start service to invoke Android activity Internet
void QtAndroidService::sendToService(const QString &name)
{
    qDebug()<< "sendToService(): Start service to invoke Android activity Internet";
    Q_UNUSED(name);

    // 創建一個 Android Intent 物件以啟動指定的 Android 服務
    // Start Android service through JNI and deliver specific Intent
    auto activity = QJniObject(QNativeInterface::QAndroidApplication::context());
    QAndroidIntent serviceIntent(activity.object(), "com/foxconn/QtAndroidService");

    // 使用 Android 活動物件呼叫 Java 中的 startService 方法，
    // 並將 Intent 物件作為參數傳遞，以啟動指定的 Android 服務
    QJniObject result = activity.callObjectMethod(
        "startService",
        "(Landroid/content/Intent;)Landroid/content/ComponentName;",
        serviceIntent.handle().object());
}

// To convert the JString to the QString type, and return the QString variable.
QString QtAndroidService::converToQstring(JNIEnv *env, jstring inputJString){
    // Jstring type
    const char *valueJStr = env->GetStringUTFChars(inputJString, nullptr);

    // Convert it to QString type
    const QString valueQString = QString::fromUtf8(valueJStr);

    //qDebug() << "dawi_valueJStr: " << valueJStr << ", Type: " << typeid(valueJStr).name();
    //qDebug() << "dawi_valueQStr: " << valueQString << ", Type: " << typeid(valueQString).name() << "\n";

    // Release memory
    env->ReleaseStringUTFChars(inputJString, valueJStr);
    return valueQString;
}
