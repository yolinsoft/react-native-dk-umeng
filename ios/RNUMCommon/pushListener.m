//
//  pushListener.m
//  reactnativeUMCommon
//
//  Created by 马拉古 on 2018/6/13.
//  Copyright © 2018年 shanghaiDouke.com. All rights reserved.
//

#import "pushListener.h"
static NSString * const recivePushNoti = @"recivePushNoti";
static NSString * const openPushNoti = @"openPushNoti";
static NSString * const DidReceiveMessage = @"didReceiveMessage";
static NSString * const DidOpenMessage = @"didOpenMessage";
@implementation pushListener
{
    bool _hasListeners;
}
RCT_EXPORT_MODULE();
//rn代理
- (NSArray<NSString *> *)supportedEvents
{
    return @[DidReceiveMessage,DidOpenMessage];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                      selector:@selector(didReceivNoti:)
                                                          name:recivePushNoti
                                                        object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openMsg:) name:openPushNoti object:nil];
    }
    return self;
}

- (void)startObserving
{
    _hasListeners = YES;
}
- (void)stopObserving
{
    
    _hasListeners = NO;
}

-(void)didReceivNoti:(NSNotification *)notification{
    
    if (_hasListeners) {
        [self sendEventWithName:DidReceiveMessage
                           body:notification.userInfo];
    }
}

-(void)openMsg:(NSNotification *)notification{
    
    if (_hasListeners) {
         [self sendEventWithName:DidOpenMessage body:notification.userInfo];
    }
}

@end
