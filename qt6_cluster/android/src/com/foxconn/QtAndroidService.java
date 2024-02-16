package com.foxconn;

// 導入的 Android 相關庫
import android.content.Context;
import android.content.ComponentName;
import android.content.Intent;
import android.util.Log;
import android.app.Service;
import android.os.IBinder;
import android.os.Bundle;

// 用於與其他 Android 服務進行綁定的庫
import com.fxc.libCanWrapperNDK.IMyAidlInterface2;
import com.fxc.libCanWrapperNDK.ICanStCallback;
import android.os.RemoteException;
import android.content.ServiceConnection;

// 導入 Driver profile 相關庫
import com.fxc.ev.driverprofile.IDriverAidlInterface;
import com.fxc.ev.driverprofile.IDriverCallback;

// 導入其他自定義的庫
import android.net.Uri;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.content.IntentFilter;
import android.content.BroadcastReceiver;
import android.car.Car;
import android.car.media.CarAudioManager;
import android.text.TextUtils;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import com.fxc.ev.util.SystemPropUtil;

// 導入 Radio 相關庫
import android.hardware.radio.ProgramSelector;
import android.hardware.radio.RadioManager;
import android.hardware.radio.RadioMetadata;
import com.android.car.broadcastradio.support.Program;
import com.android.car.broadcastradio.support.platform.ProgramInfoExt;
import com.android.car.broadcastradio.support.platform.ProgramSelectorExt;

// import lookup CAN ID 相關庫
import com.foxconn.util.SignalCANInfo;
import com.foxconn.util.HexValueLookup;
import com.foxconn.util.SpecificCanIdDataset;
import com.foxconn.util.SignalReceiver;
import java.util.Queue;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

// import test case for QML 相關庫
import com.foxconn.util.SpecificSignalDatasetForQML;

public class QtAndroidService extends Service implements
        MediaPlaybackHandler.MediaPlaybackCallback{
    private static final String TAG = "QtAndroidService";

    /****** 用於向 Qt 發送相關信息的本機方法  ******/
    private static native void sendToQt(String message);                                           // 發送字串測試用方法
    private static native void sendToQtMediaInfo(String trackName, String artistName,
                                                 String albumName, String duration);               // 發送音樂信息方法
    private static native void sendToQtMediaCurrPos(int pos);                                      // 發送音樂當前播放位置方法
    private static native void sendToQtSignalChange(String iconID, String iconStatus);             // 發送信號變更方法
    private static native void sendToQtThumb(String thumbPath);                                    // 發送音樂封面的圖片路徑方法
    private static native void sendToQtMusicVolume(int currVolume, int maxVolume, int minVolume);  // 發送音樂音量方法
    private static native void sendToQtCleanMedia();                                               // 發送音樂清理信息方法
    private static native void sendToQtDriverMode(String mode);                                    // 發送行車模式變更的方法
    private static native void sendToQtKeyCode(String keycode);                                    // 發送按鍵控制的方法
    private static native void sendToQtKneoUserID(String userName);                                // 發送 Kneo 人臉辨識 UserID 方法
    private static native void sendTripCards(String odometer, String tripCardOne, String tripCardTwo); // 發送旅程卡信息方法
    private static native void sendRadioInfo(int curridx, String currTitle, String currFreq,
                                             boolean updateList, String radiolist);                // 發送電台信息方法
    private static native void sendLimitSpeed(boolean limitStatus,int speedValue);                 // 發送限速模式方法
    private static native void sendPacosStatus(boolean status);                                    // 發送安全氣囊信息(Pacos)方法
    private static native void sendChargeModeStatus(String mode);                                  // 發送充電模式狀態方法

    private static native void sendGearInfoToQt(String gearInfo);                                  // 發送 Gear P, R, N, D 方法
    private static native void sendOduTempValueToQt(String oduTempValue);                          // 發送室外溫度方法
    private static native void sendSpeedValueToQt(String speedValue);                              // 發送 speed value 方法
    private static native void sendSocValueToQt(String socValue);                                  // 發送電池電量方法
    private static native void sendDrivingMileageValueToQt(String drivingMileageValue);            // 發送可行駛里程方法
    /**************************************************************/

    private final boolean TEST_DEBUG = true;/*測試數據*/
    private boolean currentReset = false;
    private boolean lastChargeReset = false;
    private boolean tripAReset = false;
    private boolean tripBReset = false;

    private IMyAidlInterface2 iMyAidlInterface2;
    private IDriverAidlInterface iDriverAidlInterface;
    private MediaPlaybackHandler mediaPlaybackHandler;

    // 初始化 Car Audio 服務
    private CarAudioManager mCarAudioManager = null;
    private Car mCar;

    // 定義一個 IDriverCallback 來處理駕駛員數據的 Callback
    private IDriverCallback driverCallback = new IDriverCallback() {
        @Override
        public void onItemChangeCallback(String item) throws RemoteException {
            // Callback 處理不同類型的駕駛員數據變化
//            Log.i(TAG, "OnDriverCallback, item = " + item);
//            if (item.equals("All")) {
//                String speedLimit = iDriverAidlInterface.getDriverData("SpeedLimiting");
//                String passengerAirbagSwitch = iDriverAidlInterface.getDriverData("PACOS");/*Passenger Airbag Cut Off Switch */
//                setSpeedLimit(speedLimit);
//                setPACOS(passengerAirbagSwitch);
//            } else if (item.equals("SpeedLimiting")) {
//                String speedLimit = iDriverAidlInterface.getDriverData("SpeedLimiting");
//                setSpeedLimit(speedLimit);
//            } else if (item.equals("PACOS")) {
//                String passengerAirbagSwitch = iDriverAidlInterface.getDriverData("PACOS");/*Passenger Airbag Cut Off Switch */
//                setPACOS(passengerAirbagSwitch);
//            }
        }

        @Override
        public IBinder asBinder() {
            return null;
        }
    };

    serviceStartBroadcastReceiver mBroadcastReceiver = new serviceStartBroadcastReceiver();

    /********* 廣播操作 *********/
    private static final String DRIVER_MODE_CHANGE_ACTION = "ivi.broadcast.action.DRIVER_MODE";/*行車模式廣播*/
    private static final String DPAD_KEYEVENT = "ivi.broadcast.action.KeyEvent";/*接收鍵盤按鍵廣播*/
    private static final String KNEO_FACE_UNLOCK = "user_name_change";/*接收耐能解鎖成功廣播*/
    private static final String TRIP_MODE_CHANGE_ACTION = "broadcast.fxc.action.tripcardchange";/*旅程模式切換: 接收CSD更改旅程模式*/
    private static final String TRIP_MODE_RESETVALUE_ACTION = "broadcast.fxc.action.valuereset";/*旅程數值Reset: 接收CSD更改旅程模式*/
    private static final String EV_RADIO_PROGRAMS = "com.fxc.ev.radio.programs";/*接收CSD電台列表與當前播放電台*/
    private static final String SPEED_LIMIT_ACTION = "com.fxc.ev.speedlimit.status";/*限速模式通知ON/OFF*/
    private static final String CHARGE_MODE_CHANGE = "com.fxc.ev.broadcast.chargestatus";/*充電模式狀態*/
    /**************************************************************/
    // Define the receiving CAN series signals mode and table
    private static int selectMode = 3; // [3]: telltale, vehicle and DMS status.
    private static String[] canIdSignalsTable_;
    private static String[][] hexValueTable_;
    private static Map<String, String[]> correspondingTable_;

    // Define specific canSingal infos
    private static String idLowBeam;
    private static String idHighBeam;
    private static String idFrontFog;
    private static String idLeftDirection;
    private static String idRightDirection;
    private static String idRearFog;
    private static String idHazard;
    private static String idGearP;
    private static String idGearR;
    private static String idGearN;
    private static String idGearD;
    private static String idOduTemp;
    private static String idSpeed;
    private static String idSoc;
    private static String idDrivingMileage;
    private static String idYaw;
    private static String idPhoneCall;

    // Define specific canID
    private static String canID215;
    private static String canID217;
    private static String canID427;
    private static String canID403;

    // Define specific startBit
    private static String startBitFrontFog;
    private static String startBitLowBeam;
    private static String startBitHighBeam;
    private static String startBitRearFog;
    private static String startBitLeftDirection;
    private static String startBitRightDirection;
    private static String startBitHazard;
    private static String startBitSoc;
    private static String startBitDrivingMileage;

    // Define specific length
    private static String lengthSoc;
    private static String lengthDrivingMileage;

    // Define vehicle status
    private static String strSocValues;
    private static String strDmValues;
    private static String unit;
    private static double factor;
    private static double maximum;
    private static double minimum;
    private static int offset;

    // Define hexValueStatus
    private static String statusLightOn;
    private static String statusLightOff;
    private static String statusGearOn;
    private static String statusDmsOn;
    private static String statusDmsOff;
    private static String statusLedOn;
    private static String statusLedOff;

    // Define specific string enumerator for QML
    private static String qmlStatusLightOn;
    private static String qmlStatusLightOff;
    private static String qmlLowBeamLight;
    private static String qmlHighBeamLight;
    private static String qmlLeftDirectionLight;
    private static String qmlRightDirectionLight;
    private static String qmlHazardLight;
//    private static String qmlFrontFogLight;
//    private static String qmlRearFogLight;
    /**************************************************************/

    @Override
    public void onCreate() {
        super.onCreate();
        Log.i(TAG, "onCreate");
        initCanService();
        initCanService();
        initSpecificCanSeriesTable(); // dawi add
        initMediaPlaybackHandler();   // dawi add
        initDriverService();
        regBrocastReceiver();
        setCarAudioService();
        setTripInfo();

        //0:Test_a_message; 1:Telltale; 2:Vehicle_Status; 3:DMS;
        //testJavaSendValueToQML(1);
        //testJavaSendValueToQML(2);
        //testJavaSendValueToQML(3);

        // dawi_main
        //String receiveData = "54 02 01 07 00 00 04 00 00 00 00 00;54 02 01 05 00 00 00 00 00 08 00 00;54 04 02 07 00 10 00 00 00 00 00 00;54 01 09 09 00 00 04 00 00 00 00 00;54 04 00 0a 00 00 00 3F 00 00 00 00;54 03 02 02 00 00 00 00 0D 60 00 00;54 04 00 03 00 00 00 00 C8 00 00 00;54 04 00 03 00 00 C5 00 00 00 00 00;54 07 00 00 05 00 04 00 00 00 00 00;";
        //String receiveData ="54 03 02 02 00 00 00 00 0D E3 00 00"; // speed 100
        String receiveData = "54 04 00 0A 00 00 00 41 00 00 00 00";  // 25 degc
        processReceivedCanSignals(receiveData);

        String msg = "Hello_world_from_qt6_c++";
        testSendToQt(10, msg);
    }

    // Test case for Java sending the value to display on QML.
    private void testJavaSendValueToQML(int testCaseMode){
        Log.i(TAG, "dawi_testJavaSendValueToQML");
        switch (testCaseMode) {
            case 0: // test Message case
                testInvokingSendToQtLogOnQML("OwO_a_string"); // test send a message
                break;
            case 1: // test Telltale case: 0~6
                testInvokingTelltaleSignalsToDisplayOnQML(0); // test 近光燈 on, off, on
//                    testInvokingTelltaleSignalsToDisplayOnQML(1); // test 遠光燈 on, off, on
//                    testInvokingTelltaleSignalsToDisplayOnQML(2); // test 前霧燈 on, off, on
//                    testInvokingTelltaleSignalsToDisplayOnQML(3); // test 左方向燈(頭、尾) on, off, on
//                    testInvokingTelltaleSignalsToDisplayOnQML(4); // test 右方向燈(頭、尾) on, off, on
//                    testInvokingTelltaleSignalsToDisplayOnQML(5); // test 後霧燈 on, off, on
//                    testInvokingTelltaleSignalsToDisplayOnQML(6); // test HAZARD on, off, on
                break;
            case 2: // test Vehicle Status case: 0~4
                testInvokingVehicleStatusToDisplayOnQML(0);   // test PRND: D
                testInvokingVehicleStatusToDisplayOnQML(1);   // test ODU temp
                testInvokingVehicleStatusToDisplayOnQML(2);   // test speed
                testInvokingVehicleStatusToDisplayOnQML(3);   // test soc
                testInvokingVehicleStatusToDisplayOnQML(4);   // test driving mileage
                break;
            case 3: // test DMS case: 0~1
                testInvokingDmsAleartToDisplayOnQML(0);       // test Yaw on, off, on
                //testInvokingDmsAleartToDisplayOnQML(1);       // test PhoneCall on, off, on
                break;
        }
    }

    private void setCarAudioService() {/* 設置 Car Audio 服務 */
        mCar = Car.createCar(this);
        Log.i(TAG, "set Car AudioManager");
        mCarAudioManager = (CarAudioManager) mCar.getCarManager(Car.AUDIO_SERVICE);
        if(mCarAudioManager != null) {
            Log.i(TAG, "registerCarVolumeCallback");
            mCarAudioManager.registerCarVolumeCallback(mCarVolumeCallback);
        } else {
            Log.i(TAG, "mCarAudioManager == null");
        }
    }

    private CarAudioManager.CarVolumeCallback mCarVolumeCallback = new CarAudioManager.CarVolumeCallback(){
        @Override
        public void onGroupVolumeChanged(int zoneId, int groupId, int flags) {
            super.onGroupVolumeChanged(zoneId, groupId, flags);
            int maxvolume = mCarAudioManager.getGroupMaxVolume(zoneId,groupId);
            int minVolume = mCarAudioManager.getGroupMinVolume(zoneId,groupId);
            int currVolume = mCarAudioManager.getGroupVolume(zoneId,groupId);
            Log.i(TAG, "GroupMaxVolume = " + maxvolume);
            Log.i(TAG, "GroupMinVolume = " + minVolume);
            Log.i(TAG, "GroupVolume = " + currVolume);
            sendToQtMusicVolume(currVolume,maxvolume,minVolume);
        }

        @Override
        public void onMasterMuteChanged(int zoneId, int flags) {
            super.onMasterMuteChanged(zoneId, flags);
            Log.i(TAG, "onMasterMuteChanged");
            Log.i(TAG, "zoneId = " + zoneId);
            Log.i(TAG, "flags = " + flags);
        }
    };

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.i(TAG, "Destroying Service");
        unregisterReceiver(mBroadcastReceiver);
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private void initCanService(){
        Log.d(TAG, "initCanService");
        Intent intent = new Intent();
        intent.setPackage("com.fxc.libCanWrapperNDK");
        intent.setAction("com.fxc.libCanWrapperNDK.MyService");
        bindService(intent, connCanService, Context.BIND_AUTO_CREATE);
        Log.d(TAG, "bindService");
    }

    public static void initSpecificCanSeriesTable(){
        // Extract the receiving CAN series signals mode and table
        canIdSignalsTable_ = SpecificCanIdDataset.getSpecificCanIdDatasets(selectMode);
        hexValueTable_ = HexValueLookup.gethexValueTable(selectMode);
        correspondingTable_ = HexValueLookup.getCorrespondingTable(canIdSignalsTable_, hexValueTable_, selectMode);

        // Extract specific canSingal infos from canIdSignalsTable.
        idLowBeam = canIdSignalsTable_[0];         // "0x217, 18, 1",  // 0.Low beam (on/off)
        idHighBeam = canIdSignalsTable_[1];        // "0x217, 17, 1",  // 1.High beam (on/off)
        idFrontFog = canIdSignalsTable_[2];        // "0x215, 43, 1",  // 2.Front fog lamp (on/off)
        idRearFog = canIdSignalsTable_[5];         // "0x217, 41, 1",  // 5.Rear fog light (on/off)
        idLeftDirection = canIdSignalsTable_[3];   // "0x427, 13, 2",  // 3.Left direction light (on/off)
        idRightDirection = canIdSignalsTable_[4];  // "0x427, 11, 2",  // 4.Right direction light (on/off)
        idHazard = canIdSignalsTable_[6];          // "0x427, 42, 2",  // 6.Warning light HAZARD (on/off)
        idSoc = canIdSignalsTable_[13];            // "0x403, 23, 8",  // 13.Battery level SOC
        idDrivingMileage = canIdSignalsTable_[14]; // "0x403, 25, 10", // 14.Driving mileage

        idGearP = canIdSignalsTable_[7];           // "0x199, 13, 2",  // 7.PRND_P Park light
        idGearR = canIdSignalsTable_[8];           // "0x199, 15, 2",  // 8.PRND_R Reverse light
        idGearN = canIdSignalsTable_[9];           // "0x199, 17, 2",  // 9.PRND_N Neutral light
        idGearD = canIdSignalsTable_[10];          // "0x199, 19, 2",  // 10.PRND_D Drive light
        idOduTemp = canIdSignalsTable_[11];        // "0x40A, 31, 8",  // 11.Outdoor temperature
        idSpeed = canIdSignalsTable_[12];          // "0x322, 39, 13", // 12.Speed
        idYaw = canIdSignalsTable_[15];            // "0x700, 18, 1",  // 15.Yaw
        idPhoneCall = canIdSignalsTable_[16];      // "0x700, 19, 1",  // 16.PhoneCall

        // Extract specific canID
        canID217= SignalCANInfo.getCanSpecificCanId(idLowBeam);        // 0x217
        canID427 = SignalCANInfo.getCanSpecificCanId(idLeftDirection); // 0x427
        canID403 = SignalCANInfo.getCanSpecificCanId(idSoc);           // 0x403
        canID215 = SignalCANInfo.getCanSpecificCanId(idFrontFog);      // 0x215

        // Extract specific startBit
        startBitLowBeam = SignalCANInfo.getCanSpecificStartBit(idLowBeam);                // 18
        startBitHighBeam = SignalCANInfo.getCanSpecificStartBit(idHighBeam);              // 17
        startBitLeftDirection = SignalCANInfo.getCanSpecificStartBit(idLeftDirection);    // 13
        startBitRightDirection = SignalCANInfo.getCanSpecificStartBit(idRightDirection);  // 11
        startBitHazard = SignalCANInfo.getCanSpecificStartBit(idHazard);                  // 42
        startBitSoc = SignalCANInfo.getCanSpecificStartBit(idSoc);                        // 23
        startBitDrivingMileage = SignalCANInfo.getCanSpecificStartBit(idDrivingMileage);  // 25
        startBitFrontFog = SignalCANInfo.getCanSpecificStartBit(idFrontFog);              // 43
        startBitRearFog = SignalCANInfo.getCanSpecificStartBit(idRearFog);                // 41

        // Extract specific length
        lengthSoc = SignalCANInfo.getCanSpecificLength(idSoc);                            // 8
        lengthDrivingMileage =SignalCANInfo.getCanSpecificLength(idDrivingMileage);       // 10

        // Vehicle status
        strSocValues = "";
        strDmValues = "";
        unit = "";
        factor = 0;
        maximum = 0;
        minimum = 0;
        offset = 0;

        // Extract hexValueStatus
        statusLightOn = hexValueTable_[0][0];      // 0x1=On, Telltale Status: on status
        statusLightOff = hexValueTable_[0][1];     // 0x0=Off, Telltale Status: off status
        statusLedOn = hexValueTable_[7][2];        // 0x1=LED On, For 0x427 light on status
        statusLedOff = hexValueTable_[7][3];       // 0x0=LED Off, For 0x427 light off status
        statusGearOn = hexValueTable_[1][2];       // 0x1=Switch Pressed, For Gear on status
        statusDmsOn = hexValueTable_[6][0];        // 0x1=Alarm
        statusDmsOff = hexValueTable_[6][1];       // 0x0=NotAlarm

        // send the specific string enumerator for QML
        qmlLowBeamLight = SpecificSignalDatasetForQML.testGetSpecificSignal(0, 0);         // Low_Beam_Light
        qmlHighBeamLight = SpecificSignalDatasetForQML.testGetSpecificSignal(0, 1);        // High_Beam_Light
        qmlLeftDirectionLight = SpecificSignalDatasetForQML.testGetSpecificSignal(0, 3);   // Direction_Light_Left
        qmlRightDirectionLight = SpecificSignalDatasetForQML.testGetSpecificSignal(0, 4);  // Direction_Light_Right
        qmlHazardLight = SpecificSignalDatasetForQML.testGetSpecificSignal(0, 6);          // Warning_Light_HAZARD
//        qmlFrontFogLight = SpecificSignalDatasetForQML.testGetSpecificSignal(0, 2);        // Fog_Light_Front
//        qmlRearFogLight = SpecificSignalDatasetForQML.testGetSpecificSignal(0, 5);         // Fog_Light_Rear

        qmlStatusLightOn = SpecificSignalDatasetForQML.testGetLightStatus(0);              // Opened
        qmlStatusLightOff = SpecificSignalDatasetForQML.testGetLightStatus(1);             // Closed

        // Default to turn on the Daytime Running Light
        invokeSendToQtSignalChange(qmlLowBeamLight, qmlStatusLightOn);
        invokeSendToQtSignalChange(qmlHighBeamLight, qmlStatusLightOff);
    }

    // 用於處理 Can Server 的連接和斷開
    private ServiceConnection connCanService = new ServiceConnection() {

        @Override
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            // Can 服務連接成功時的處理
            Log.d(TAG, "CanService onServiceConnected");
            iMyAidlInterface2 = IMyAidlInterface2.Stub.asInterface(iBinder);

            try {
                Log.d(TAG, "CanService registerCallback");
                iMyAidlInterface2.registerNotifyCallback(mICanStCallback);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {
            // Can 服務斷開連接時的處理
            try {
                if(iMyAidlInterface2 != null)
                    iMyAidlInterface2.unregisterNotifyCallback(mICanStCallback);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
            iMyAidlInterface2 = null;
            Log.i(TAG, "CanService iMyAidlInterface2 Disconnected");
        }
    };

    // 用於處理 Can Server 的 Callback
    private ICanStCallback mICanStCallback = new ICanStCallback.Stub() {
        @Override
        public void onCallback(String aString) throws RemoteException {
            //Log.d(TAG, "dawi_mICanStCallback: " + aString);
            processReceivedCanSignals(aString);
        }
    };

    private void processReceivedCanSignals(String aString) {
        Log.d(TAG, "dawi_processReceivedCanSignals");
        Log.d(TAG, "Input string: " + aString + "\n");

        String lowBeanLightStatus = "";
        String highBeanLightStatus = "";
        String leftDirectionLightStatus = "";
        String rightDirectionLightStatus = "";
        String hazardLightStatus = "";
        String socStatus = "";
        String drivingMileageStatus = "";
        String[] dataSets = aString.split(";");

        for (String dataSet : dataSets) {
            // Log.d(TAG, "length: " + receivedData.length());
            // Log.d(TAG, "dataSet: " + dataSet);
            if(dataSet.length() >= 35){
                String[] signalData = SignalCANInfo.parseSignalData(dataSet);
                Log.d(TAG, "InputCanID: " + signalData[1]);
                Log.d(TAG, "InputCanData: " + signalData[2]);

                for(int i=0; i<canIdSignalsTable_.length; i++){
                    String[] specificIDParts = canIdSignalsTable_[i].split(", ");
                    String myCanID = specificIDParts[0];
                    String myStartBit = specificIDParts[1];
                    String myLength = specificIDParts[2];
                    Log.d(TAG, i + ", myCanID: " + myCanID + "\n");
                    // Log.d(TAG, "InputCanID: " + signalData[1] + "\n");

                    String hexValue = SignalCANInfo.getHexValue(canIdSignalsTable_[i], signalData);

                    if(socAndtDrivingMileageCondition(signalData, myCanID, myStartBit)){
                        // Log.d(TAG,( i + "0x403_(myCanID, myStartBit): (" + myCanID + ", " + myStartBit + ")");

                        if(myStartBit.equals(startBitSoc) && myLength.equals(lengthSoc)){
                            socStatus = HexValueLookup.getHexValueStatus(canIdSignalsTable_[i], hexValue, correspondingTable_);
                            Log.d(TAG, "socStatus: " + socStatus);
                            if(!socStatus.equals(hexValueTable_[4][0]) && !socStatus.equals(hexValueTable_[4][1])) {
                                factor = 0.4;
                                maximum = 100;
                                minimum = 0;
                                unit = " %";
                                int socValues = (int)Math.round(SignalCANInfo.convertHexValueToDecimalValue(hexValue)*factor);
                                if(socValues>minimum && socValues<=maximum){
                                    strSocValues = String.valueOf(socValues);
                                    invokeSendingSocValueToQt(strSocValues);
                                    Log.d(TAG, "SOC: " + strSocValues + unit);
                                }
                            }
                        }else if(myStartBit.equals(startBitDrivingMileage) && myLength.equals(lengthDrivingMileage)){
                            drivingMileageStatus = HexValueLookup.getHexValueStatus(canIdSignalsTable_[i], hexValue, correspondingTable_);
                            Log.d(TAG, "drivingMileageStatus: " + drivingMileageStatus);
                            if(!drivingMileageStatus.equals(hexValueTable_[5][0]) && !drivingMileageStatus.equals(hexValueTable_[5][1])) {
                                factor = 1;
                                maximum = 1023;
                                minimum = 0;
                                unit = " km";
                                int dmValues = (int)Math.round(SignalCANInfo.convertHexValueToDecimalValue(hexValue)*factor);
                                if(dmValues>minimum && dmValues<=maximum){
                                    strDmValues = String.valueOf(dmValues);
                                    invokeSendingdrivingMileageValueToQt(strDmValues);
                                    Log.d(TAG, "Driving mileage: " + strDmValues + unit);
                                }
                            }
                        }else{//exception
                            Log.d(TAG, "SOC and DM status exception");
                        }

                    }else if(LeftAndRightDirectionAndHazardCondition(signalData, myCanID, myStartBit)){
                        // Log.d(TAG,  i + "0x427_(myCanID, myStartBit): (" + myCanID + ", " + myStartBit + ")");

                        // Caculate hexValueStatus of low/hight direction, and hazard light status.
                        if(myStartBit.equals(startBitLeftDirection)){
                            leftDirectionLightStatus = HexValueLookup.getHexValueStatus(canIdSignalsTable_[i], hexValue, correspondingTable_);
                            Log.d(TAG, "leftDirectionLightStatus: " + leftDirectionLightStatus);
                        }else if(myStartBit.equals(startBitRightDirection)){
                            rightDirectionLightStatus = HexValueLookup.getHexValueStatus(canIdSignalsTable_[i], hexValue, correspondingTable_);
                            Log.d(TAG,"rightDirectionLightStatus: " + rightDirectionLightStatus);
                        }else if(myStartBit.equals(startBitHazard)){
                            hazardLightStatus = HexValueLookup.getHexValueStatus(canIdSignalsTable_[i], hexValue, correspondingTable_);
                            Log.d(TAG,"hazardLightStatus: " + hazardLightStatus);
                        }else{//exception
                            Log.d(TAG,"left/right and hazard status exception");
                        }
                        sendLRDirectionAndHazardLightsToQML(leftDirectionLightStatus, rightDirectionLightStatus, hazardLightStatus);

                    }else if(lowBeamAndHighBeamLightsCondition(signalData, myCanID, myStartBit)){
                        //Log.d(TAG,  i + "0x217_(myCanID, myStartBit): (" + myCanID + ", " + myStartBit + ")");

                        // Caculate hexValueStatus of low/hight beam light status.
                        if(myStartBit.equals(startBitLowBeam)){// low beam
                            lowBeanLightStatus = HexValueLookup.getHexValueStatus(canIdSignalsTable_[i], hexValue, correspondingTable_);
                            Log.d(TAG, "lowBeanLightStatus: " + lowBeanLightStatus);
                        }else if(myStartBit.equals(startBitHighBeam)){// high beam
                            highBeanLightStatus = HexValueLookup.getHexValueStatus(canIdSignalsTable_[i], hexValue, correspondingTable_);
                            Log.d(TAG,"highBeanLightStatus: " + highBeanLightStatus);
                        }else{//exception
                            Log.d(TAG,"low/high beam status exception");
                        }
                        sendLowAndHighBeamLightsToQML(lowBeanLightStatus, highBeanLightStatus);

                    }else if(signalData[1].equals(myCanID)){
                        // Log.d(TAG, "dawi test other canID block");
                        Log.d(TAG, "\nInputCanID: " + signalData[1]);
                        Log.d(TAG, "InputCanData: " + signalData[2]);
                        Log.d(TAG, i + " , (myCanID, myStartBit, myLength): (" +
                                           myCanID + ", " + myStartBit + ", " + myLength + ")");

                        String hexValueStatus = HexValueLookup.getHexValueStatus(canIdSignalsTable_[i], hexValue, correspondingTable_);

                        if(!hexValue.isEmpty()){
                            Log.d(TAG, "hexValue: " + hexValue);
                            Log.d(TAG, "hexValueStatus: " + hexValueStatus);
                            separateFogLampSignals(canIdSignalsTable_[i], hexValueStatus);
                            separateGearSignals(canIdSignalsTable_[i], hexValueStatus);
                            separateVehicleStatusSignals(canIdSignalsTable_[i], hexValue, hexValueStatus);
                            separateDmsSignals(canIdSignalsTable_[i], hexValueStatus);
                        }
                    }
                }
            }else{
                Log.d(TAG, "Input data length less than 35 Unicode characters!");
                Log.d(TAG, "dataSet: " + dataSet);
                Log.d(TAG, "dataSet.lenght(): " + dataSet.length());
            }
        }
    }

    private static boolean socAndtDrivingMileageCondition(String[] signalData, String myCanID, String myStartBit){
        return signalData[1].equals(canID403) &&
                ((myCanID.equals(canID403) && myStartBit.equals(startBitSoc)) ||
                (myCanID.equals(canID403) && myStartBit.equals(startBitDrivingMileage)));
    }

    private static boolean lowBeamAndHighBeamLightsCondition(String[] signalData, String myCanID, String myStartBit){
        return signalData[1].equals(canID217) &&
                ((myCanID.equals(canID217) && myStartBit.equals(startBitLowBeam)) ||
                (myCanID.equals(canID217) && myStartBit.equals(startBitHighBeam)));
    }

    private static boolean LeftAndRightDirectionAndHazardCondition(String[] signalData, String myCanID, String myStartBit){
        return signalData[1].equals(canID427) &&
                ((myCanID.equals(canID427) && myStartBit.equals(startBitLeftDirection)) ||
                (myCanID.equals(canID427) && myStartBit.equals(startBitRightDirection)) ||
                (myCanID.equals(canID427) && myStartBit.equals(startBitHazard)));
    }

    private static void sendLRDirectionAndHazardLightsToQML(String leftDirectionLightStatus,
                                                            String rightDirectionLightStatus,
                                                            String hazardLightStatus){
        // Using hexValueStatus to send command to QML.
        if(leftDirectionLightStatus.equals(statusLedOn)){
            invokeSendToQtSignalChange(qmlRightDirectionLight, qmlStatusLightOff);
            invokeSendToQtSignalChange(qmlLeftDirectionLight, qmlStatusLightOn);
            Log.d(TAG, qmlLeftDirectionLight + " is " + qmlStatusLightOn + "!");
        }else if(rightDirectionLightStatus.equals(statusLedOn)){
            invokeSendToQtSignalChange(qmlLeftDirectionLight, qmlStatusLightOff);
            invokeSendToQtSignalChange(qmlRightDirectionLight, qmlStatusLightOn);
            Log.d(TAG, qmlRightDirectionLight + " is " + qmlStatusLightOn + "!");
        }else if(hazardLightStatus.equals(statusLedOn)){
            invokeSendToQtSignalChange(qmlLeftDirectionLight, qmlStatusLightOff);
            invokeSendToQtSignalChange(qmlRightDirectionLight, qmlStatusLightOff);
            invokeSendToQtSignalChange(qmlHazardLight, qmlStatusLightOn);
            Log.d(TAG, qmlHazardLight + " is " + qmlStatusLightOn + "!\n");
        }else{
            invokeSendToQtSignalChange(qmlHazardLight, qmlStatusLightOff);
            Log.d(TAG, "All " + qmlLowBeamLight + " ," +
            qmlHighBeamLight + " ,and " +qmlHazardLight+ " are " + qmlStatusLightOff + "!");
        }
    }

    private static void sendLowAndHighBeamLightsToQML(String lowBeanLightStatus,
                                                       String highBeanLightStatus){
        /*// 2024.01.17_version
        if(lowBeanLightStatus.equals(statusLightOn)) {
            invokeSendToQtSignalChange(qmlHighBeamLight, qmlStatusLightOff);
            invokeSendToQtSignalChange(qmlLowBeamLight, qmlStatusLightOn);
            Log.d(TAG, qmlLowBeamLight + " is " + qmlStatusLightOn + "!");
        }else if(highBeanLightStatus.equals(statusLightOn)) {
            invokeSendToQtSignalChange(qmlLowBeamLight, qmlStatusLightOn);
            invokeSendToQtSignalChange(qmlHighBeamLight, qmlStatusLightOn);
            Log.d(TAG, qmlHighBeamLight + " is " + qmlStatusLightOn + "!");
        }else{
            invokeSendToQtSignalChange(qmlLowBeamLight, qmlStatusLightOn);
            invokeSendToQtSignalChange(qmlHighBeamLight, qmlStatusLightOff);
            Log.d(TAG, "Both " + qmlLowBeamLight + " and " + qmlHighBeamLight + " are " + qmlStatusLightOff + "!\n");
        }*/

        // 2024.01.29_version
        if(lowBeanLightStatus.equals(statusLightOn)) {
            invokeSendToQtSignalChange(qmlHighBeamLight, qmlStatusLightOff);
            invokeSendToQtSignalChange(qmlLowBeamLight, qmlStatusLightOn);
            Log.d(TAG, qmlLowBeamLight + " is " + qmlStatusLightOn + "!");
        }else if(highBeanLightStatus.equals(statusLightOn)) {
            invokeSendToQtSignalChange(qmlLowBeamLight, qmlStatusLightOn);
            invokeSendToQtSignalChange(qmlHighBeamLight, qmlStatusLightOn);
            Log.d(TAG, qmlHighBeamLight + " is " + qmlStatusLightOn + "!");
        }else{
            invokeSendToQtSignalChange(qmlLowBeamLight, qmlStatusLightOff); //0129add
            invokeSendToQtSignalChange(qmlHighBeamLight, qmlStatusLightOff);
            Log.d(TAG, "Both " + qmlLowBeamLight + " and " + qmlHighBeamLight + " are " + qmlStatusLightOff + "!\n");
        }
    }

    private static void separateFogLampSignals(String specificID, String hexValueStatus){
        String telltaleLight = "";
        String telltaleStatus = "";

        Log.d(TAG, "dawi_sseparateFogLampSignals-------------");
        // Log.d(TAG, "Input specificID: " + specificID);
        // Log.d(TAG, "Input hexValueStatus: " + hexValueStatus);

        // 2.Front fog lamp (on/off), head and tail lights are the same CAN ID
        if(specificID.equals(idFrontFog) && hexValueStatus.equals(statusLightOn)){
            telltaleLight = SpecificSignalDatasetForQML.testGetSpecificSignal(0, 2);
            telltaleStatus = SpecificSignalDatasetForQML.testGetLightStatus(0);
            invokeSendToQtSignalChange(telltaleLight, telltaleStatus);
        }
        if(specificID.equals(idFrontFog) && hexValueStatus.equals(statusLightOff)){
            telltaleLight = SpecificSignalDatasetForQML.testGetSpecificSignal(0, 2);
            telltaleStatus = SpecificSignalDatasetForQML.testGetLightStatus(1);
            invokeSendToQtSignalChange(telltaleLight, telltaleStatus);
        }

        // 5.Rear fog light (on/off)
        if(specificID.equals(idRearFog) && hexValueStatus.equals(statusLightOn)){
            telltaleLight = SpecificSignalDatasetForQML.testGetSpecificSignal(0, 5);
            telltaleStatus = SpecificSignalDatasetForQML.testGetLightStatus(0);
            invokeSendToQtSignalChange(telltaleLight, telltaleStatus);
        }
        if(specificID.equals(idRearFog) && hexValueStatus.equals(statusLightOff)){
            telltaleLight = SpecificSignalDatasetForQML.testGetSpecificSignal(0, 5);
            telltaleStatus = SpecificSignalDatasetForQML.testGetLightStatus(1);
            invokeSendToQtSignalChange(telltaleLight, telltaleStatus);
        }

        if(!telltaleLight.equals("") && !telltaleStatus.equals("")){
            Log.d(TAG, "Input specificID: " + specificID);
        }
        Log.d(TAG, "\n-----------------------------------------------------\n");
    }

    private static void separateGearSignals(String specificID, String hexValueStatus){
        String gearValue = "";

        Log.d(TAG, "dawi_separateGearSignals-------------\n");
        // Log.d(TAG, "Input specificID: "+ specificID);
        // Log.d(TAG, "Input hexValueStatus: "+ hexValueStatus + "\n\n");

        if(specificID.equals(idGearP) && hexValueStatus.equals(statusGearOn)){/* 7.PRND_P Park light */
            gearValue = SpecificSignalDatasetForQML.testGetSpecificSignal(1, 0); //{1:0-3}
            invokeSendingGearInfoToQt(gearValue);
        }else if(specificID.equals(idGearR) && hexValueStatus.equals(statusGearOn)){/* 8.PRND_R Reverse light */
            gearValue = SpecificSignalDatasetForQML.testGetSpecificSignal(1, 1); //{1:0-3}
            invokeSendingGearInfoToQt(gearValue);
        }else if(specificID.equals(idGearN) && hexValueStatus.equals(statusGearOn)){/* 9.PRND_N Neutral light */
            gearValue = SpecificSignalDatasetForQML.testGetSpecificSignal(1, 2); //{1:0-3}
            invokeSendingGearInfoToQt(gearValue);
        }else if(specificID.equals(idGearD) && hexValueStatus.equals(statusGearOn)){/* 10.PRND_D Drive light */
            gearValue = SpecificSignalDatasetForQML.testGetSpecificSignal(1, 3); //{1:0-3}
            invokeSendingGearInfoToQt(gearValue);
        }else if(!gearValue.equals("")){
            Log.d(TAG, "Input specificID: "+ specificID);
        }
        Log.d(TAG, "\n-----------------------------------------------------\n");
    }

    private static void separateVehicleStatusSignals(String specificID, String hexValue, String hexValueStatus){
        Log.d(TAG, "separateVehicleStatusSignals start");
        String strOduValues = "";
        String strSpeedValues = "";
        int initValue = 0;

/*
        String strSocValues = "";
        String strDmValues = "";

        String unit = "";
        double factor = 0;
        int maximum = 0;
        int minimum = 0;
        int offset = 0;
*/

        Log.d(TAG, "dawi_separateVehicleStatusSignals-------------");
        // Log.d(TAG, "Input specificID: " + specificID);
        // Log.d(TAG, "Input hexValue: " + hexValue);
        // Log.d(TAG, "Input hexValueStatus: " + hexValueStatus);

        /* 11.Outdoor temperature */
        if(specificID.equals(idOduTemp) &&
           !hexValueStatus.equals(statusLightOn) && !hexValueStatus.equals(statusLightOff) &&
           !hexValueStatus.equals(hexValueTable_[1][0]) && !hexValueStatus.equals(hexValueTable_[1][1]) &&
           !hexValueStatus.equals(hexValueTable_[2][0]) && !hexValueStatus.equals(hexValueTable_[2][1]) &&
           !hexValueStatus.equals(hexValueTable_[3][0]) && !hexValueStatus.equals(hexValueTable_[3][1]) &&
           !hexValueStatus.equals(hexValueTable_[4][0]) && !hexValueStatus.equals(hexValueTable_[4][1]) &&
           !hexValueStatus.equals(hexValueTable_[5][0]) && !hexValueStatus.equals(hexValueTable_[5][1]) &&
           !hexValueStatus.equals(statusDmsOn) && !hexValueStatus.equals(statusDmsOff)
           ){
            factor = 1;
            maximum = 213;
            minimum = -40;
            offset = -40;
            unit = " degC";
            int oduValues = (int)Math.round(SignalCANInfo.convertHexValueToDecimalValue(hexValue)*factor + offset);
            Log.d(TAG,"oduValues = " + oduValues);
            if(oduValues>=minimum && oduValues<=maximum){
                strOduValues = String.valueOf(oduValues);
                Log.d(TAG, "dawi_java_ODU: " + strOduValues + unit);
                invokeSendingOduTempToQt(strOduValues);
            }
        }

        /* 12.Speed */
        if(specificID.equals(idSpeed) &&
           !hexValueStatus.equals(statusLightOn) && !hexValueStatus.equals(statusLightOff) &&
           !hexValueStatus.equals(hexValueTable_[1][0]) && !hexValueStatus.equals(hexValueTable_[1][1]) &&
           !hexValueStatus.equals(hexValueTable_[2][0]) && !hexValueStatus.equals(hexValueTable_[2][1]) &&
           !hexValueStatus.equals(hexValueTable_[3][0]) && !hexValueStatus.equals(hexValueTable_[3][1]) &&
           !hexValueStatus.equals(hexValueTable_[4][0]) && !hexValueStatus.equals(hexValueTable_[4][1]) &&
           !hexValueStatus.equals(hexValueTable_[5][0]) && !hexValueStatus.equals(hexValueTable_[5][1]) &&
           !hexValueStatus.equals(statusDmsOn) && !hexValueStatus.equals(statusDmsOff)
           ){
            factor = 0.05625;
            maximum = 240;   //240
            minimum = 0;     //-100
            initValue = -100;
            unit = " km/h";
            int speedValues = (int)Math.round(SignalCANInfo.convertHexValueToDecimalValue(hexValue)*factor + initValue);
            if(speedValues>=minimum && speedValues<=maximum){
                strSpeedValues = String.valueOf(speedValues);
                Log.d(TAG, "dawi_java_Speed: " + strSpeedValues + unit);
                invokeSendingSpeedValueToQt(strSpeedValues);
            }
        }
/*
        // 13.Battery level SOC
        if(specificID.equals(idSoc) &&
           !hexValueStatus.equals(statusLightOn) && !hexValueStatus.equals(statusLightOff) &&
           !hexValueStatus.equals(hexValueTable_[1][0]) && !hexValueStatus.equals(hexValueTable_[1][1]) &&
           !hexValueStatus.equals(hexValueTable_[2][0]) && !hexValueStatus.equals(hexValueTable_[2][1]) &&
           !hexValueStatus.equals(hexValueTable_[3][0]) && !hexValueStatus.equals(hexValueTable_[3][1]) &&
           !hexValueStatus.equals(hexValueTable_[4][0]) && !hexValueStatus.equals(hexValueTable_[4][1]) &&
           !hexValueStatus.equals(hexValueTable_[5][0]) && !hexValueStatus.equals(hexValueTable_[5][1]) &&
           !hexValueStatus.equals(statusDmsOn) && !hexValueStatus.equals(statusDmsOff)
           ){
            factor = 0.4;
            maximum = 100;
            minimum = 0;
            unit = " %";
            int socValues = (int)Math.round(SignalCANInfo.convertHexValueToDecimalValue(hexValue)*factor);
            if(socValues>minimum && socValues<=maximum){
                strSocValues = String.valueOf(socValues);
                Log.d(TAG, "dawi_java_SOC: " + strSocValues + unit);
                invokeSendingSocValueToQt(strSocValues);
            }
        }

        // 14.Driving mileage
        if(specificID.equals(idDrivingMileage) &&
           !hexValueStatus.equals(statusLightOn) && !hexValueStatus.equals(statusLightOff) &&
           !hexValueStatus.equals(hexValueTable_[1][0]) && !hexValueStatus.equals(hexValueTable_[1][1]) &&
           !hexValueStatus.equals(hexValueTable_[2][0]) && !hexValueStatus.equals(hexValueTable_[2][1]) &&
           !hexValueStatus.equals(hexValueTable_[3][0]) && !hexValueStatus.equals(hexValueTable_[3][1]) &&
           !hexValueStatus.equals(hexValueTable_[4][0]) && !hexValueStatus.equals(hexValueTable_[4][1]) &&
           !hexValueStatus.equals(hexValueTable_[5][0]) && !hexValueStatus.equals(hexValueTable_[5][1]) &&
           !hexValueStatus.equals(statusDmsOn) && !hexValueStatus.equals(statusDmsOff)
        ){
            factor = 1;
            maximum = 1023;
            minimum = 0;
            unit = " km";
            int dmValues = (int)Math.round(SignalCANInfo.convertHexValueToDecimalValue(hexValue)*factor);
            if(dmValues>=minimum && dmValues<=maximum){
                strDmValues = String.valueOf(dmValues);
                Log.d(TAG, "Driving mileage: " + strDmValues + unit);
                invokeSendingdrivingMileageValueToQt(strDmValues);
            }
        }
*/
        if(!strOduValues.equals("") && !strSpeedValues.equals("") &&
           !strSocValues.equals("") && !strDmValues.equals("")){
            Log.d(TAG, "Input specificID: " + specificID);
        }
        Log.d(TAG, "\n-----------------------------------------------------\n");
    }

    private static void separateDmsSignals(String specificID, String hexValueStatus){
        String dmsAleart = "";
        String dmsStatus = "";
        Log.d(TAG, "dawi_separateDmsSignals-------------");
        // Log.d(TAG, "Input specificID: " + specificID);
        // Log.d(TAG, "Input hexValueStatus: " + hexValueStatus);

        /* 15.Yaw */
        if(specificID.equals(idYaw) && hexValueStatus.equals(statusDmsOn)){
            dmsAleart = SpecificSignalDatasetForQML.testGetSpecificSignal(2, 0);// "Time_For_A_Brake",// "0x700, 18, 1"
            dmsStatus = SpecificSignalDatasetForQML.testGetDmsYawStatus(0);// "Yaw_Alarm"
            invokeSendToQtSignalChange(dmsAleart, dmsStatus);
        }
        if(specificID.equals(idYaw) && hexValueStatus.equals(statusDmsOff)){
            dmsAleart = SpecificSignalDatasetForQML.testGetSpecificSignal(2, 0);
            dmsStatus = SpecificSignalDatasetForQML.testGetDmsYawStatus(1);// "Yaw_NotAlarm"
            invokeSendToQtSignalChange(dmsAleart, dmsStatus);
        }

        /* 16.PhoneCall */
        if(specificID.equals(idPhoneCall) && hexValueStatus.equals(statusDmsOn)){
            dmsAleart = SpecificSignalDatasetForQML.testGetSpecificSignal(2, 1);// "Focus_On_Driving",// "0x700, 19, 1"
            dmsStatus = SpecificSignalDatasetForQML.testGetDmsPhoneCallStatus(0);// "PhoneCall_Alarm"
            invokeSendToQtSignalChange(dmsAleart, dmsStatus);
        }
        if(specificID.equals(idPhoneCall) && hexValueStatus.equals(statusDmsOff)){
            dmsAleart = SpecificSignalDatasetForQML.testGetSpecificSignal(2, 1);
            dmsStatus = SpecificSignalDatasetForQML.testGetDmsPhoneCallStatus(1);// "PhoneCall_NotAlarm"
            invokeSendToQtSignalChange(dmsAleart, dmsStatus);
        }

        if(!dmsAleart.equals("") && !dmsStatus.equals("")){
            Log.d(TAG, "Input specificID: " + specificID);
        }
        Log.d(TAG, "\n-----------------------------------------------------\n");
    }
    /**************************************************************/

    public void initDriverService(){
        Log.d(TAG, "=====initDriverService=====");
        Intent intent = new Intent();
        intent.setPackage("com.fxc.ev.driverprofile");
        intent.setAction("DriverProfileService");
        bindService(intent, connDriverService, Context.BIND_AUTO_CREATE);
    }

    public void disConnDriverService(){
        Log.d(TAG, "=====disConnDriverService=====");
        unbindService(connDriverService);
    }

    // 用於處理駕駛員服務的連接和斷開
    private ServiceConnection connDriverService = new ServiceConnection() {
        // 負責建立與駕駛員服務的連接，處理與服務的通信，並註冊 Callback 以接收數據變化的通知。

        @Override
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            // iBinder 是一個用於通信的介面。
            Log.d(TAG, "DriverService onServiceConnected");

            // 通過 iDriverAidlInterface 調用 getDriverData 方法，獲取駕駛員數據
            iDriverAidlInterface = IDriverAidlInterface.Stub.asInterface(iBinder);

//            try {
//                String speedLimit = iDriverAidlInterface.getDriverData("SpeedLimiting");
//                String passengerAirbagSwitch = iDriverAidlInterface.getDriverData("PACOS");/*Passenger Airbag Cut Off Switch */
//                setSpeedLimit(speedLimit);
//                setPACOS(passengerAirbagSwitch);
//            } catch (RemoteException e) {
//                e.printStackTrace();
//            }

            try {
                Log.d(TAG, "DriverService registerCallback");
                // 註冊駕駛員數據 Callback，以接收駕駛員服務的數據變化
                iDriverAidlInterface.registerCallback(driverCallback);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {
            iDriverAidlInterface = null;
            Log.i(TAG, "DriverService Disconnected");
        }
    };

    private void regBrocastReceiver() {/* 註冊廣播接收器 */
        Log.d(TAG, "regBrocastReceiver");
        IntentFilter filter = new IntentFilter();
        filter.addAction(DRIVER_MODE_CHANGE_ACTION);
        filter.addAction(DPAD_KEYEVENT);
        filter.addAction(KNEO_FACE_UNLOCK);
        filter.addAction(TRIP_MODE_CHANGE_ACTION);
        filter.addAction(TRIP_MODE_RESETVALUE_ACTION);
        filter.addAction(EV_RADIO_PROGRAMS);
        filter.addAction(SPEED_LIMIT_ACTION);
        filter.addAction(CHARGE_MODE_CHANGE);
        registerReceiver(mBroadcastReceiver, filter);
    }

    public class serviceStartBroadcastReceiver extends BroadcastReceiver {/* 廣播接收器 */
        @Override
        public void onReceive(Context context, Intent intent) {
            Log.i(TAG, "onReceive::intent.Action = "+ intent.getAction());
            if (intent.getAction().equals(DRIVER_MODE_CHANGE_ACTION)) {
                /*launcher廣播通知變更行車模式*/
                String modeStr = intent.getStringExtra("mode");
                Log.i(TAG, "modeStr: "+ modeStr);
                sendToQtDriverMode(modeStr);
            } else if (intent.getAction().equals(DPAD_KEYEVENT)) {
                String keycodeStr = intent.getStringExtra("KeyCode");
                Log.i(TAG, "keycodeStr: "+ keycodeStr);
                sendToQtKeyCode(keycodeStr);
            } else if (intent.getAction().equals(KNEO_FACE_UNLOCK)) {
                String userName = intent.getStringExtra("userName");
                Log.i(TAG, "NKEO userName: "+ userName);
                sendToQtKneoUserID(userName);
            } else if (intent.getAction().equals(TRIP_MODE_CHANGE_ACTION)) {
                setTripInfo();
            } else if (intent.getAction().equals(TRIP_MODE_RESETVALUE_ACTION)) {
                String resetItem = intent.getStringExtra("resetItem");
                Log.i(TAG, "Trip resetItem: "+ resetItem);
                resetTripValue(resetItem);
            } else if (intent.getAction().equals(EV_RADIO_PROGRAMS)) {
                /*模擬接收到電台廣播，傳送數據到qml*/
                if(TEST_DEBUG){
                    boolean updateList = true;
                    int currRadioIdx = 3;
                    String currRadioName = "TEST RADIONAME";
                    String currRadioFreq = "TEST RADIOFREQ";
                    String arrayRadio = "";
                    ArrayList<String> radioList = new ArrayList();
                    for (int i = 0;i < 10;i++) {
                        radioList.add("title_"+i+"&"+"info_"+i);
                    }
                    if (radioList.size() != 0) {
                        String string = radioList.toString();
                        arrayRadio = string.substring(1,string.length()-1);
                        sendRadioInfo(currRadioIdx,currRadioName,currRadioFreq,updateList,arrayRadio);
                    }
                } else {
                    Bundle bundle = intent.getBundleExtra("radio_programs");
                    if (bundle != null) {
                        boolean updateList = bundle.getBoolean("program_update");/*是否要更新電台列表*/
                        int currRadioIdx = bundle.getInt("radio_index");/*當前播放的電台在電台列表中的index*/
                        ProgramSelector currSelector = bundle.getParcelable("radio_selector");/*當前播放的電台(含微調控制)*/
                        String currRadioName = "";
                        String currRadioFreq = "";
                        String arrayRadio = "";
                        if(currSelector != null) {
                            currRadioName = new Program(currSelector,ProgramSelectorExt.getDisplayName(
                                    currSelector, ProgramSelectorExt.NAME_NO_PROGRAM_TYPE_FALLBACK)).getName();/*當前播放的電台名稱*/
                            currRadioFreq = ProgramSelectorExt.getDisplayName(
                                    currSelector, ProgramSelectorExt.NAME_NO_MODULATION);/*當前播放的電台頻率*/
                        }
                        ArrayList<String> radioList = new ArrayList();
                        ArrayList<RadioManager.ProgramInfo> programInfos = bundle.getParcelableArrayList("radio_programs");/*電台列表*/
                        if(programInfos.size() != 0) {
                            for (RadioManager.ProgramInfo programInfo:programInfos) {
                                ProgramSelector sel = programInfo.getSelector();
                                RadioMetadata metadata = ProgramInfoExt.getMetadata(programInfo);
                                String programTitle = metadata.getString(RadioMetadata.METADATA_KEY_RDS_PS);
                                String programModulation = ProgramSelectorExt.getDisplayName(sel,ProgramSelectorExt.NAME_NO_MODULATION);
                                Log.i(TAG, "radio Title: "+ programTitle);
                                Log.i(TAG, "radio Modulation: "+ programModulation);
                                radioList.add(programTitle + "&" + programModulation);
                            }
                        }
                        Log.i(TAG, "radioList = "+ radioList.toString());
                        if (radioList.size() != 0) {
                            String string = radioList.toString();
                            arrayRadio = string.substring(1,string.length()-1);
                            sendRadioInfo(currRadioIdx,currRadioName,currRadioFreq,updateList,arrayRadio);
                        }
                    }
                }
            } else if (intent.getAction().equals(SPEED_LIMIT_ACTION)) {
                /*檢查限速開關*/
            } else if (intent.getAction().equals(CHARGE_MODE_CHANGE)) {
                String statusStr = intent.getStringExtra("status");
                Log.i(TAG, "charge mode statusStr: "+ statusStr);
                sendChargeModeStatus(statusStr);
            }
        }
    }

    private void resetTripValue(String resetItem) {
        Log.i(TAG, "resetTripValue");
        if (resetItem.equals("TripA")) {
            tripAReset = true;
        } else if (resetItem.equals("TripB")) {
            tripBReset = true;
        }
        setTripInfo();
    }

    private void setTripInfo(){/* 用於初始化 Trip Info */
        Log.i(TAG, "setTripInfo");
        String value = SystemPropUtil.getprop("persist.fxc.ev.tripui","");
        //Log.i(TAG, "persist.fxc.ev.tripui value = "+ value);
        if (!TextUtils.isEmpty(value)) {
            String[] array = value.split(",");
            String odometer = "288,511";
            ArrayList<String> TripInfo = new ArrayList<>();
            for (int i = 0; i < array.length; i++) {
                Log.i(TAG, "trip i = " + i);
                if (!TextUtils.isEmpty(array[i])) {
                    String name = array[i];
                    String km = "0";
                    String h = "0";
                    String min = "0";
                    String kwh = "0";
                    if (i == 0 && currentReset == false) {
                        /*Current*/
                        km = "2010";
                        h = "2";
                        min = "46";
                        kwh = "500";
                    } else if (i == 1 && lastChargeReset == false) {
                        /*Last Charge*/
                        km = "5555";
                        h = "8";
                        min = "20";
                        kwh = "5000";
                    } else if (i == 2 && tripAReset == false) {
                        /*Trip A*/
                        km = "555";
                        h = "4";
                        min = "10";
                        kwh = "600";
                    } else if (i == 3 && tripBReset == false) {
                        /*Trip B*/
                        km = "5550";
                        h = "41";
                        min = "40";
                        kwh = "6660";
                    }
                    String tripCard = name +","+ km +","+ h +","+ min +","+ kwh;
                    Log.i(TAG, "tripCard = " + tripCard);
                    TripInfo.add(tripCard);
                    if (TripInfo.size() == 2)
                        break;
                }
            }
            if (TripInfo.size() == 1) {
                Log.i(TAG, "sendTripCards size = 1");
                sendTripCards(odometer,TripInfo.get(0),"");
            } else if(TripInfo.size() == 2) {
                Log.i(TAG, "sendTripCards size = 2");
                sendTripCards(odometer,TripInfo.get(0),TripInfo.get(1));
            } else {
                Log.i(TAG, "sendTripCards Error");
            }
        }
    }

    private void setSpeedLimit(String speedLimitValue){
        Log.i(TAG, "speedLimitValue = "+ speedLimitValue);
        if (TextUtils.isEmpty(speedLimitValue)) {
            Log.i(TAG, "Speed Limit status is Close");
            sendLimitSpeed(false,0);
        } else {
            Log.i(TAG, "Speed Limit status is Open");
            sendLimitSpeed(true,Integer.valueOf(speedLimitValue));
        }
    }

    private void setPACOS(String passengerAirbagSwitch){
        if (passengerAirbagSwitch.equals("1")) {
            /*副駕安全氣囊功能正常啟用*/
            sendPacosStatus(true);
        } else if (passengerAirbagSwitch.equals("0")) {
            /*副駕安全氣囊功能關閉*/
            sendPacosStatus(false);
        } else {
            Log.i(TAG, "PACOS not set value");
        }
    }

    /**** Receive Media Infos from Java, and display on the QML ***/
    private void initMediaPlaybackHandler(){
        Log.i(TAG, "initMediaPlaybackHandler");
        mediaPlaybackHandler = new MediaPlaybackHandler();
        mediaPlaybackHandler.setMediaPlaybackCallback(this);
        mediaPlaybackHandler.initializeMediaBrowser(this);
    }

    @Override
    public void onUpdateUI(String songName, String artistAndAlbum, long totalTime, Uri albumPhoto) {
        String titleInfo = songName;
        String[] parts = artistAndAlbum.split("-");

        // 檢查 parts 陣列的長度是否足夠
        if (parts.length >= 2) {
            String artistInfo = parts[1];
            String albumInfo = parts[0];
            int seconds = (int)(totalTime/1000);
            String durationInfo = String.valueOf(seconds);

            if(titleInfo == null){
                titleInfo = "";
            }
            if(artistInfo == null){
                artistInfo = "unknown";
            }
            if(albumInfo == null){
                albumInfo = "unknown";
            }
            if(!durationInfo.isEmpty()){
                sendToQtMediaInfo(titleInfo, artistInfo, albumInfo, durationInfo);
            }

            if (albumPhoto != null) {
                try {
                    InputStream inputStream = getContentResolver().openInputStream(albumPhoto);
                    if (inputStream != null) {
                        Bitmap bmp = BitmapFactory.decodeStream(inputStream);
                        if (bmp != null) {
                            String savePath = savaImage(bmp);
                            if (!TextUtils.isEmpty(savePath)) {
                                sendToQtThumb(savePath);
                                Log.i(TAG, "PhotoPath: " + savePath);
                            } else {
                                Log.i(TAG, "Thumb bmp is null ");
                            }
                        }
                        inputStream.close();
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            Log.i(TAG, "java_titleSongName: " + titleInfo);
            Log.i(TAG, "java_Artis: " + artistInfo);
            Log.i(TAG, "java_Album: " + albumInfo);
            Log.i(TAG, "java_TotalTime: " + durationInfo + " s");
        } else {
            // parts 陣列的長度不足，可能需要採取一些預設值或者錯誤處理的方式
            Log.e(TAG, "Invalid artistAndAlbum format: " + artistAndAlbum);
        }

        /*String titleInfo = songName;
        String[] parts = artistAndAlbum.split("-");
        String artistInfo = parts[1];
        String albumInfo = parts[0];
        int seconds = (int)(totalTime/1000);
        String durationInfo = String.valueOf(seconds);

        if(titleInfo == null){
            titleInfo = "";
        }
        if(artistInfo == null){
            artistInfo = "unknow";
        }
        if(albumInfo == null){
            albumInfo = "unknow";
        }
        if(!durationInfo.isEmpty()){
            sendToQtMediaInfo(titleInfo, artistInfo, albumInfo, durationInfo);
        }

        if (albumPhoto != null) {
            try {
                InputStream inputStream = getContentResolver().openInputStream(albumPhoto);
                if (inputStream != null) {
                    Bitmap bmp = BitmapFactory.decodeStream(inputStream);
                    if (bmp != null) {
                        String savePath = savaImage(bmp);
                        if (!TextUtils.isEmpty(savePath)) {
                            sendToQtThumb(savePath);
                            Log.i(TAG, "PhotoPath: " + savePath);
                        } else {
                            Log.i(TAG, "Thumb bmp is null ");
                        }
                    }
                    inputStream.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        Log.i(TAG, "java_titleSongName: " + titleInfo);
        Log.i(TAG, "java_Artis: " + artistInfo);
        Log.i(TAG, "java_Album: " + albumInfo);
        Log.i(TAG, "java_TotalTime: " + durationInfo + " s");*/
    }

    @Override
    public void onCurrentTimeChanged(long currentTime) {
        int currentSongPosition = (int)(currentTime/1000);
        if(currentSongPosition != 0){
            sendToQtMediaCurrPos(currentSongPosition);
            Log.i(TAG, "java_music_currentTime: " + currentSongPosition + " s");
        }
    }

    @Override
    public void onSessionDestroyed() {
        mediaPlaybackHandler.reInitMediaBrowser(this);
        sendToQtCleanMedia();
    }

    private String savaImage(Bitmap bitmap){
        String path = getCacheDir().getPath();
        String filepath = path + "/thumb.jpg";
        File file = new File(path);
        FileOutputStream fileOutputStream = null;
        if(!file.exists()){
            file.mkdir();
        }
        try {
            fileOutputStream = new FileOutputStream(filepath);
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, fileOutputStream);
            fileOutputStream.close();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
        return filepath;
    }

    /**** Test java send value to Qt QML function. *************/
    private void testSendToQt(int count, String msg) {
        Log.d(TAG, "testSendToQt");
        new Thread(() -> {
            for(int i=0; i<=count; i++){
                if (msg!=null && !msg.isEmpty()) {
                    Log.d(TAG, "java(count, msg): " + i + ", " + msg);
                    sendToQt(msg);
                }
            }
        }).start();
    }

    private static void testInvokingSendToQtLogOnQML(String inputString) {
        Log.d(TAG, "dawi_testInvokingSendToQtLogOnQML");
        new Thread(() -> {
            int counts = 5;
            for(int i=0; i<=counts; i++){
                if (inputString!=null && !inputString.isEmpty()) {
                    Log.d(TAG, "dawi_java_count: " + i);
                    invokeSendToQt(inputString);
                }
            }
        }).start();
    }

    private static void testInvokingTelltaleSignalsToDisplayOnQML(int testMode){
        Log.d(TAG, "dawi_testInvokingTelltaleSignalsToDisplayOnQML");
        String signalLight = SpecificSignalDatasetForQML.testGetSpecificSignal(0, testMode);//{0,0-6}
        String lightStatus_on = SpecificSignalDatasetForQML.testGetLightStatus(0);
        String lightStatus_off = SpecificSignalDatasetForQML.testGetLightStatus(1);
        invokeSendToQtSignalChange(signalLight, lightStatus_on);
        invokeSendToQtSignalChange(signalLight, lightStatus_off);
        invokeSendToQtSignalChange(signalLight, lightStatus_on);
    }

    private static void testInvokingVehicleStatusToDisplayOnQML(int testMode){
        Log.d(TAG, "dawi_testInvokingVehicleStatusToDisplayOnQML");
        if(testMode == 0){
            String gearValue = SpecificSignalDatasetForQML.testGetSpecificSignal(1, 3); //{1:0-3} P, R, N, D
            invokeSendingGearInfoToQt(gearValue);
            Log.d(TAG, "testMode0_gear: " + gearValue);
         }

        if(testMode == 1){
            for(int oduTemp=23; oduTemp<=26; oduTemp++){
                String strOduTemp = String.valueOf(oduTemp);
                invokeSendingOduTempToQt(strOduTemp);
                Log.d(TAG, "testMode1_oduTemp: " + strOduTemp + " degC");
            }
        }

        if(testMode == 2){
            for(int speedValue=120; speedValue<=130; speedValue++){
                String strspeedValue = String.valueOf(speedValue);
                invokeSendingSpeedValueToQt(strspeedValue);
                Log.d(TAG, "testMode2_speed: " + strspeedValue + " km/h");
            }
        }

        if(testMode == 3){
            for(int socValue=90; socValue>=83; socValue--){
                String strSocValue = String.valueOf(socValue);
                invokeSendingSocValueToQt(strSocValue);
                Log.d(TAG, "testMode3_SOC: " + socValue + " %");
            }
        }

        if(testMode == 4){
            for(int drivingMileageValue=190; drivingMileageValue>=183; drivingMileageValue--){
                String strDrivingMileageValue = String.valueOf(drivingMileageValue);
                invokeSendingdrivingMileageValueToQt(strDrivingMileageValue);
                Log.d(TAG, "testMode4_drivingMileage: " + strDrivingMileageValue + " km");
            }
        }
    }

    private static void testInvokingDmsAleartToDisplayOnQML(int testMode){
        Log.d(TAG, "dawi_testInvokingDmsAleartToDisplayOnQML");
        if(testMode == 0){// Yaw
            String dmsAleart = SpecificSignalDatasetForQML.testGetSpecificSignal(2, 0);
            String dmsAleartStatus_on = SpecificSignalDatasetForQML.testGetDmsYawStatus(0);
            String dmsAleartStatus_off = SpecificSignalDatasetForQML.testGetDmsYawStatus(1);
            invokeSendToQtSignalChange(dmsAleart, dmsAleartStatus_on);
            invokeSendToQtSignalChange(dmsAleart, dmsAleartStatus_off);
            invokeSendToQtSignalChange(dmsAleart, dmsAleartStatus_on);
        }

        if(testMode ==1){//PhoneCall
            String dmsAleart = SpecificSignalDatasetForQML.testGetSpecificSignal(2, 1);
            String dmsAleartStatus_on = SpecificSignalDatasetForQML.testGetDmsPhoneCallStatus(0);
            String dmsAleartStatus_off = SpecificSignalDatasetForQML.testGetDmsPhoneCallStatus(1);
            invokeSendToQtSignalChange(dmsAleart, dmsAleartStatus_on);
            invokeSendToQtSignalChange(dmsAleart, dmsAleartStatus_off);
            invokeSendToQtSignalChange(dmsAleart, dmsAleartStatus_on);
        }
    }

    private static void invokeSendToQt(String inputString){
        sendToQt(inputString);
        Log.d(TAG, "java_string: " + inputString + "\n----------------\n");
    }

    private static void invokeSendToQtSignalChange(String light, String status){
        Log.d(TAG, "dawi_invokeSendToQtSignalChange");
        if (light!=null && !light.isEmpty() && status!=null && !status.isEmpty()){
            Log.d(TAG, "java_signal: " + light + ", java_status: " + status + "\n----------------\n");
            sendToQtSignalChange(light, status);
        }
    }

    private static void invokeSendingGearInfoToQt(String greaInfo){
        sendGearInfoToQt(greaInfo);
        Log.d(TAG, "java_SendgreaInfo: " + greaInfo + "\n----------------\n");
    }

    private static void invokeSendingOduTempToQt(String OduTempValue){
        sendOduTempValueToQt(OduTempValue);
        Log.d(TAG, "java_SendOdu: " + OduTempValue + " degC\n----------------\n");
    }

    private static void invokeSendingSpeedValueToQt(String speedValue){
        sendSpeedValueToQt(speedValue);
        Log.d(TAG, "java_SendSpeed: " + speedValue + " km/h\n----------------\n");
    }

    private static void invokeSendingSocValueToQt(String socValue){
        sendSocValueToQt(socValue);
        Log.d(TAG, "java_SendSOC: " + socValue + " degC\n----------------\n");
    }

    private static void invokeSendingdrivingMileageValueToQt(String drivingMileageValue){
        sendDrivingMileageValueToQt(drivingMileageValue);
        Log.d(TAG, "java_SendDrivingMileage: " + drivingMileageValue + " km/h\n----------------\n");
    }
    /**************************************************************/
}
