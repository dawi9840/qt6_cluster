package com.foxconn.util;

import android.util.Log;

public class SpecificCanIdDataset {

    private static final String TAG = "SpecificCanIdDataset";

    /***
     * Retrieves custom specific CAN ID signal datasets based on the chosen mode.
     *
     * @param chooseMode An integer representing the selection:
     *                   0: Signal Specific CAN ID for test.
     *                   1: Specific CAN ID for Telltail.
     *                   2: Specific CAN ID for Vehicle Status.
     *                   3: Specific CAN ID for Telltail, Vehicle Status and DMS.
     *                   4: Specific CAN ID for DMS.
     * @return A String array containing signal specific CAN ID.
     ***/
    public static String[] getSpecificCanIdDatasets(int chooseMode) {
        if (chooseMode == 0) { /* For tset CAN ID (ID, startBit, length) */
            String[] canIdSignals = {
                    "0x199, 26, 3",
                    "0x199, 13, 2",
                    "0x199, 17, 2",
                    "0x199, 19, 2",
            };
            return canIdSignals;
        }
        if (chooseMode == 1) { /* Telltail CAN ID (ID, startBit, length) */
            String[] canIdSignals = {
                    "0x217, 18, 1", // Low beam (on/off)
                    "0x217, 17, 1", // High beam (on/off)
                    "0x215, 43, 1", // Front fog lamp (on/off), head and tail lights are the same CAN ID
                    "0x427, 13, 2", // Left direction light (on/off), head and tail lights are the same CAN ID
                    "0x427, 11, 2", // Right direction light (on/off), head and tail lights are the same CAN ID
                    "0x217, 41, 1", // Rear fog light (on/off)
                    "0x427, 42, 2", // Warning light HAZARD (on/off)
            };
            return canIdSignals;
        }
        if (chooseMode == 2) { /* Vehicle Status CAN ID (ID, startBit, length) */
            String[] canIdSignals = {
                    "0x199, 13, 2",  // PRND_P Park light
                    "0x199, 15, 2",  // PRND_R Reverse light
                    "0x199, 17, 2",  // PRND_N Neutral light
                    "0x199, 19, 2",  // PRND_D Drive light
                    "0x40A, 31, 8",  // Outdoor temperature
                    "0x322, 39, 13", // Speed
                    "0x403, 23, 8",  // Battery level SOC
                    "0x403, 25, 10", // Driving mileage
            };
            return canIdSignals;
        }
        if (chooseMode == 3) {/* Telltail and Vehicle Status and DMS CAN ID (ID, startBit, length) */
            String[] canIdSignals = {
                    "0x217, 18, 1",  // 0.Low beam (on/off)
                    "0x217, 17, 1",  // 1.High beam (on/off)
                    "0x215, 43, 1",  // 2.Front fog lamp (on/off), head and tail lights are the same CAN ID
                    "0x427, 13, 2",  // 3.Left direction light (on/off), head and tail lights are the same CAN ID
                    "0x427, 11, 2",  // 4.Right direction light (on/off), head and tail lights are the same CAN ID
                    "0x217, 41, 1",  // 5.Rear fog light (on/off)
                    "0x427, 42, 2",  // 6.Warning light HAZARD (on/off)
                    "0x199, 13, 2",  // 7.PRND_P Park light
                    "0x199, 15, 2",  // 8.PRND_R Reverse light
                    "0x199, 17, 2",  // 9.PRND_N Neutral light
                    "0x199, 19, 2",  // 10.PRND_D Drive light
                    "0x40A, 31, 8",  // 11.Outdoor temperature
                    "0x322, 39, 13", // 12.Speed
                    "0x403, 23, 8",  // 13.Battery level SOC
                    "0x403, 25, 10", // 14.Driving mileage
                    "0x700, 18, 1",  // 15.Yaw
                    "0x700, 19, 1",  // 16.PhoneCall
            };
            return canIdSignals;
        }
        if (chooseMode == 4) {/* DMS CAN ID (ID, startBit, length) */
            String[] canIdSignals = {
                    "0x700, 18, 1", // Yaw
                    "0x700, 19, 1", // PhoneCall
            };
            return canIdSignals;
        }
        return new String[0]; // Return empty array
    }

    private static void testGetSpecificCanIdDataSet() { /* Test get a Specific CAN ID dataset. */
        int selectMode = 0;
        String[] SpecificCanIds = getSpecificCanIdDatasets(selectMode);
        for (String canIDSet : SpecificCanIds) {
            Log.d(TAG, "specificCanID: " + canIDSet);
        }
    }

    public static void main(String[] args) {
        //testGetSpecificCanIdDataSet();
    }
}
