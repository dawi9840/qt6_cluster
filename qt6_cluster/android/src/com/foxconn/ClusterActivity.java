package com.foxconn;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;

// import lookup CAN ID 相關庫
import com.foxconn.util.SignalCANInfo;
import com.foxconn.util.HexValueLookup;
import com.foxconn.util.SpecificCanIdDataset;
import com.foxconn.util.SignalReceiver;
import java.util.Queue;

import com.foxconn.QtAndroidService;

public class ClusterActivity extends org.qtproject.qt.android.bindings.QtActivity {
    private static final String TAG = "CluserActivity";

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Disable system bar visible.
        getWindow().getDecorView().setSystemUiVisibility(
        View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                | View.SYSTEM_UI_FLAG_FULLSCREEN
                | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
        //dawiTestClassCode();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if(keyCode == KeyEvent.KEYCODE_BACK) {
            Log.i(TAG,"press KEYCODE_BACK");
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    private void dawiTestClassCode(){
        Log.d(TAG, "dawi_TestClassCode");
        //SignalCANInfo.testSpecificIDsForHexValueStatus();
        int count = 255;
        int selectMode = 0; // [3]: Telltail and Vehicle status mode.
        String inputSimulateCanSignals = SignalReceiver.simulateCanSignals(count);
        Queue<String> tmpSignalQueue = SignalReceiver.getSignalQueue(inputSimulateCanSignals);
        String aString = SignalReceiver.getQueueToString(tmpSignalQueue);
        Log.d(TAG, "aString: " + aString);
        SignalCANInfo.findSpecificIDsForHexValueStatus(aString, selectMode);
    }
}
