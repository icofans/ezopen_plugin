//
//  EZPlatformViewFactory.m
//  ezopen_plugin
//
//  Created by 捡来的Mac on 2022/3/18.
//
#if TARGET_IPHONE_SIMULATOR//模拟器
#import "EZPlatformView.h"
@implementation EZPlatformViewFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
  }

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  return [[EZPlatformView alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
}

@end

@implementation EZPlatformView {
    UIView *_view;
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init]) {
      _view = [[UIView alloc] init];
      _messenger = messenger;
   [self initMethodChannel];

  }
  return self;
}


- (void)initMethodChannel {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"ezopen_plugin" binaryMessenger:_messenger];
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) { 
        result(@YES);
    }];
}
- (UIView*)view {
  return _view;
}
@end


#elif TARGET_OS_IPHONE//真机
#import "EZPlatformView.h"
#import <EZOpenSDKFramework/EZOpenSDK.h>
#import <EZOpenSDKFramework/EZDeviceInfo.h>
#import <EZOpenSDKFramework/EZPlayer.h>
#import <EZOpenSDKFramework/EZDeviceRecordFile.h>

@implementation EZPlatformViewFactory{
    NSObject<FlutterBinaryMessenger>* _messenger;
  }

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  return [[EZPlatformView alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
}

@end

@interface EZPlatformView ()<EZPlayerDelegate>

@end

@implementation EZPlatformView {
    UIView *_view;
    NSObject<FlutterBinaryMessenger>* _messenger;
    EZPlayer *player;
    EZPlayer *talkPlayer;
    EZDeviceInfo *deviceInfo;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init]) {
      _view = [[UIView alloc] init];
      _messenger = messenger;
      player = [EZOpenSDK createPlayerWithDeviceSerial:@"123" cameraNo:1];
      talkPlayer = [EZOpenSDK createPlayerWithDeviceSerial:@"123" cameraNo:1];
      [self initMethodChannel];
      [player destoryPlayer];
      [talkPlayer destoryPlayer];
      
  }
  return self;
}


- (void)initMethodChannel {
    NSLog(@"初始化消息通道");
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"ezopen_plugin" binaryMessenger:_messenger];
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        NSLog(@"接收到消息 --- [%@]",call.method);
        if ([@"start" isEqualToString:call.method]) {
            NSDictionary *data = call.arguments;
            [EZOpenSDK setAccessToken:data[@"token"]];
            /// 获取设备信息
            NSLog(@"获取设备信息!!!!");
            [EZOpenSDK getDeviceInfo:data[@"deviceSerial"] completion:^(EZDeviceInfo *deviceInfo, NSError *error) {
                NSLog(@"[设备信息如下] --- %@",deviceInfo);
                self->deviceInfo = deviceInfo;
            }];
            
            self->player = [EZOpenSDK createPlayerWithDeviceSerial:data[@"deviceSerial"] cameraNo:[data[@"cameraNo"] integerValue]];
            self->talkPlayer = [EZOpenSDK createPlayerWithDeviceSerial:data[@"deviceSerial"] cameraNo:[data[@"cameraNo"] integerValue]];
            NSString *verifyCode = data[@"verifyCode"];
            if (verifyCode != nil && ![verifyCode isEqualToString:@""]) {
                [self->player setPlayVerifyCode:verifyCode];
                [self->talkPlayer setPlayVerifyCode:verifyCode];
            } else {
                NSLog(@"verifyCode is null !!!");
            }
            [self->player setDelegate:self];
            [self->talkPlayer setDelegate:self];
            [self->player setPlayerView:self->_view];
            [self->player startRealPlay];
            result(@"开始播放");
        } else if ([@"end" isEqualToString:call.method]) {
            [self->player stopRealPlay];
            [self->player destoryPlayer];
            result(@"停止播放");
        } else if ([@"queryPlayback" isEqualToString:call.method]) {
            result(@"回放查询");
        }else if ([@"startRealPlay" isEqualToString:call.method]) {
            [self->player startRealPlay];
            result(@"startRealPlay");
        }else if ([@"stopRealPlay" isEqualToString:call.method]) {
            [self->player stopRealPlay];
            result(@"stopRealPlay");
        }else if ([@"startVoiceTalk" isEqualToString:call.method]) {
//            [self->player openSound];
            if (self->deviceInfo != nil) {
                // 0-不支持对讲，1-支持全双工对讲，3-支持半双工对讲，4-同时支持全双工和半双工
                if (self->deviceInfo.isSupportTalk == 0) {
                    NSLog(@"[设备不支持对讲]");
                } else if (self->deviceInfo.isSupportTalk == 1 || self->deviceInfo.isSupportTalk == 4 ) {
                        [self->talkPlayer startVoiceTalk];
                } else if (self->deviceInfo.isSupportTalk == 3) {
                    [self->talkPlayer audioTalkPressed:YES];
                }
            } else {
                [self->talkPlayer startVoiceTalk];
            }
            result(@"startVoiceTalk");
        }else if ([@"stopVoiceTalk" isEqualToString:call.method]) {
            if (self->deviceInfo != nil) {
                // 0-不支持对讲，1-支持全双工对讲，3-支持半双工对讲，4-同时支持全双工和半双工
                if (self->deviceInfo.isSupportTalk == 0) {
                    NSLog(@"[设备不支持对讲]");
                } else if (self->deviceInfo.isSupportTalk == 1 || self->deviceInfo.isSupportTalk == 4 ) {
                    [self->talkPlayer stopVoiceTalk];
                } else if (self->deviceInfo.isSupportTalk == 3) {
                    [self->talkPlayer audioTalkPressed:NO];
                }
            } else {
                [self->talkPlayer stopVoiceTalk];
            }
            result(@"stopVoiceTalk");
        }else if ([@"release" isEqualToString:call.method]) {
            [self->player destoryPlayer];
            [self->talkPlayer destoryPlayer];
            result(@"release");
        }else if ([@"EZPlayer_init" isEqualToString:call.method]) {
            NSDictionary *data = call.arguments;
            self->player = [EZOpenSDK createPlayerWithDeviceSerial:data[@"deviceSerial"] cameraNo:[data[@"cameraNo"] integerValue]];
            self->talkPlayer = [EZOpenSDK createPlayerWithDeviceSerial:data[@"deviceSerial"] cameraNo:[data[@"cameraNo"] integerValue]];
            NSString *verifyCode = data[@"verifyCode"];
            if (verifyCode != nil && ![verifyCode isEqualToString:@""]) {
                [self->player setPlayVerifyCode:verifyCode];
                [self->talkPlayer setPlayVerifyCode:verifyCode];
            } else {
                NSLog(@"verifyCode is null !!!");
            }
            [self->player setDelegate:self];
            [self->player setPlayerView:self->_view];
            result(@"init");
        }else if ([@"startPlayback" isEqualToString:call.method]) {
            NSDictionary *data = call.arguments;
            NSInteger startTime = [data[@"startTime"] integerValue];
            NSInteger endTime = [data[@"startTime"] integerValue];
            EZDeviceRecordFile *recordFile = [[EZDeviceRecordFile alloc] init];
            recordFile.type = 1;
            recordFile.channelType = @"D";
            recordFile.startTime = [NSDate dateWithTimeIntervalSince1970:startTime/1000];
            recordFile.stopTime = [NSDate dateWithTimeIntervalSince1970:endTime/1000];
            bool success = [self->player startPlaybackFromDevice:recordFile];
            result(@(success));
        } else if ([@"stopPlayback" isEqualToString:call.method]) {
            bool success = [self->player stopPlayback];
            result(@(success));
        } else if ([@"getOSDTime" isEqualToString:call.method]) {
            NSDate *date = [self->player getOSDTime];
            result(@([date timeIntervalSince1970]));
        } else if ([@"sound" isEqualToString:call.method]) {
            NSDictionary *data = call.arguments;
            bool isOpen = [data[@"Sound"] boolValue];
            if (isOpen) {
                [self->player openSound];
            } else {
                [self->player closeSound];
            }
            result(@(isOpen));
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
}


#pragma mark - PlayerDelegate Methods 播放器消息回调

/** 播放器播放失败消息回调 */
- (void)player:(EZPlayer *)aplayer didPlayFailed:(NSError *)error {
    NSLog(@"player: %@, didPlayFailed: %@", aplayer, error);
    // if ([aplayer isEqual:player]) {
    //     // [self playerPlayResult:NO];
    //     // self.playerPlayButton.hidden = YES;
    //     // self.playButton.enabled = YES;
    // } else {
    //     [_talkPlayer stopVoiceTalk];
    //     [self.voiceHud hide:YES];
    //     [UIView animateWithDuration:0.3
    //                      animations:^{
    //                          self.talkViewContraint.constant = self.bottomView.frame.size.height;
    //                          [self.bottomView setNeedsUpdateConstraints];
    //                          [self.bottomView layoutIfNeeded];
    //                      }
    //                      completion:^(BOOL finished) {
    //                          self.speakImageView.alpha = 0;
    //                          self.talkView.hidden = YES;
    //                      }];
    // }
    // // 如果是需要验证码或者是验证码错误
    // if (error.code == EZ_SDK_NEED_VALIDATECODE) {
    //     if (!_isSetPasswordAlertShow) {
    //         [self showSetPassword];
    //     }
    // } else if (error.code == EZ_SDK_VALIDATECODE_NOT_MATCH) {
    //     [self showRetry];
    // } else if (error.code == EZ_SDK_NOT_SUPPORT_TALK) {
    //     [EZToast show:[NSString stringWithFormat:@"%@(%d)",NSLocalizedString(@"not_support_talk", @"设备不支持对讲"), (int)error.code]];
    //     [self.voiceHud hide:YES];
    // } else {
    //     [EZToast show:[NSString stringWithFormat:@"错误码：%d", (int)error.code]];
    //     if ([player isEqual:_player]) {
    //         self.messageLabel.text = [NSString stringWithFormat:@"%@(%d)",NSLocalizedString(@"device_play_fail", @"播放失败"), (int)error.code];
    //         self.messageLabel.hidden = NO;
    //     } else {
            
    //     }
    // }
}

/** 播放器播放成功消息回调 */
- (void)player:(EZPlayer *)aplayer didReceivedMessage:(NSInteger)messageCode {
    NSLog(@"player: %@, didReceivedMessage: %d", aplayer, (int)messageCode);
    if (messageCode == PLAYER_REALPLAY_START) {
        [player closeSound];
    } else if (messageCode == PLAYER_VOICE_TALK_START) {
        /**
         非国标设备需要关闭播放器player的声音，设备和手机对讲都是通过talkPlayer来传输音频数据的，所以需要关闭player播放器的声音，避免干扰(萤石设备都是萤石协议，属于非国标设备)
         国标设备不能关闭。国标设备taklPlayer只负责采集手机端的声音，设备端的声音是通过player来播放的 */
        if (self->deviceInfo != nil && self->deviceInfo.devProtoEnum == 0) {
            [self->player closeSound];
        }
    } else if (messageCode == PLAYER_VOICE_TALK_END) {
        [self->player openSound];
    } else if (messageCode == PLAYER_NET_CHANGED) {

    }
}


- (UIView*)view {
  return _view;
}

@end

#endif
