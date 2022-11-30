package com.hiveintel.ezopen_plugin_example;


import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

import androidx.annotation.NonNull;

import com.hiveintel.ezopen_plugin.EZPlatformViewFactory;

public class MainActivity extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        flutterEngine.getPlatformViewsController().getRegistry().registerViewFactory("ezopen_plugin/videoView",
                new EZPlatformViewFactory(flutterEngine.getDartExecutor().getBinaryMessenger(),getApplication()));
    }

}
