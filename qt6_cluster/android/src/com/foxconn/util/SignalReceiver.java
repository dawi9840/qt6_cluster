package com.foxconn.util;

import android.util.Log;
import java.util.Queue;
import java.util.LinkedList;
import java.util.Iterator;

public class SignalReceiver {
    private static final String TAG = "SignalReceiver";
    private static final int MAX_QUEUE_SIZE = 30; // Set the maximum length of the queue

    /**
     * Converts the input vehicle signal data string into a Queue.
     *
     * @param inputSimulateCanSignals Input vehicle signal data string
     * @return Converted signal data Queue
     */
    public static Queue<String> getSignalQueue(String inputSimulateCanSignals) {
        Queue<String> tempQueue = new LinkedList<>();
        String[] signals = inputSimulateCanSignals.split(";");
        for (String signal : signals) {
            tempQueue.offer(signal.trim());
            // Check whether the maximum queue size is exceeded, if so, remove the queue
            // head element.
            while (tempQueue.size() > MAX_QUEUE_SIZE) {
                tempQueue.poll(); // Remove the element from the head of the queue
            }
        }
        Log.d(TAG, "dawi_tmpSignalQueue: " + tempQueue);
        return tempQueue;
    }

    /**
     * Combines strings inside the Queue into a single string with 
     * semicolons at the end of each string.
     *
     * @param signalQueue Signal data Queue
     * @return Merged signal data string with semicolons at the end of each signal
     */
    public static String getQueueToString(Queue<String> signalQueue) {
        StringBuilder stringBuilder = new StringBuilder();

        // Using an iterator to traverse a Queue
        Iterator<String> iterator = signalQueue.iterator();
        while (iterator.hasNext()) {
            String aString = iterator.next();
            stringBuilder.append(aString);
            stringBuilder.append(";"); // Add delimiters
            Log.d(TAG, "dawi_QueueToString: " + aString + ";\n");
        }
        return stringBuilder.toString();
    }

    /**
     * Simulated vehicle CAN signal data.
     * 
     * @param count Count used to simulate a specific number of vehicle signal data
     * @return Simulated vehicle signal data in string format
     */
    public static String simulateCanSignals(int count) {
        String receivedData = "53 01 09 09 00 90 67 1b 00 00 00 00;53 01 09 09 00 90 67 1b 00 00 00 00;53 01 0F 0C 00 90 67 1b 00 00 00 00;53 01 09 09 00 90 57 1b 00 00 00 00;53 01 0F 0C 00 90 67 1b 00 00 00 00;";
        while (count > 0) {
            receivedData += "53 01 09 09 00 90 67 1b 00 00 00 00;";
            count--;
        }
        Log.d(TAG, "dawi_receivedData: "+ receivedData);
        return receivedData;
    }

    public static void testReceiveCanSignalsToGetAStringData(){
        int count = 255;
        String inputSimulateCanSignals = simulateCanSignals(count);
        Queue<String> tmpSignalQueue = getSignalQueue(inputSimulateCanSignals);
        String aString = getQueueToString(tmpSignalQueue);
        Log.d(TAG, "dawi_aString: " + aString);
    }

    public static void main(String[] args) {
        //testReceiveCanSignalsToGetAStringData();
    }
}
