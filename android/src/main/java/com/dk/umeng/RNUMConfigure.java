package com.dk.umeng;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build.VERSION_CODES;
import android.text.TextUtils;
import android.util.Log;

import com.umeng.commonsdk.UMConfigure;
import com.umeng.commonsdk.statistics.common.MLog;

/**
 * Created by wangfei on 17/9/14.
 */

public class RNUMConfigure {
    public static void init(Context context, String appkey, String channel, int type, String secret){
        initRN("react-native","1.0");
        if (TextUtils.isEmpty(secret)) {
            secret = getSecretByXML(context);
        }
        UMConfigure.init(context,appkey,channel,type,secret);
    }

    public static int getDeviceType(int num) {
        switch (num) {
            case 1:
                return UMConfigure.DEVICE_TYPE_PHONE;
            case 2:
                return UMConfigure.DEVICE_TYPE_BOX;
            default:
                return  UMConfigure.DEVICE_TYPE_PHONE;

        }
    }

    public static void setLogEnabled(boolean enabled){
        UMConfigure.setLogEnabled(enabled);
    }

    private static String getSecretByXML(Context context) {
        try {
            PackageManager manager = context.getPackageManager();
            ApplicationInfo infoXml = manager.getApplicationInfo(context.getPackageName(), 128);
            if (infoXml != null) {
                String secret = infoXml.metaData.getString("UMENG_MESSAGE_SECRET");
                if (secret != null) {
                    return secret.trim();
                }

                MLog.e("MobclickAgent", new Object[]{"getSecret failed. the applicationinfo is null!"});
            }
        } catch (Throwable e) {
            MLog.e("MobclickAgent", "Could not read UMENG_MESSAGE_SECRET meta-data from AndroidManifest.xml.", e);
        }

        return null;
    }
    
    @TargetApi(VERSION_CODES.KITKAT)
    private static void initRN(String v, String t){
        Method method = null;
        try {
            Class<?> config = Class.forName("com.umeng.commonsdk.UMConfigure");
            method = config.getDeclaredMethod("setWraperType", String.class, String.class);
            method.setAccessible(true);
            method.invoke(null, v,t);
        } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
