package com.convey.ayah.mohamed.ayad

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import com.convey.ayah.mohamed.ayad.widget.DailyZekrAppWidgetProvider
import com.convey.ayah.mohamed.ayad.widget.PrayerAppWidgetProvider
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: AudioServiceActivity(), SensorEventListener {
    private val CHANNEL = "com.convey.ayah.mohamed.ayad/widget_sync"
    private val FLIP_CHANNEL = "com.convey.ayah.mohamed.ayad/flip_to_mute"
    private var flipMethodChannel: MethodChannel? = null
    private var sensorManager: SensorManager? = null
    private var accelerometer: Sensor? = null
    private var isFaceDown = false

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

        flipMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FLIP_CHANNEL)
        flipMethodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startListening" -> {
                    startSensorListening()
                    result.success(true)
                }
                "stopListening" -> {
                    stopSensorListening()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        sensorManager = getSystemService(Context.SENSOR_SERVICE) as? SensorManager
        accelerometer = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        startSensorListening()
    }

    private fun startSensorListening() {
        accelerometer?.let {
            sensorManager?.registerListener(this, it, SensorManager.SENSOR_DELAY_NORMAL)
        }
    }

    private fun stopSensorListening() {
        sensorManager?.unregisterListener(this)
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null || event.sensor.type != Sensor.TYPE_ACCELEROMETER) return

        val z = event.values[2]
        // When device is face down, gravity causes Z to be negative (~ -9.8 m/s^2)
        if (z < -7.0f) {
            if (!isFaceDown) {
                isFaceDown = true
                flipMethodChannel?.invokeMethod("onDeviceFlippedFaceDown", null)
            }
        } else if (z > -3.0f) {
            isFaceDown = false
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    override fun onDestroy() {
        stopSensorListening()
        super.onDestroy()
    }
}
