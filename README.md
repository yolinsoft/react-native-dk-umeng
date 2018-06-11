# react native 腾讯云通讯插件

云通信（Instant Messaging）承载亿级 QQ 用户即时通信技术，数十年技术积累，腾讯云为您提供超乎寻常即时通信聊天服务。

### 安装

#### ios

 添加以下依赖库

CoreTelephony.framework  
SystemConfiguration.framework  
libstdc++.6.dylib  
libc++.dylib  
libz.dylib  
libsqlite3.dylib

### 方法

| 方法名        | 参数                                    | 类型 | 描述                                                                               |
| ------------- | --------------------------------------- | ---- | ---------------------------------------------------------------------------------- |
| initSDK       | {sdkAppId:'',accountType:''}            | func | 设置 SDK 配置信息<br/>sdkAppId 应用 ID<br/>accountType 帐号体系                    |
| setUserConfig | {enableReadReceipt:true,accountType:''} | func | 设置用户的配置信息<br>enableReadReceipt 开启 C2C 已读回执<br/>accountType 帐号体系 |

集成问题

> 注意：  
> 使用互动直播业务的开发者，请集成 ImSDKv2 版本。
