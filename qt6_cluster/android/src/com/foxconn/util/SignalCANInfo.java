package com.foxconn.util;

import android.util.Log;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class SignalCANInfo {

    private static final String TAG = "SignalCANInfo";

    public static int[] canBuffer = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}; // initial value 0

    /***
     * Parses the dataSet and extracts signal information.
     *
     * @param dataSet A string containing signal data separated by ';'.
     * @return An array containing signal information:
     *         [0]: Signal data in its original format.
     *         [1]: The formatted can ID.
     *         [2]: The extracted can data.
     ***/
    public static String[] parseSignalData(String dataSet) {
        //Log.d(TAG, "dawi_parseSignalData");
        // Get signalInfo
        String[] data = dataSet.split(" ");
        String signalInfo = dataSet;

        // Remove header (first group)
        String[] canIDTmpArray = new String[3];
        System.arraycopy(data, 1, canIDTmpArray, 0, 3);
        String canIDTmp = String.join(" ", canIDTmpArray);
        //Log.d(TAG, "canIDTmp_Remove header: " + canIDTmp);

        // Get canData
        String[] canDataArray = new String[8];
        System.arraycopy(data, 4, canDataArray, 0, 8);
        String canData = String.join(" ", canDataArray);

        // Process canIDTmp
        String[] canIDTmpValues = canIDTmp.split(" ");
        StringBuilder processedCanIDTmp = new StringBuilder();

        for (String value : canIDTmpValues) {
            int intValue = Integer.parseInt(value, 16);
            processedCanIDTmp.append(Integer.toHexString(intValue));
        }
        String canID = "0x" + processedCanIDTmp.toString().toUpperCase();

        //Log.d(TAG, "signalInfo: " + signalInfo);
        //Log.d(TAG, "canID: " + canID);
        //Log.d(TAG, "canData: " + canData + "\n----------\n");

        return new String[] { signalInfo, canID, canData };
    }

    /**
     * Extracts the CAN-specific ID from the given signal ID.
     *
     * @param inputASingalId A string containing signal ID information separated by ', '.
     * @return The CAN-specific ID extracted from the input signal ID.
     */
    public static String getCanSpecificCanId(String inputASingalId) {
        String[] specificIDParts = inputASingalId.split(", ");
        return specificIDParts[0];
    }

    /**
     * Extracts the CAN-specific start bit from the given signal ID.
     *
     * @param inputASingalId A string containing signal ID information separated by ', '.
     * @return The CAN-specific start bit extracted from the input signal ID.
     */
    public static String getCanSpecificStartBit(String inputASingalId) {
        String[] specificIDParts = inputASingalId.split(", ");
        return specificIDParts[1];
    }

    /**
     * Extracts the CAN-specific length from the given signal ID.
     *
     * @param inputASingalId A string containing signal ID information separated by ', '.
     * @return The CAN-specific length extracted from the input signal ID.
     */
    public static String getCanSpecificLength(String inputASingalId) {
        String[] specificIDParts = inputASingalId.split(", ");
        return specificIDParts[2];
    }

    /***
     * Calculates the hexadecimal value based on specificID and signalData.
     *
     * @param specificID A string containing specific ID, start bit, and length.
     * @param signalData An array containing parsed signal information.
     * @return The calculated hexadecimal value.
     ***/
    public static String getHexValue(String specificID, String[] signalData) {
        //Log.d(TAG, "dawi_getHexValue");
        String[] specificIDParts = specificID.split(", ");

        if (specificIDParts.length < 3) {
                return "";
        }

        String myCanID = specificIDParts[0];
        String myStartBit = specificIDParts[1];
        String myLength = specificIDParts[2];

        //Log.d(TAG, "Input specificID: " + specificID);
        //Log.d(TAG, "myCanID: " + myCanID);
        //Log.d(TAG, "myStartBit: " + myStartBit);
        //Log.d(TAG, "myLength: " + myLength + "\n=====\n");
        //Log.d(TAG, "InputSourceCanInfo: " + signalData[0]);
        //Log.d(TAG, "InputcanID: " + signalData[1]);
        //Log.d(TAG, "InputcanData: " + signalData[2] + "\n--------------------\n");

        return getCanValue(myCanID, myStartBit, myLength, signalData);
    }

    /**
     * Calculates the hexadecimal value based on CAN ID, start bit, length, and signalData.
     *
     * @param canId      A string representing the CAN ID.
     * @param startBit   A string representing the starting bit.
     * @param length     A string representing the length.
     * @param signalData An array containing parsed signal information.
     * @return The calculated hexadecimal value.
     ***/
    public static String getCanValue(String canId, String startBit, String length, String[] signalData) {
        // kuma version
        String hexValue = "";

        canId = canId.contains("0x") ? canId.replace("0x", "") : canId;
        String[] strSignalData = signalData[0].split(" ");

        if(strSignalData != null) {
            int[] arr = new int[strSignalData.length];
            for(int i=0; i<strSignalData.length; i++) {
                arr[i] = Integer.decode("0x" + strSignalData[i]);
            }
            if(strSignalData.length >= 12){
                //Log.d("kuma", "strSignalData= " + " " +
                //              strSignalData[0] + " " + strSignalData[1] + " " + strSignalData[2] + " " + strSignalData[3] + " " +
                //              strSignalData[4] + " " + strSignalData[5] + " " + strSignalData[6] + " " + strSignalData[7] + " " +
                //              strSignalData[8] + " " + strSignalData[9] + " " + strSignalData[10] + " " + strSignalData[11]);
                System.arraycopy(arr, 4, canBuffer, 0, arr.length-4);
                if(canId.contains("403") && startBit.contains("25")) {
                    // CDI_PTHVbattStatus1 - ptHMIAvaDrvRange_CDI (里程)
                    hexValue = hexValue + "0x" + intToHex(canBuffer[3]) + intToHex(canBuffer[4]);
                }else if(canId.contains("322") && startBit.contains("39")) {
                    // FBCM_LampCmd - headWHLSpd_FBCM (車速)
                    byte originalValue = (byte) canBuffer[5];
                    byte mask = (byte) 0xF8; // 掩碼 11111000
                    byte result = (byte) (originalValue & mask); // 將第5位到第7位替換為0
                    hexValue = hexValue + "0x" + intToHex(canBuffer[4]) + byteToHex(result);
                }else{
                    // 實際起始位置跟excel檔案描述方式不同
                    int trueStartBit = Integer.valueOf((Integer.valueOf(startBit) + 1 - (Integer.valueOf(length))));
                    int canValue = (canBuffer[trueStartBit / 8] >>
                            trueStartBit % 8 &
                            Integer.valueOf((int) Math.pow(2, Integer.valueOf(length))) - 1);
                    hexValue = hexValue + "0x" + intToHex(canValue);
                }
            }
        }
        hexValue = hexValue.replace("0x0","0x");
        return hexValue;
    }

    /**
     * Converts a byte value to its hexadecimal representation.
     * Convert byte to hexadecimal string using Java built-in method.
     *
     * @param value The byte value to convert.
     * @return The hexadecimal representation of the byte value.
     ***/
    public static String byteToHex(byte value) {
        return String.format("%02X", value & 0xFF);
    }

    /**
     * Converts an integer value to its hexadecimal representation.
     *
     * @param value The integer value to convert.
     * @return The hexadecimal representation of the integer value.
     ***/
    public static String intToHex(int value) {
        return String.format("%02X", value);
    }

    /***
     * Finds the Hex Value Status using specific CAN IDs within received data.
     *
     * @param receivedData A string containing CAN signal data formatted according to standard.
     * @param selectMode An integer representing the selection:
     *                   0: Hex value status for tset.
     *                   1: Hex value status for Telltail.
     *                   2: Hex value status for Vehicle Status.
     *                   3: Hex value status for Telltail, Vehicle Status and DMS status.
     *                   4: Hex value status for DMS Status.
     ***/
    public static void findSpecificIDsForHexValueStatus(String receivedData, int selectMode) {
        Log.d(TAG, "dawi_findSpecificIDsForHexValueStatus");
        String[] canIdSignalsTable = SpecificCanIdDataset.getSpecificCanIdDatasets(selectMode);
        String[][] hexValueTable = HexValueLookup.gethexValueTable(selectMode);
        Map<String, String[]> correspondingTable = HexValueLookup.getCorrespondingTable(canIdSignalsTable, hexValueTable, selectMode);

        String[] dataSets = receivedData.split(";");
        // Record the specific ID that was processed
        Set<String> processedIDs = new HashSet<>();

        for (String dataSet : dataSets) {
            String[] signalData = parseSignalData(dataSet);
            for (String specificID : canIdSignalsTable) {
                // Check if a specific ID has already been processed
                if (!processedIDs.contains(specificID)) {
                    String hexValue = getHexValue(specificID, signalData);
                    if (!hexValue.isEmpty()) {
                        String result = HexValueLookup.getHexValueStatus(specificID, hexValue, correspondingTable);
                        Log.d(TAG, "hexValue: " + hexValue);
                        Log.d(TAG, "specificID: " + specificID);
                        Log.d(TAG, "hexValueStatus: " + result + "\n----------\n");
                    }
                    // Add processed specific ID to collection
                    processedIDs.add(specificID);
                }
            }
        }
    }

    public static int convertHexValueToDecimalValue(String hexValue){
        Log.d(TAG, "dawi_convertHexValueToDecimalValue");
        String trimmedString = hexValue.substring(2);
        int DecimalValue = Integer.parseInt(trimmedString, 16);
        Log.d(TAG, "DecimalValue: " + DecimalValue + "\n----------\n");
        return DecimalValue;
    }

    private static void testGetHexValue() { /* Test using a specificID to find the HexValue. */
        String receivedData = "53 01 09 09 00 90 67 1b 00 00 00 00;53 01 09 09 00 90 67 1b 00 00 00 00;53 01 0F 0C 00 90 67 1b 00 00 00 00;53 01 09 09 00 90 57 1b 00 00 00 00;53 01 0F 0C 00 90 67 1b 00 00 00 00;";
        String[] specificID2 = SpecificCanIdDataset.getSpecificCanIdDatasets(0);
        String myTestInput = specificID2[0]; // "0x199, 26, 3"
        String[] dataSets = receivedData.split(";");
        for (String dataSet : dataSets) {
            String[] signalData = parseSignalData(dataSet);
            String hexValue = getHexValue(myTestInput, signalData);
            if (!hexValue.isEmpty()) {
                Log.d(TAG, "hexValue: " + hexValue);
            }
        }
    }

    private static void testGetHexValueStatus() { /* Test using a specificID to find the HexValueStatus. */
        int selectMode = 0;
        String[][] hexValueTable = HexValueLookup.gethexValueTable(selectMode);
        String[] canIdSignalsTable = SpecificCanIdDataset.getSpecificCanIdDatasets(selectMode);
        Map<String, String[]> correspondingTable = HexValueLookup.getCorrespondingTable(canIdSignalsTable, hexValueTable, selectMode);
        String specificID = "0x199, 26, 3";
        String hexValue = "0x3";
        String hexValueStatus = HexValueLookup.getHexValueStatus(specificID, hexValue, correspondingTable);
        Log.d(TAG, "specificID: " + specificID);
        Log.d(TAG, "hexValueStatus: " + hexValueStatus);
    }

    public static void testSpecificIDsForHexValueStatus(){
        /* Test using multiple specificIDs to find the hexValue status on receivedDataSets. */
        String receivedData = "53 01 09 09 00 90 67 1b 00 00 00 00;53 01 09 09 00 90 67 1b 00 00 00 00;53 01 0F 0C 00 90 67 1b 00 00 00 00;53 01 09 09 00 90 57 1b 00 00 00 00;53 01 0F 0C 00 90 67 1b 00 00 00 00;";
        int selectMode = 0;
        findSpecificIDsForHexValueStatus(receivedData, selectMode);
    }

    public static void main(String[] args) {
        //testSpecificIDsForHexValueStatus();
    }
}
