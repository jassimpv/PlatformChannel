package com.example.machine_test

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.machine_test/platform"
    private val BATTERY_CHANNEL = "com.example.machine_test/battery"

    private lateinit var methodChannel: MethodChannel
    private lateinit var batteryChannel: EventChannel
    private var batteryReceiver: BroadcastReceiver? = null
    private var batteryEventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceModel" -> {
                    result.success(getDeviceModel())
                }
                "getAndroidVersion" -> {
                    result.success(getAndroidVersion())
                }
                "getBatteryLevel" -> {
                    val batteryLevel = getBatteryLevel()
                    if (batteryLevel != -1) {
                        result.success(batteryLevel)
                    } else {
                        result.error("UNAVAILABLE", "Battery level not available.", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Battery level stream
        batteryChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_CHANNEL)
        batteryChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                batteryEventSink = events
                startBatteryLevelListener()
            }

            override fun onCancel(arguments: Any?) {
                stopBatteryLevelListener()
                batteryEventSink = null
            }
        })
    }

    private fun getDeviceModel(): String {
        return "${Build.MANUFACTURER} ${Build.MODEL}"
    }

    private fun getAndroidVersion(): String {
        return "Android ${Build.VERSION.RELEASE} (API ${Build.VERSION.SDK_INT})"
    }

    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }

    private fun startBatteryLevelListener() {
        batteryReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val level = getBatteryLevel()
                batteryEventSink?.success(level)
            }
        }

        val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        registerReceiver(batteryReceiver, filter)

        // Send initial battery level
        val initialLevel = getBatteryLevel()
        batteryEventSink?.success(initialLevel)
    }

    private fun stopBatteryLevelListener() {
        batteryReceiver?.let {
            unregisterReceiver(it)
            batteryReceiver = null
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        stopBatteryLevelListener()
    }
}
