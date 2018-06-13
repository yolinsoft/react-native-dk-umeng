package com.dk.umeng;

import android.app.Activity;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import android.os.Handler;
import android.os.Looper;
import android.support.annotation.Nullable;
import android.util.Log;
import android.widget.Toast;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.umeng.message.MsgConstant;
import com.umeng.message.PushAgent;
import com.umeng.message.UTrack;
import com.umeng.message.common.UmengMessageDeviceConfig;
import com.umeng.message.common.inter.ITagManager;
import com.umeng.message.entity.UMessage;
import com.umeng.message.tag.TagManager;

import org.json.JSONObject;

/**
 * Created by wangfei on 17/8/30
 */

public class PushModule extends ReactContextBaseJavaModule implements LifecycleEventListener {
    private final int SUCCESS = 200;
    private final int ERROR = 0;
    private final int CANCEL = -1;

    protected static final String TAG = PushModule.class.getSimpleName();
    protected static final String DidReceiveMessage = "DidReceiveMessage";
    protected static final String DidOpenMessage = "DidOpenMessage";

    private static Handler mSDKHandler = new Handler(Looper.getMainLooper());
    private ReactApplicationContext context;
    private boolean isGameInited = false;
    private static Activity ma;
    private PushAgent mPushAgent;
    private Handler handler;
    private PushApplication mPushApplication;

    public PushModule(ReactApplicationContext reactContext) {
        super(reactContext);
        context = reactContext;
        //设置module给application
        PushApplication application = (PushApplication)reactContext.getBaseContext();
        mPushApplication  = application;
        //添加监听
        context.addLifecycleEventListener(this);
        mPushAgent = PushAgent.getInstance(context);
    }

    public static void initPushSDK(Activity activity) {
        ma = activity;
    }

    @Override
    public String getName() {
        return "UMPushModule";
    }

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put(DidReceiveMessage, DidReceiveMessage);
        constants.put(DidOpenMessage, DidOpenMessage);
        return constants;
    }

    private static void runOnMainThread(Runnable runnable) {
        mSDKHandler.postDelayed(runnable, 0);
    }

    @ReactMethod
    public void addTag(String tag, final Callback successCallback) {
        mPushAgent.getTagManager().addTags(new TagManager.TCallBack() {
            @Override
            public void onMessage(final boolean isSuccess, final ITagManager.Result result) {


                        if (isSuccess) {
                            successCallback.invoke(SUCCESS,result.remain);
                        } else {
                            successCallback.invoke(ERROR,0);
                        }

            }
        }, tag);
    }

    @ReactMethod
    public void deleteTag(String tag, final Callback successCallback) {
        mPushAgent.getTagManager().deleteTags(new TagManager.TCallBack() {
            @Override
            public void onMessage(boolean isSuccess, final ITagManager.Result result) {
                Log.i(TAG, "isSuccess:" + isSuccess);
                if (isSuccess) {
                    successCallback.invoke(SUCCESS,result.remain);
                } else {
                    successCallback.invoke(ERROR,0);
                }
            }
        }, tag);
    }

    @ReactMethod
    public void listTag(final Callback successCallback) {
        mPushAgent.getTagManager().getTags(new TagManager.TagListCallBack() {
            @Override
            public void onMessage(final boolean isSuccess, final List<String> result) {
                mSDKHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        if (isSuccess) {
                            if (result != null) {

                                successCallback.invoke(SUCCESS,resultToList(result));
                            } else {
                                successCallback.invoke(ERROR,resultToList(result));
                            }
                        } else {
                            successCallback.invoke(ERROR,resultToList(result));
                        }

                    }
                });

            }
        });
    }

    @ReactMethod
    public void addAlias(String alias, String aliasType, final Callback successCallback) {
        mPushAgent.addAlias(alias, aliasType, new UTrack.ICallBack() {
            @Override
            public void onMessage(final boolean isSuccess, final String message) {
                Log.i(TAG, "isSuccess:" + isSuccess + "," + message);

                        Log.e("xxxxxx","isuccess"+isSuccess);
                        if (isSuccess) {
                            successCallback.invoke(SUCCESS);
                        } else {
                            successCallback.invoke(ERROR);
                        }


            }
        });
    }

    @ReactMethod
    public void addAliasType() {
        Toast.makeText(ma,"function will come soon",Toast.LENGTH_LONG);
    }

    @ReactMethod
    public void addExclusiveAlias(String exclusiveAlias, String aliasType, final Callback successCallback) {
        mPushAgent.setAlias(exclusiveAlias, aliasType, new UTrack.ICallBack() {
            @Override
            public void onMessage(final boolean isSuccess, final String message) {

                        Log.i(TAG, "isSuccess:" + isSuccess + "," + message);
                        if (Boolean.TRUE.equals(isSuccess)) {
                            successCallback.invoke(SUCCESS);
                        }else {
                            successCallback.invoke(ERROR);
                        }



            }
        });
    }

    @ReactMethod
    public void deleteAlias(String alias, String aliasType, final Callback successCallback) {
        mPushAgent.deleteAlias(alias, aliasType, new UTrack.ICallBack() {
            @Override
            public void onMessage(boolean isSuccess, String s) {
                if (Boolean.TRUE.equals(isSuccess)) {
                    successCallback.invoke(SUCCESS);
                }else {
                    successCallback.invoke(ERROR);
                }
            }
        });
    }

    @ReactMethod
    public void appInfo(final Callback successCallback) {
        String pkgName = context.getPackageName();
        String info = String.format("DeviceToken:%s\n" + "SdkVersion:%s\nAppVersionCode:%s\nAppVersionName:%s",
            mPushAgent.getRegistrationId(), MsgConstant.SDK_VERSION,
            UmengMessageDeviceConfig.getAppVersionCode(context), UmengMessageDeviceConfig.getAppVersionName(context));
        successCallback.invoke("应用包名:" + pkgName + "\n" + info);
    }

    private WritableArray resultToList(List<String> result){
        WritableArray list = Arguments.createArray();
        if (result!=null){
            for (String key:result){
                list.pushString(key);
            }
        }
        Log.e("xxxxxx","list="+list);
        return list;
    }

    private WritableMap convertToWriteMap(UMessage msg) {
        WritableMap map = Arguments.createMap();
        //遍历Json
        JSONObject jsonObject = msg.getRaw();
        Iterator<String> keys = jsonObject.keys();
        String key;
        while (keys.hasNext()) {
            key = keys.next();
            try {
                map.putString(key, jsonObject.get(key).toString());
            }
            catch (Exception e) {
                Log.e(TAG, "putString fail");
            }
        }
        return map;
    }

    /*
    * 获取设备id
    */
    @ReactMethod
    public void getDeviceToken(Promise promise) {
        String registrationId = mPushAgent.getRegistrationId();
        promise.resolve(registrationId);
    }

    protected void sendEvent(String eventName, UMessage msg) {
        sendEvent(eventName, convertToWriteMap(msg));
    }

    private void sendEvent(String eventName, @Nullable WritableMap params) {
        //此处需要添加hasActiveCatalystInstance，否则可能造成崩溃
        //问题解决参考: https://github.com/walmartreact/react-native-orientation-listener/issues/8
        if(context.hasActiveCatalystInstance()) {
            Log.i(TAG, "hasActiveCatalystInstance");
            context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(eventName, params);
        }
        else {
            Log.i(TAG, "not hasActiveCatalystInstance");
        }
    }

    @Override
    public void onHostResume() {
        mPushApplication.setmPushModule(this);
    }

    @Override
    public void onHostPause() {
    }

    @Override
    public void onHostDestroy() {
        mPushApplication.setmPushModule(null);
    }
}