// IDataChangeListener.aidl
package com.fxc.ev.mediacenter;

// Declare any non-default types here with import statements
import com.fxc.ev.mediacenter.datastruct.MediaItem;
interface IDataChangeListener {
            void onContentChange(inout MediaItem item);
            void onStateChange(in int isPlaying);
            void onDurationChange(in long duration);

             /*void basicTypes(int anInt, long aLong, boolean aBoolean, float aFloat,
                        double aDouble, String aString);*/
}
