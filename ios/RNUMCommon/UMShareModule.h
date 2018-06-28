//
//  ShareModule.h
//  UMComponent
//
//  Created by wyq.Cloudayc on 11/09/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
@interface UMShareModule : RCTEventEmitter <RCTBridgeModule>
+(BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication  annotation:(id)annotation;
+(BOOL)handleOpenURL:(NSURL *)url;
@end

