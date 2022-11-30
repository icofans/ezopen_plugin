package com.hiveintel.ezopen_plugin;

import android.app.Application;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

import com.hiveintel.ezopen_plugin.EZPlatformViewFactory;

/** EZOpenPlugin */
public class EZOpenPlugin implements FlutterPlugin {

 @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    binding
        .getPlatformViewRegistry()
        .registerViewFactory("ezopen_plugin/videoView", new EZPlatformViewFactory(
                binding.getBinaryMessenger(),(Application) binding.getApplicationContext()
        ));
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {}

}
