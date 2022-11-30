#if TARGET_IPHONE_SIMULATOR//模拟器
#import "EZOpenPlugin.h"
#import "EZPlatformView.h"

@implementation EZOpenPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

  
    EZPlatformViewFactory* factory = [[EZPlatformViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:factory withId:@"ezopen_plugin/message"];

  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"ezopen_plugin/plugin"
            binaryMessenger:[registrar messenger]];
  EZOpenPlugin* instance = [[EZOpenPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"init_sdk" isEqualToString:call.method]) {
      // NSDictionary *data = call.arguments;
      // bool success = [EZOpenSDK initLibWithAppKey:data[@"appKey"]];
      result(@YES);
  } else if ([@"set_access_token" isEqualToString:call.method]) {
      // NSDictionary *data = call.arguments;
    //  [EZOpenSDK setAccessToken:data[@"accessToken"]];
      result(@YES);
  } else if ([@"destoryLib" isEqualToString:call.method]) {
      // bool success =  [EZOpenSDK destoryLib];
      result(@YES);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end

#elif TARGET_OS_IPHONE//真机
#import "EZOpenPlugin.h"
#import "EZPlatformView.h"
#import <EZOpenSDKFramework/EZOpenSDK.h>

@implementation EZOpenPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

  
  EZPlatformViewFactory* factory = [[EZPlatformViewFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:factory withId:@"ezopen_plugin/videoView"];

  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"ezopen_plugin/plugin"
            binaryMessenger:[registrar messenger]];
  EZOpenPlugin* instance = [[EZOpenPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"init_sdk" isEqualToString:call.method]) {
      NSDictionary *data = call.arguments;
      bool success = [EZOpenSDK initLibWithAppKey:data[@"appKey"]];
      result(@(success));
  } else if ([@"set_access_token" isEqualToString:call.method]) {
      NSDictionary *data = call.arguments;
     [EZOpenSDK setAccessToken:data[@"accessToken"]];
      result(@YES);
  } else if ([@"destoryLib" isEqualToString:call.method]) {
      bool success =  [EZOpenSDK destoryLib];
      result(@(success));
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
#endif