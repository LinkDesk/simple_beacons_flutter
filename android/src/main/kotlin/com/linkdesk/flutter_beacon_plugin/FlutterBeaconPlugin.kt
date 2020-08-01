package com.linkdesk.flutter_beacon_plugin

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel

class FlutterBeaconPlugin : FlutterPlugin, ActivityAware {
    private lateinit var channel: MethodChannel
    var activity: ActivityPluginBinding? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_beacon_plugin")
        channel.setMethodCallHandler(MethodCallHandlerImpl(this))
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = onAttachedToActivity(binding)

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addRequestPermissionsResultListener(PermissionUtil)
        activity = binding
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    companion object {
        const val PERMISSION_REQUEST = 424242
    }
}
