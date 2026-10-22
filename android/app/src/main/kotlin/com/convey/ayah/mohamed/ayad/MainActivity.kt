package com.convey.ayah.mohamed.ayad

import com.convey.ayah.mohamed.ayad.widget.DailyZekrAppWidgetProvider
import com.convey.ayah.mohamed.ayad.widget.PrayerAppWidgetProvider
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: AudioServiceActivity() {
    private val CHANNEL = "com.convey.ayah.mohamed.ayad/widget_sync"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "updateWidgets" -> {
                    PrayerAppWidgetProvider.updateAllWidgets(context)
                    DailyZekrAppWidgetProvider.updateAllWidgets(context)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
}
