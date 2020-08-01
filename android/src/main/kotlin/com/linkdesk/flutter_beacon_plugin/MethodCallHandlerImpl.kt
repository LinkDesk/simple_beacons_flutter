package com.linkdesk.flutter_beacon_plugin

import android.content.pm.PackageManager
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class MethodCallHandlerImpl(private val plugin: FlutterBeaconPlugin) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val activity = plugin.activity
                ?: return result.error("MISSING_ACTIVITY", "Plugin has not been attached to engine", null)
        when (call.method) {
            "checkPermission" -> result.success(PermissionUtil.hasPermission(activity.activity))
            "requestPermission" -> requestPermission(activity, result)
            else -> result.notImplemented()
        }
    }

    private fun requestPermission(activity: ActivityPluginBinding, result: MethodChannel.Result) {
        try {
            PermissionUtil.requestPermission(activity.activity, PluginRegistry.RequestPermissionsResultListener { _, _, grantResults: IntArray ->
                result.success(grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED)
                true
            })
        } catch (e: Exception) {
            result.error("PERMISSION_ERROR", "Could not request permissions", e)
        }
    }
}
