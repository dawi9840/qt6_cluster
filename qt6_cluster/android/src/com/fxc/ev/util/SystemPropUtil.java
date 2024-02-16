package com.fxc.ev.util;

import java.lang.reflect.Method;

public class SystemPropUtil{
    static public void setprop(String key, String defaultValue) {

        String value = defaultValue;

        try {

            Class<?> c = Class.forName("android.os.SystemProperties");

            Method get = c.getMethod("set", String.class, String.class);

            get.invoke(c, key, value);

        } catch (Exception e) {

            e.printStackTrace();

        }
    }

    static public String getprop(String key, String defaultValue) {

        String value = defaultValue;

        try {

            Class<?> c = Class.forName("android.os.SystemProperties");

            Method get = c.getMethod("get", String.class, String.class);

            value = (String) (get.invoke(c, key, value));

        } catch (Exception e) {

            e.printStackTrace();

        } finally {
        }
        return value;

    }
}
