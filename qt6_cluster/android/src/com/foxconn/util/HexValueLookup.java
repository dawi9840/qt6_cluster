package com.foxconn.util;

import android.util.Log;
import java.util.HashMap;
import java.util.Map;

public class HexValueLookup {

    private static final String TAG = "HexValueLookup";

    /***
     * Retrieves custom hex value tables based on the chosen mode.
     *
     * @param chooseMode An integer representing the selection:
     *                   0: Hex value table for tset.
     *                   1: Hex value table for Telltail.
     *                   2: Hex value table for Vehicle Status.
     *                   3: Hex value table for Telltail and Vehicle Status.
     * @return A 2D array containing hex value table.
     ***/
    public static String[][] gethexValueTable(int chooseMode) {
        if (chooseMode == 0) { /* For tset hexValueTable */
            String[][] hexValueTable = {
                    { // Test A status
                            "0x3=Switch ON123",
                            "0xFE=AAA",
                            "0xFF=BBB",
                    },
                    { // Test B status
                            "0x3=Switch Fault",
                            "0x217=Switch Stuck ON Detected",
                            "0x1=Switch Pressed",
                            "0x0=Switch Released",
                    },
            };
            return hexValueTable;
        }
        if (chooseMode == 1) { /* Telltail hexValueTable */
            String[][] hexValueTable = {
                    { // Telltail Status: Only have on/off status
                            "0x1=On", "0x0=Off",
                    },
            };
            return hexValueTable;
        }
        if (chooseMode == 2) { /* Vehicle Status hexValueTable */
            String[][] hexValueTable = {
                    { // Vehicle Status: PRND status
                            "0x3=Switch Fault", "0x2=Switch Stuck ON Detected",
                            "0x1=Switch Pressed", "0x0=Switch Released",
                    },
                    { // Vehicle Status: Outdoor temperature status
                            "0xFF=FF - Signal not available", "0xFE=Init",
                    },
                    { // Vehicle Status: Speed status
                            "0x1FFF=Error", "0x1FFE=Init",
                    },
                    { // Vehicle Status: Battery level SOC status
                            "0xFF=Error", "0xFE=Init",
                    },
                    { // Vehicle Status: Driving mileage status
                            "0x3FF=Error", "0x3FE=Init",
                    }
            };
            return hexValueTable;
        }
        if (chooseMode == 3) {/* Telltail and Vehicle Status hexValueTable */
            String[][] hexValueTable = {
                    { // 0.Telltail Status: Only have on/off status
                            "0x1=On", "0x0=Off",
                    },
                    { // 1.Vehicle Status: PRND status
                            "0x3=Switch Fault", "0x2=Switch Stuck ON Detected",
                            "0x1=Switch Pressed", "0x0=Switch Released",
                    },
                    { // 2.Vehicle Status: Outdoor temperature status
                            "0xFF=FF - Signal not available", "0xFE=Init",
                    },
                    { // 3.Vehicle Status: Speed status
                            "0x1FFF=Error", "0x1FFE=Init",
                    },
                    { // 4.Vehicle Status: Battery level SOC status
                            "0xFF=Error", "0xFE=Init",
                    },
                    { // 5.Vehicle Status: Driving mileage status
                            "0x3FF=Error", "0x3FE=Init",
                    },
                    { // 6.DMS Status: Only have Alarm/NotAlarm status
                            "0x1=Alarm", "0x0=NotAlarm",
                    },
                    { // 7.LED light Status: for direction light(Left/Right) and hazard light
                            "0x3=Reserved", "0x2=LED Fail",
                            "0x1=LED On","0x0=LED Off",
                    },
            };
            return hexValueTable;
        }
        if (chooseMode == 4) {/* DMS Status hexValueTable */
            String[][] hexValueTable = {
                    { // DMS Status: Only have Alarm/NotAlarm status
                            "0x1=Alarm", "0x0=NotAlarm",
                    },
            };
            return hexValueTable;
        }
        if (chooseMode == 5) {/* 0x427 Status hexValueTable */
            String[][] hexValueTable = {
                    { // LED light Status: for direction light(Left/Right) and hazard light
                            "0x3=Reserved", "0x2=LED Fail",
                            "0x1=LED On","0x0=LED Off",
                    },
            };
            return hexValueTable;
        }
        return new String[0][0]; // Return empty array
    }

    /***
     * Retrieves a custom corresponding table by mapping indexes from
     * canIdSignalsTable to hexValueTables based on the chosen mode.
     *
     * @param canIdSignalsTable An array containing signal indexes.
     * @param hexValueTable     A 2D array containing hex value tables.
     * @param chooseMode        An integer representing the selection:
     *                          0: Choose correspondingTable for test.
     *                          1: Choose correspondingTable for Telltail.
     *                          2: Choose correspondingTable for Vehicle Status.
     *                          3: Choose correspondingTable for
     *                             Telltail, Vehicle Status, and DMS.
     *                          4: Choose correspondingTable for DMS.
     * @return A map containing the corresponding table.
     ***/
    public static Map<String, String[]> getCorrespondingTable(String[] canIdSignalsTable, String[][] hexValueTable, int chooseMode) {
        Map<String, String[]> correspondingTable = new HashMap<>();
        switch (chooseMode) {
            case 0: /* Custom correspondingTable for test. */
                correspondingTable.put(canIdSignalsTable[0], hexValueTable[0]);
                correspondingTable.put(canIdSignalsTable[1], hexValueTable[1]);
                correspondingTable.put(canIdSignalsTable[2], hexValueTable[1]);
                correspondingTable.put(canIdSignalsTable[3], hexValueTable[0]);
                break;
            case 1: /* Custom correspondingTable for Telltail. */
                correspondingTable.put(canIdSignalsTable[0], hexValueTable[0]);
                correspondingTable.put(canIdSignalsTable[1], hexValueTable[0]);
                correspondingTable.put(canIdSignalsTable[2], hexValueTable[0]);
                correspondingTable.put(canIdSignalsTable[3], hexValueTable[7]);  //Direction_Light_Left
                correspondingTable.put(canIdSignalsTable[4], hexValueTable[7]);  //Direction_Light_Right
                correspondingTable.put(canIdSignalsTable[5], hexValueTable[0]);
                correspondingTable.put(canIdSignalsTable[6], hexValueTable[7]);  //Warning_Light_HAZARD
                break;
            case 2: /* Custom correspondingTable for Vehicle Status. */
                correspondingTable.put(canIdSignalsTable[0], hexValueTable[0]);
                correspondingTable.put(canIdSignalsTable[1], hexValueTable[0]);
                correspondingTable.put(canIdSignalsTable[2], hexValueTable[0]);
                correspondingTable.put(canIdSignalsTable[3], hexValueTable[0]);
                correspondingTable.put(canIdSignalsTable[4], hexValueTable[1]);
                correspondingTable.put(canIdSignalsTable[5], hexValueTable[2]);
                correspondingTable.put(canIdSignalsTable[6], hexValueTable[3]);
                correspondingTable.put(canIdSignalsTable[7], hexValueTable[4]);
                break;
            case 3: /* Custom correspondingTable for Telltail, Vehicle Status and DMS. */
                // Ref Telltail status : case1 hexValueTable
                correspondingTable.put(canIdSignalsTable[0], hexValueTable[0]);
                correspondingTable.put(canIdSignalsTable[1], hexValueTable[0]);
                correspondingTable.put(canIdSignalsTable[2], hexValueTable[0]);
                correspondingTable.put(canIdSignalsTable[3], hexValueTable[7]);  //Direction_Light_Left
                correspondingTable.put(canIdSignalsTable[4], hexValueTable[7]);  //Direction_Light_Right
                correspondingTable.put(canIdSignalsTable[5], hexValueTable[0]);
                correspondingTable.put(canIdSignalsTable[6], hexValueTable[7]);  //Warning_Light_HAZARD
                // Ref Vehicle status: case2 hexValueTable
                correspondingTable.put(canIdSignalsTable[7], hexValueTable[1]);  //P
                correspondingTable.put(canIdSignalsTable[8], hexValueTable[1]);  //R
                correspondingTable.put(canIdSignalsTable[9], hexValueTable[1]);  //N
                correspondingTable.put(canIdSignalsTable[10], hexValueTable[1]); //D
                correspondingTable.put(canIdSignalsTable[11], hexValueTable[2]);
                correspondingTable.put(canIdSignalsTable[12], hexValueTable[3]);
                correspondingTable.put(canIdSignalsTable[13], hexValueTable[4]);
                correspondingTable.put(canIdSignalsTable[14], hexValueTable[5]);
                // Ref DMS: case4 hexValueTable
                correspondingTable.put(canIdSignalsTable[15], hexValueTable[6]);
                correspondingTable.put(canIdSignalsTable[16], hexValueTable[6]);
                break;
            case 4: /* Custom correspondingTable for DMS Status. */
                correspondingTable.put(canIdSignalsTable[0], hexValueTable[0]);
                correspondingTable.put(canIdSignalsTable[1], hexValueTable[1]);
                break;
        }
        return correspondingTable;
    }

    /***
     * Retrieves the status information corresponding to a specific ID and
     * hexadecimal value from the provided corresponding table.
     *
     * @param specificID         The specific ID to search for in the corresponding table.
     * @param hexValue           The hexadecimal value to match in the corresponding table entry.
     * @param correspondingTable The mapping table containing IDs and their associated hex value arrays.
     * @return The status information associated with the specific ID and hexadecimal value, or
     * "Not found" if no matching entry is found in the corresponding table.
     ***/
    public static String getHexValueStatus(String specificID, String hexValue, Map<String, String[]> correspondingTable) {
        Log.d(TAG, "dawi_getHexValueStatus");
        for (Map.Entry<String, String[]> entry : correspondingTable.entrySet()) {
            // Check whether a specific ID matches the Key of the current Map entry
            if (specificID.equals(entry.getKey())) {
                String[] hexValueTable = entry.getValue();
                // Check whether the corresponding value array is null
                if (hexValueTable != null) {
                    for (String entryValue : hexValueTable) {
                        // Check if each entryValue is null
                        if (entryValue != null) {
                            String[] parts = entryValue.split("=");
                            // Check length of parts array to avoid ArrayIndexOutOfBoundsException
                            if (parts.length >= 2 && parts[0].equals(hexValue)) {
                                Log.d(TAG, "entryValue" + entryValue + "\n----------\n");
                                return entryValue;
                            }
                        }
                    }
                }
            }
        }
        return "Not found";
    }

    private static void testGetHexValueStatus() {  /* Test using a specificID to find the HexValueStatus. */
        int selectMode = 0;
        String[][] hexValueTable = gethexValueTable(selectMode);
        String[] canIdSignalsTable = SpecificCanIdDataset.getSpecificCanIdDatasets(selectMode);
        Map<String, String[]> correspondingTable = getCorrespondingTable(canIdSignalsTable, hexValueTable, selectMode);
        String specificID = "0x199, 26, 3";
        String hexValue = "0x3";
        String hexValueStatus = getHexValueStatus(specificID, hexValue, correspondingTable);
        Log.d(TAG, "specificID: " + specificID);
        Log.d(TAG, "hexValueStatus: " + hexValueStatus);
    }

    private static void testGetDMSHexValueStatus() {  /* Test using a specificID to find the DMS HexValueStatus. */
        int selectMode = 3;
        String[][] hexValueTable = gethexValueTable(selectMode);
        String[] canIdSignalsTable = SpecificCanIdDataset.getSpecificCanIdDatasets(selectMode);
        Map<String, String[]> correspondingTable = getCorrespondingTable(canIdSignalsTable, hexValueTable, selectMode);
        String specificID = "0x700, 19, 1"; // 0x700, 18, 1;0x700, 19, 1
        String hexValue = "0x0"; // 0x0=NotAlarm;0x1=Alarm
        String hexValueStatus = getHexValueStatus(specificID, hexValue, correspondingTable);
        Log.d(TAG, "specificID: " + specificID);
        Log.d(TAG, "hexValueStatus: " + hexValueStatus);
    }

    public static void main(String[] args) {
        //testGetHexValueStatus();
        //testGetDMSHexValueStatus();
    }
}
