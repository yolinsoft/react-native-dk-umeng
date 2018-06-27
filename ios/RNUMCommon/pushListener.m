//
//  pushListener.m
//  reactnativeUMCommon
//
//  Created by 马拉古 on 2018/6/13.
//  Copyright © 2018年 shanghaiDouke.com. All rights reserved.
//

#import "pushListener.h"
static NSString * const DidReceiveMessage = @"didReceiveMessage";
static NSString * const DidOpenMessage = @"didOpenMessage";
@implementation pushListener
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static pushListener *shareInstance = nil;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc]init];
    });
    return shareInstance;
}
//rn代码
- (NSArray<NSString *> *)supportedEvents
{
    return @[DidReceiveMessage,DidOpenMessage];
}

-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[pushListener new]sendEventWithName:DidReceiveMessage body:userInfo];
}

-(void)openRemoteNotification:(NSDictionary *)userInfo{
     [[pushListener new]sendEventWithName:DidOpenMessage body:userInfo];
}
@end
