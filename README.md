# react native 友盟分享、推送、统计

帮助应用或游戏快速具备国内外多平台分享、第三方登录功能，SDK 包最小，集成成本最低，平台覆盖最全，并基于友盟+大数据，提供最为权威、实时的用户画像、分享回流等数据分析，助力产品开发与推广。

基于【友盟+】全域数据建立与用户直接沟通的渠道。极简接入后，即可主动推送消息给 App 的终端用户，让用户实时实地的获取相关信息。可有效提升用户粘性，提高 App 活跃度。

国内专业的移动应用统计分析平台。我们帮助移动应用开发商统计和分析流量来源、内容使用、用户属性和行为数据，以便开发商利用数据进行产品、运营、推广策略的决策。

### 安装

> yarn add react-native-dk-umeng

#### 集成到 android

settings.gradle

```
include ':react-native-dk-umeng'
project(':react-native-dk-umeng').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-dk-umeng/android')
include ':push'
project(':push').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-dk-umeng/android/push')
```

app/build.gradle

```
defaultConfig {
  ...
  // Enabling multidex support.
  multiDexEnabled true
}

...

dependencies {
    compile 'com.android.support:multidex:1.0.0'
    compile project(':react-native-dk-umeng')
    ...
}
```

AndroidManifest.xml

```
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>

<uses-permission android:name="android.permission.READ_LOGS" />
<uses-permission android:name="android.permission.CALL_PHONE" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<!-- QQ、QQ空间所需权限 -->
<uses-permission android:name="android.permission.GET_TASKS" />
<uses-permission android:name="android.permission.SET_DEBUG_APP" />
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
<uses-permission android:name="android.permission.GET_ACCOUNTS" />
<uses-permission android:name="android.permission.USE_CREDENTIALS" />

...

<meta-data
    android:name="UMENG_APPKEY"
    android:value="****" >
</meta-data>
<meta-data
    android:name="UMENG_CHANNEL"
    android:value="****" >
</meta-data>
  <meta-data
      android:name="UMENG_MESSAGE_SECRET"
      android:value="****" >
  </meta-data>
<activity
      android:name=".wxapi.WXEntryActivity"
      android:configChanges="keyboardHidden|orientation|screenSize"
      android:exported="true"
      android:screenOrientation="portrait"
      android:theme="@android:style/Theme.Translucent.NoTitleBar" />
<activity
      android:name="com.tencent.tauth.AuthActivity"
      android:launchMode="singleTask"
      android:noHistory="true" >
      <intent-filter>
          <action android:name="android.intent.action.VIEW" />
          <category android:name="android.intent.category.DEFAULT" />
          <category android:name="android.intent.category.BROWSABLE" />
          <data android:scheme="tencent1103418210" />
      </intent-filter>
  </activity>
  <activity
      android:name="com.tencent.connect.common.AssistActivity"
      android:screenOrientation="portrait"
      android:theme="@android:style/Theme.Translucent.NoTitleBar"
      android:configChanges="orientation|keyboardHidden|screenSize"/>
```

包名下添加 wxapi 文件夹,然后添加WXEntryActivity.java
路径 java/com/.../wxapi/WXEntryActivity.java

WXEntryActivity.java

```
package com.****.wxapi;

import com.umeng.socialize.weixin.view.WXCallbackActivity;

public class WXEntryActivity extends WXCallbackActivity {

}
```

MainActivity.java

```
import android.content.Intent;
...
import com.umeng.analytics.MobclickAgent;
import com.umeng.analytics.MobclickAgent.EScenarioType;
import com.umeng.socialize.UMShareAPI;
import com.dk.umeng.PushModule;
import com.dk.umeng.ShareModule;

...

@Override
protected void onCreate(Bundle savedInstanceState) {
    ...
    ShareModule.initSocialSDK(this);
    PushModule.initPushSDK(this);
    MobclickAgent.setSessionContinueMillis(1000);
    MobclickAgent.setScenarioType(this, EScenarioType.E_DUM_NORMAL);
    MobclickAgent.openActivityDurationTrack(false);
}

...

@Override
public void onResume() {
    super.onResume();
    MobclickAgent.onResume(this);
}

@Override
protected void onPause() {
    super.onPause();
    MobclickAgent.onPause(this);
}

@Override
protected void onDestroy() {
    super.onDestroy();
    MobclickAgent.onKillProcess(this);
}

@Override
public void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    UMShareAPI.get(this).onActivityResult(requestCode, resultCode, data);
}
```

MainApplication.java

```
import com.dk.umeng.PushApplication;
import com.dk.umeng.DplusReactPackage;
import com.dk.umeng.RNUMConfigure;

...

public class MainApplication extends PushApplication implements ReactApplication {

  ...

  @Override
  protected List<ReactPackage> getPackages() {
    return Arrays.<ReactPackage>asList(
        ...

        new DplusReactPackage()
    );
  }

  @Override
  public void onCreate() {
    ...

    if(BuildConfig.DEBUG) {
        RNUMConfigure.setLogEnabled(true);
    }
    //初始化组件化基础库, 统计SDK/推送SDK/分享SDK都必须调用此初始化接口
    RNUMConfigure.init(this, null,null,RNUMConfigure.getDeviceType(1),null);
  }
}
```


#### 集成到 ios

加入以下系统库

```
libsqlite3.tbd
CoreGraphics.framework
Photos.framework
```

配置URL Scheme

URL Scheme是通过系统找到并跳转对应app的一类设置，通过向项目中的info.plist文件中加入URL types可使用第三方平台所注册的appkey信息向系统注册你的app，当跳转到第三方应用授权或分享后，可直接跳转回你的app。

添加URL Types可工程设置面板设置

平台 | 格式 | 举例 | 备注 
---- | ---- | ----| ---- 
微信 | 微信appKey | wxdc1e388c3822c80b |

其他平台请参考umeng官方 https://developer.umeng.com/docs/66632/detail/66825

AppDelegate.m

```
#import <UserNotifications/UserNotifications.h>
#import "RNUMConfigure.h"
#import "UMPushModule.h"
#import "pushListener.h"
#import "UMShareModule.h"

static NSString * const recivePushNoti = @"recivePushNoti";
static NSString * const openPushNoti = @"openPushNoti";
@interface AppDelegate()<UNUserNotificationCenterDelegate>
@end

...

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
  NSString *filePath = [[NSBundle mainBundle]pathForResource:@"Info" ofType:@"plist"];
  NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:filePath];
  NSString *UMENG_APPKEY = dic[@"UMENG_APPKEY"];
  NSString *UMENG_CHANNEL   = dic[@"UMENG_CHANNEL"];
  NSString *UMENG_MESSAGE_SECRET = dic[@"UMENG_MESSAGE_SECRET"];
  
  //友盟sdk公共配置
  [RNUMConfigure initWithAppkey:UMENG_APPKEY channel:UMENG_CHANNEL];
  [UNUserNotificationCenter currentNotificationCenter].delegate=self;
  //友盟注册推送
  [UMPushModule registerWithAppkey:UMENG_MESSAGE_SECRET launchOptions:launchOptions];

  ...
}

//iOS10以下使用这两个方法接收通知，友盟
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
  [UMPushModule setAutoAlert:NO];
  if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
    [UMPushModule didReceiveRemoteNotification:userInfo];
    [[NSNotificationCenter defaultCenter]postNotificationName:recivePushNoti object:nil userInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
  }
}

//友盟
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
  //关闭友盟自带的弹出框
  [UMPushModule setAutoAlert:NO];
  [UMPushModule didReceiveRemoteNotification:userInfo];
  [[NSNotificationCenter defaultCenter]postNotificationName:recivePushNoti object:nil userInfo:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法 友盟
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
  NSDictionary * userInfo = notification.request.content.userInfo;
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //应用处于前台时的远程推送接受
    //关闭U-Push自带的弹出框
    [UMPushModule setAutoAlert:NO];
    //必须加这句代码
    [UMPushModule didReceiveRemoteNotification:userInfo];
    [[NSNotificationCenter defaultCenter]postNotificationName:recivePushNoti object:nil userInfo:userInfo];
  }else{
    //应用处于前台时的本地推送接受
  }
  //当应用处于前台时提示设置，需要哪个可以设置哪一个
  completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法 友盟
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //应用处于后台时的远程推送接受
    //必须加这句代码
    [UMPushModule didReceiveRemoteNotification:userInfo];
    [[NSNotificationCenter defaultCenter]postNotificationName:openPushNoti object:nil userInfo:userInfo];
  }else{
    //应用处于后台时的本地推送接受
  }
}

//友盟
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"token=====%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
  [UMPushModule  registerDeviceToken:deviceToken];
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误 友盟
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
  NSLog(@"注册deviceToken失败%@",error);
}

// 支持所有iOS系统友盟分享回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
  //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
  BOOL result = [UMShareModule handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
  if (!result) {
    // 其他如支付等SDK的回调
  }
  return result;
}

//友盟分享回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
  BOOL result = [UMShareModule handleOpenURL:url];
  if (!result) {
    // 其他如支付等SDK的回调
  }
  return result;
}

@end
```

Info.plist

```
<key>UMENG_APPKEY</key>
<string>****</string>
<key>UMENG_CHANNEL</key>
<string>****</string>
<key>UMENG_MESSAGE_SECRET</key>
<string>****</string>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>wechat</string>
  <string>weixin</string>
  <string>sinaweibohd</string>
  <string>sinaweibo</string>
  <string>sinaweibosso</string>
  <string>weibosdk</string>
  <string>weibosdk2.5</string>
  ...
  // 更多请在这里添加
</array>
```

### 方法

#### 分享

| 方法名   | 参数     | 类型 | 描述 |
| -------- | -------- | ---- | ---- |
| setAccount | {type: 0,appId: '',secret: '',redirectURL: ''} | func | 设置平台秘钥<br />type 0: QQ 1:Sina 2:WeiXin |
| share | {title: '',text: '',image:'',weburl: '',sharemedia: 0 } | func | 无面板分享<br />type 0:QQ 1:SINA 2:WEIXIN 3:WEIXIN_CIRCLE 4:QZONE 6:SHARE_MEDIA.SMS |

#### 推送

| 方法名            | 参数 | 类型    | 描述                           |
| ----------------- | ---- | ------- | ------------------------------ |
| getDeviceToken    | 无   | promise | 获取 DeviceToken               |
| didReceiveMessage | 无   | promise | 接收到推送消息回调的方法       |
| didOpenMessage    | 无   | promise | 点击推送消息打开应用回调的方法 |

#### 统计

暂无

### 集成问题

#### 1.安卓集成获取不到 deviceToken 问题

确定是否将 appkey、MessageSecret、以及包名都更换为开发者所申请的相应值

如果获取不到 deviceToken 也接收不到推送，请查看友盟后台的包名是否一致，当前设备是否添加到测试设备当中

Android Studio 中 gradle 的版本需要在 1.5.0 或者以上

更多 DeviceToken 相关问题，[请参考 Device_token 相关问题整理【安卓版】](http://bbs.umeng.com/thread-15233-1-1.html)

### 示例

```
import { UMPush, UMShare, UMAnalytics } from 'react-native-dk-umeng';

UMPush.getDeviceToken().then(token => {
  console.warn(['getDeviceToken', token]);
});

UMPush.didReceiveMessage().then(res => {
  console.warn(['didReceiveMessage', res]);
});

UMPush.didOpenMessage().then(res => {
  console.warn(['didOpenMessage', res]);
});

UMShare.setAccount({
  type: 0,
  appId: '****',
  secret: '****',
  redirectURL: ''
});
UMShare.setAccount({
  type: 2,
  appId: '****',
  secret: '****',
  redirectURL: ''
});

UMShare.share({
  title: '分享标题',
  text: '分享内容',
  image:'',
  weburl: '',
  sharemedia: 2
}).then(
  res => {
    console.warn(['res', res]);
  },
  err => {
    console.warn(['err', err]);
  }
);
```
