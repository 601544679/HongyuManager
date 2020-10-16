package com.example.mydemo;

import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String TAG = "FlutterActivity";
    MethodChannel methodChannel;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor(), "android_log");
        methodChannel.setMethodCallHandler((call, result) -> {
            Log.d(TAG, "call.method: " + call.method);
            String tag = call.argument("tag");
            String message = call.argument("msg");
            //Log.d(TAG, "tag: " + tag);
            //Log.d(TAG, "message: " + message);
            switch (call.method) {
                case "logV":
                    Log.v(tag, message);
                    break;
                case "logD":
                    Log.d(tag, message);
                    break;
                case "logI":
                    Log.i(tag, message);
                    break;
                case "logW":
                    Log.w(tag, message);
                    break;
                case "logE":
                    Log.e(tag, message);
                    break;
            }
        });

    }

}
