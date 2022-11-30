package com.hiveintel.ezopen_plugin;


import android.app.Application;
import android.content.Context;
import android.view.View;

import androidx.annotation.NonNull;

import com.videogo.openapi.EZOpenSDK;

import org.jetbrains.annotations.NotNull;

import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class EZPlatformViewFactory extends PlatformViewFactory implements MethodChannel.MethodCallHandler {
    @NonNull private final BinaryMessenger messenger;
    private Application application;

    public EZPlatformViewFactory(@NonNull BinaryMessenger messenger,Application application) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        this.application = application;

        new MethodChannel(messenger, "ezopen_plugin/plugin").setMethodCallHandler(this);
    }

    @Override
    public PlatformView create(Context context, int id, Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        return new EZPlatformView(context, id, creationParams,this.messenger, this.application);
    }

    @Override
    public void onMethodCall(@NotNull MethodCall call, @NotNull MethodChannel.Result result) {

        if (call.method.equals("init_sdk")) {
            String appKey = call.argument("appKey");
            Log.d("h","appKey = " + appKey);
            /** * sdk日志开关，正式发布需要去掉 */
            EZOpenSDK.showSDKLog(false);
            /** * 设置是否支持P2P取流,详见api */
            EZOpenSDK.enableP2P(false);
            result.success(EZOpenSDK.initLib(this.application,appKey));
        } else if (call.method.equals("set_access_token")) {
            String AccessToken = call.argument("accessToken");
            EZOpenSDK.getInstance().setAccessToken(AccessToken);
            result.success(true);
        } else if (call.method.equals("destoryLib")) {
//            EZOpenSDK.finiLib();
            result.success(true);
        } else {
            result.notImplemented();
        }
    }
}
