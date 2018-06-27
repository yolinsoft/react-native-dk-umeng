//
//  PushModule.m
//  UMComponent
//
//  Created by wyq.Cloudayc on 11/09/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "UMPushModule.h"
#import <UMPush/UMessage.h>
#import <React/RCTConvert.h>
#import <React/RCTEventDispatcher.h>
@interface UMPushModule()
@property (nonatomic, copy) NSString *token;
@end
@implementation UMPushModule

RCT_EXPORT_MODULE();

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static UMPushModule *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

//  /**未知错误*/
//  kUMessageErrorUnknown = 0,
//  /**响应出错*/
//  kUMessageErrorResponseErr = 1,
//  /**操作失败*/
//  kUMessageErrorOperateErr = 2,
//  /**参数非法*/
//  kUMessageErrorParamErr = 3,
//  /**条件不足(如:还未获取device_token，添加tag是不成功的)*/
//  kUMessageErrorDependsErr = 4,
//  /**服务器限定操作*/
//  kUMessageErrorServerSetErr = 5,
- (NSString *)checkErrorMessage:(NSInteger)code
{
  switch (code) {
    case 1:
      return @"响应出错";
      break;
    case 2:
      return @"操作失败";
      break;
    case 3:
      return @"参数非法";
      break;
    case 4:
      return @"条件不足(如:还未获取device_token，添加tag是不成功的)";
      break;
    case 5:
      return @"服务器限定操作";
      break;
    default:
      break;
  }
  return nil;
}

- (void)handleResponse:(id  _Nonnull)responseObject remain:(NSInteger)remain error:(NSError * _Nonnull)error resolver:(RCTPromiseResolveBlock)resolve
              rejecter:(RCTPromiseRejectBlock)reject
{
  if (resolve) {
    if (error) {
      NSString *msg = [self checkErrorMessage:error.code];
      if (msg.length == 0) {
        msg = error.localizedDescription;
      }
        reject(@(error.code).stringValue,msg,nil);
    } else {
      if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *retDict = responseObject;
        if ([retDict[@"success"] isEqualToString:@"ok"]) {
            resolve(@(0));
        } else {
            reject(@"1",@(remain).stringValue,nil);
        }
      } else {
           reject(@"1",@(remain).stringValue,nil);
      }
      
    }
  }
}

- (void)handleGetTagResponse:(NSSet * _Nonnull)responseTags remain:(NSInteger)remain error:(NSError * _Nonnull)error resolver:(RCTPromiseResolveBlock)resolve
                    rejecter:(RCTPromiseRejectBlock)reject
{
  if (resolve) {
    if (error) {
      NSString *msg = [self checkErrorMessage:error.code];
      if (msg.length == 0) {
        msg = error.localizedDescription;
      }
//      completion(@[@(error.code), @(remain), @[]]);
         reject(@(error.code).stringValue,msg,nil);
    } else {
      if ([responseTags isKindOfClass:[NSSet class]]) {
        NSArray *retList = responseTags.allObjects;
         resolve(@(0));
      } else {
         reject(@"1",@(remain).stringValue,nil);
      }
    }
  }
}
- (void)handleAliasResponse:(id  _Nonnull)responseObject error:(NSError * _Nonnull)error  resolver:(RCTPromiseResolveBlock)resolve
                   rejecter:(RCTPromiseRejectBlock)reject
{
  if (resolve) {
    if (error) {
      NSString *msg = [self checkErrorMessage:error.code];
      if (msg.length == 0) {
        msg = error.localizedDescription;
      }
       reject(@(error.code).stringValue,msg,nil);
    } else {
      if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *retDict = responseObject;
        if ([retDict[@"success"] isEqualToString:@"ok"]) {
          resolve(@(0));
        } else {
         reject(@"1",@"",nil);
        }
      } else {
         reject(@"1",@"",nil);
      }
      
    }
  }
}

-(void)registerWithAppkey:(NSString *)appkey launchOptions:(NSDictionary *)launchOptions{
//    UMessage
    // Push's basic setting
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert | UMessageAuthorizationOptionSound;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            
        } else {
            
        }
    }];
}

-(void)registerDeviceToken:(NSData *)deviceToken{
    self.token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                   stringByReplacingOccurrencesOfString: @">" withString: @""]
                  stringByReplacingOccurrencesOfString: @" " withString: @""];
   [UMessage registerDeviceToken:deviceToken];
}

-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [UMessage didReceiveRemoteNotification:userInfo];
}

-(void)setAutoAlert:(BOOL)autoAlert{
    [UMessage setAutoAlert:autoAlert];
}

RCT_EXPORT_METHOD(getDeviceToken:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
    if (self.token) {
        resolve(self.token);
    } else {
        reject(@"1",@"无token",nil);
    }
}

RCT_EXPORT_METHOD(addTag:(NSString *)tag resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  [UMessage addTags:tag response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
      [self handleResponse:responseObject remain:remain error:error resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject];
  }];
}

RCT_EXPORT_METHOD(deleteTag:(NSString *)tag resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  [UMessage deleteTags:tag response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
      [self handleResponse:responseObject remain:remain error:error resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject];
  }];
}

RCT_EXPORT_METHOD(listTagResolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  [UMessage getTags:^(NSSet * _Nonnull responseTags, NSInteger remain, NSError * _Nonnull error) {
      [self handleGetTagResponse:responseTags remain:remain error:error resolver:(RCTPromiseResolveBlock)resolve
                        rejecter:(RCTPromiseRejectBlock)reject];
  }];
}

RCT_EXPORT_METHOD(addAlias:(NSString *)name type:(NSString *)type resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  [UMessage addAlias:name type:type response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
      [self handleAliasResponse:responseObject error:error resolver:resolve rejecter:reject];
  }];
}

RCT_EXPORT_METHOD(addExclusiveAlias:(NSString *)name type:(NSString *)type resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  [UMessage setAlias:name type:type response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
      [self handleAliasResponse:responseObject error:error resolver:(RCTPromiseResolveBlock)resolve
                       rejecter:(RCTPromiseRejectBlock)reject];
  }];
}

RCT_EXPORT_METHOD(deleteAlias:(NSString *)name type:(NSString *)type resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  [UMessage removeAlias:name type:type response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
      [self handleAliasResponse:responseObject error:error resolver:(RCTPromiseResolveBlock)resolve
                       rejecter:(RCTPromiseRejectBlock)reject];
  }];
}



@end
