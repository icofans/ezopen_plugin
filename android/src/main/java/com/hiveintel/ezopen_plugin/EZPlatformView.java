package com.hiveintel.ezopen_plugin;

import android.annotation.SuppressLint;
import android.app.Application;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.gson.Gson;
import com.videogo.errorlayer.ErrorInfo;
import com.videogo.exception.BaseException;
import com.videogo.openapi.EZConstants;
import com.videogo.openapi.EZOpenSDK;
import com.videogo.openapi.EZPlayer;
import com.videogo.openapi.bean.EZDeviceRecordFile;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;

public class EZPlatformView implements PlatformView, MethodChannel.MethodCallHandler {
    @NonNull private final BinaryMessenger messenger;
    private static final String CHANNEL = "ezopen_plugin";
    private Application application;
    private SurfaceView surfaceView;
    private EZPlayer ezPlayer = null;
    BasicMessageChannel<Object> messageChannel;
    List<EZDeviceRecordFile> ezDeviceRecordFiles = null;
    Object queryVideoLock = new Object();

    public EZPlatformView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams, BinaryMessenger messenger, Application application) {
        this.messenger = messenger;
        this.application = application;
        new MethodChannel(messenger,CHANNEL).setMethodCallHandler(this);
        messageChannel = new BasicMessageChannel<>(messenger, "ezopen_plugin/message", new StandardMessageCodec());

        surfaceView = new SurfaceView(context);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if(call.method.equals("startRealPlay")) {
            ezPlayer.startRealPlay();
            result.success("success");
        }
        else if (call.method.equals("stopRealPlay")) {
            ezPlayer.stopRealPlay();
            result.success("success");
        }
        else if (call.method.equals("startVoiceTalk")) {
            ezPlayer.startVoiceTalk();
            result.success("success");
        }
        else if (call.method.equals("stopVoiceTalk")) {
            ezPlayer.stopVoiceTalk();
            result.success("success");
        }
        else if (call.method.equals("release")) {
            ezPlayer.release();
            result.success("success");
        }
        else if (call.method.equals("queryPlayback")) {

            final long callBackFuncId = call.argument("callBackFuncId");
            final long startTime = call.argument("startTime");
            final long endTime = call.argument("endTime");
            final String deviceSerial = call.argument("deviceSerial");
            String verifyCode = call.argument("verifyCode");
            final int cameraNo = call.argument("cameraNo");

            final Calendar startCalendar = Calendar.getInstance();
            startCalendar.setTimeInMillis(startTime);

            final Calendar endCalendar = Calendar.getInstance();
            endCalendar.setTimeInMillis(endTime);

            final Looper looper = Looper.myLooper();
            // Android 4.0 之后不能在主线程中请求HTTP请求
            new Thread(new Runnable(){
                @Override
                public void run() {
                    try {
                        List<EZDeviceRecordFile> ezDeviceRecordFiles = EZOpenSDK.getInstance().searchRecordFileFromDevice(deviceSerial, cameraNo, startCalendar, endCalendar);
                        // 发送消息给flutter
                        final String jsonString = new Gson().toJson(ezDeviceRecordFiles);

                        new Handler(looper).post(new Runnable() {
                            @Override
                            public void run() {
                                EZRecordFile recordFile = new EZRecordFile("RecordFile", jsonString);
                                recordFile.setCallBackFuncId(callBackFuncId);
                                messageChannel.send(new Gson().toJson(recordFile));
                            }
                        });

                    } catch (BaseException e) {
                        e.printStackTrace();
                    }
                }
            }).start();

            result.success("success");

        }
        else if (call.method.equals("EZPlayer_init")){
            String deviceSerial = call.argument("deviceSerial");
            String verifyCode = call.argument("verifyCode");
            int cameraNo = call.argument("cameraNo");

            ezPlayer  = EZOpenSDK.getInstance().createPlayer(deviceSerial, cameraNo);
            ezPlayer.setHandler(new EZViewHander());
            ezPlayer.setSurfaceHold(surfaceView.getHolder());
            //设置播放器的显示Surface
            surfaceView.getHolder().addCallback(new SurfaceHolder.Callback() {
                @Override
                public void surfaceCreated(@NonNull SurfaceHolder holder) {
                    if (ezPlayer != null) {
                        ezPlayer.setSurfaceHold(holder);
                    }
                }

                @Override
                public void surfaceChanged(@NonNull SurfaceHolder holder, int format, int width, int height) {

                }

                @Override
                public void surfaceDestroyed(@NonNull SurfaceHolder holder) {
                    if (ezPlayer != null) {
                        ezPlayer.setSurfaceHold(null);
                    }
//                    mRealPlaySh = null;

                }
            });
            ezPlayer.setSurfaceHold(surfaceView.getHolder());

            ezPlayer.setPlayVerifyCode(verifyCode);
            result.success("success");
        }
        else if (call.method.equals("startPlayback")) {

            long startTime = call.argument("startTime");
            long endTime = call.argument("endTime");

//            EZOpenSDK.enableP2P(true);
//            EZOpenSDK.showSDKLog(true);

            final Calendar startCalendar = Calendar.getInstance();
            startCalendar.setTimeInMillis(startTime);

            final Calendar endCalendar = Calendar.getInstance();
            endCalendar.setTimeInMillis(endTime);
            boolean b = ezPlayer.startPlayback(startCalendar, endCalendar);
            result.success(b);
        }
        else if (call.method.equals("stopPlayback")) {
            ezPlayer.stopPlayback(); // 停止回放
            result.success("success");
        }
        else if (call.method.equals("sound")) {
            Boolean bool = call.argument("Sound");
            if(bool) {
                ezPlayer.openSound();
            } else {
                ezPlayer.closeSound();
            }
            result.success("success");
        }
        else if (call.method.equals("getOSDTime")) {
            Calendar osdTime = ezPlayer.getOSDTime();
            if(null != osdTime){
                long timeInMillis = osdTime.getTimeInMillis();
                result.success(timeInMillis);
            } else {
                result.success(0);
            }
        }
        else if (call.method.equals("pausePlayback")) {
            Calendar osdTime = ezPlayer.getOSDTime();
            ezPlayer.pausePlayback(); // 暂停回放
            long timeInMillis = osdTime.getTimeInMillis();
            result.success(timeInMillis);
        }
        else if (call.method.equals("resumePlayback")) {
            ezPlayer.resumePlayback(); // 恢复回放
            result.success("success");
        }
        else if (call.method.equals("test")) {
            String token = call.argument("token");
            Log.d("h","test = " + token);
            result.success("success");
        }
        else {
          result.notImplemented();
        }
    }

    public void sendTimeToFlutter() {

    }

    @Override
    public View getView() {
        return surfaceView;
    }

    @Override
    public void dispose() {
        if(null != ezPlayer) {
            ezPlayer.release();
        }
    }

    class EZViewHander extends Handler {
        @Override
        public void handleMessage(@NonNull Message msg) {
            switch (msg.what) {
                case EZConstants.EZRealPlayConstants.MSG_REALPLAY_PLAY_SUCCESS:
                    Log.d("ezopen","播放成功");
                    //播放成功
                    break;
                case EZConstants.EZRealPlayConstants.MSG_REALPLAY_PLAY_FAIL:
                    //播放失败,得到失败信息
                    ErrorInfo errorinfo = (ErrorInfo) msg.obj;
                    //得到播放失败错误码
                    int code = errorinfo.errorCode;
                    //得到播放失败模块错误码
                    String codeStr = errorinfo.moduleCode;
                    //得到播放失败描述
                    String description = errorinfo.description;
                    //得到播放失败解决方方案
                    String sulution = errorinfo.sulution;
                    break;
                case EZConstants.MSG_VIDEO_SIZE_CHANGED:
                    //解析出视频画面分辨率回调
                    try {
                        String temp = (String) msg.obj;
                        String[] strings = temp.split(":");
                        int mVideoWidth = Integer.parseInt(strings[0]);
                        int mVideoHeight = Integer.parseInt(strings[1]);
                        //解析出视频分辨率
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    break;
                default:
                    break;
            }
        }
    }
}
