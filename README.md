# react native 友盟分享、推送、统计

帮助应用或游戏快速具备国内外多平台分享、第三方登录功能，SDK 包最小，集成成本最低，平台覆盖最全，并基于友盟+大数据，提供最为权威、实时的用户画像、分享回流等数据分析，助力产品开发与推广。

基于【友盟+】全域数据建立与用户直接沟通的渠道。极简接入后，即可主动推送消息给 App 的终端用户，让用户实时实地的获取相关信息。可有效提升用户粘性，提高 App 活跃度。

国内专业的移动应用统计分析平台。我们帮助移动应用开发商统计和分析流量来源、内容使用、用户属性和行为数据，以便开发商利用数据进行产品、运营、推广策略的决策。

### 安装

> yarn add react-native-dk-umeng

#### 集成到 android

暂无介绍

#### 集成到 ios

暂无介绍

### 方法

#### 分享

| 方法名   | 参数     | 类型 | 描述 |
| -------- | -------- | ---- | ---- |
| function | {params} | func | mark |

#### 推送

| 方法名            | 参数 | 类型    | 描述                           |
| ----------------- | ---- | ------- | ------------------------------ |
| getDeviceToken    | 无   | promise | 获取 DeviceToken               |
| didReceiveMessage | 无   | promise | 接收到推送消息回调的方法       |
| didOpenMessage    | 无   | promise | 点击推送消息打开应用回调的方法 |

#### 统计

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
```
