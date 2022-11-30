//
//  EZPlatformViewFactory.h
//  ezopen_plugin
//
//  Created by 捡来的Mac on 2022/3/18.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface EZPlatformViewFactory : NSObject <FlutterPlatformViewFactory>

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end


@interface EZPlatformView : NSObject <FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;

@end

NS_ASSUME_NONNULL_END
