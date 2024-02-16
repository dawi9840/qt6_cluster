#include "qtandroidservice.h"

// Initialize static member variables outside the class
QtAndroidService *QtAndroidService::m_instance = nullptr;

// JNI static callback function
static void receivedFromAndroidService(JNIEnv *env, jobject thiz, jstring value)
{
    Q_UNUSED(env);
    Q_UNUSED(thiz);
    qDebug() << "dawi_cpp_receivedFromAndroidService";
    const char *valueStr = env->GetStringUTFChars(value, nullptr);
    //qDebug() << "dawi_valueStr: " << valueStr << ", Type: " << typeid(valueStr).name();

    // Convert it to QString type
    const QString valueQString = QString::fromUtf8(valueStr);
    qDebug() << "dawi_valueQString: " << valueStr << ", Type: " << typeid(valueQString).name() << "\n";

    // Check if instance() returns a valid pointer
    QtAndroidService *serviceInstance = QtAndroidService::instance();
    if (serviceInstance) {
        qDebug() << "[Instance is valid!]";
    } else {
        qDebug() << "[Instance is nullptr!]";
    }

    // Emit a signal to the QtAndroidService instance
    if (serviceInstance) {
        serviceInstance->receivedFromAndroidServiceSlot(valueQString);
    }

    // Release memory
    env->ReleaseStringUTFChars(value, valueStr);
}

// QtAndroidService class constructor
QtAndroidService::QtAndroidService(QObject *parent): QObject(parent)
{
    // Register JNI methods here to associate Java methods with C++ methods
    const JNINativeMethod methods[] =
        {
         {"sendToQt", "(Ljava/lang/String;)V", reinterpret_cast<void *>(receivedFromAndroidService)},
         };
    int totalMethods = sizeof(methods)/sizeof(methods[0]);
    qDebug() << "\n----------\ntotalMethods: " << totalMethods;

    // Create the signals and slots connection
    QtAndroidService::testConnectSignal();

    bool registerQJniEnvStatus = QtAndroidService::registerQJniEnv(methods, totalMethods);
    if(registerQJniEnvStatus == true){
        QtAndroidService::startServiceToInvokeAndroidInternet();
    }
}

// Register the QJNI env to map Java methods to C++ methods
bool QtAndroidService::registerQJniEnv(const JNINativeMethod methods[], int totalMethods){
    // Create a QJniEnvironment to registe the registerNativeMethods.
    QJniEnvironment env;
    jclass clazz = env.findClass("com/foxconn/QtAndroidService");
    jint ret = env.registerNativeMethods(clazz, methods, totalMethods);

    // Check the Register QJNI and return the status.
    qDebug()<< "ret: " << ret;
    if(ret > 0){
        qDebug()<< "QJniEnvironment: Register success!\n----------\n";
        // Return the ret value after registering the JNI method
        return true;
    }else{
        qDebug()<< "QJniEnvironment: Register failed.\n----------\n";
        return false;
    }
}

// Start Android service through JNI and deliver specific Intent
void QtAndroidService::startServiceToInvokeAndroidInternet(){
    auto activity = QJniObject(QNativeInterface::QAndroidApplication::context());
    QAndroidIntent serviceIntent(activity.object(), "com/foxconn/QtAndroidService");
    QJniObject result = activity.callObjectMethod(
        "startService",
        "(Landroid/content/Intent;)Landroid/content/ComponentName;",
        serviceIntent.handle().object());
}

// Create QObject connects for emiting signals and slots values to QML
void QtAndroidService::testConnectSignal(){
    // Connect received signal to your processing method
    QObject::connect(this, &QtAndroidService::messageFromService,
                     this, &QtAndroidService::receivedFromAndroidServiceSlot);

}

void QtAndroidService::receivedFromAndroidServiceSlot(const QString &message)
{
    // Emit signal to QML
    qDebug() << "Before emit signal";
    emit m_instance->messageFromService(message);
    qDebug() << "After emit signal\n----------\n";
}

void QtAndroidService::storeQmlInstance(){
    QtAndroidService::m_instance = this; // Set the m_instance to the current instance
}



