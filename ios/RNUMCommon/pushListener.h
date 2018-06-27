//
//  pushListener.h
//  reactnativeUMCommon
//
//  Created by 马拉古 on 2018/6/13.
//  Copyright © 2018年 shanghaiDouke.com. All rights reserved.
//

//#import "RCTEventEmitter.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
@interface pushListener : RCTEventEmitter<RCTBridgeModule>
+(instancetype)shareInstance;
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo;
-(void)openRemoteNotification:(NSDictionary *)userInfo;
@end
