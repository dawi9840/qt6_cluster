// IMyAidlInterface.aidl
package com.fxc.ev.driverprofile;

// Declare any non-default types here with import statements
import com.fxc.ev.driverprofile.IDriverCallback;
interface IDriverAidlInterface {
    /**
     * Demonstrates some basic types that you can use as parameters
     * and return values in AIDL.
     */
    void basicTypes(int anInt, long aLong, boolean aBoolean, float aFloat,
            double aDouble, String aString);
    void setDriverData(String item,String value);
    String getDriverData(String item);
    void registerCallback(IDriverCallback cb);
    void unregisterCallback(IDriverCallback cb);

}