package com.linkdesk.flutter_beacon_plugin

import android.content.Context

import com.linkdesk.flutter_beacon_plugin.events.BluetoothStateBroadcaster
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class FlutterBeaconPlugin : FlutterPlugin, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var bluetoothStateChannel: EventChannel
    var activity: ActivityPluginBinding? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_beacon_plugin")
        channel.setMethodCallHandler(MethodCallHandlerImpl(this))
        bluetoothStateChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_beacon_plugin_bluetooth_state_event")
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
        activity = null
        bluetoothStateChannel.setStreamHandler(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = onAttachedToActivity(binding)

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addRequestPermissionsResultListener(PermissionUtil)
        activity = binding
        bluetoothStateChannel.setStreamHandler(BluetoothStateBroadcaster(binding.activity))
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    companion object {
        const val PERMISSION_REQUEST = 424242
    }
}
