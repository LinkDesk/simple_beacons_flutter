package com.linkdesk.flutter_beacon_plugin

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.PluginRegistry

object PermissionUtil : PluginRegistry.RequestPermissionsResultListener {
    private val listeners = mutableListOf<PluginRegistry.RequestPermissionsResultListener>()

    fun hasPermission(context: Context) = ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED

    fun requestPermission(activity: Activity, listener: PluginRegistry.RequestPermissionsResultListener) = ActivityCompat.requestPermissions(activity, arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION), FlutterBeaconPlugin.PERMISSION_REQUEST).also {
        listeners.add(DelegatedPermissionRequestResultListener(listener))
    }

    fun remove(listener: PluginRegistry.RequestPermissionsResultListener) = listeners.remove(listener)

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?): Boolean =
            listeners.any { it.onRequestPermissionsResult(requestCode, permissions, grantResults) }
}

private class DelegatedPermissionRequestResultListener(private val listener: PluginRegistry.RequestPermissionsResultListener) : PluginRegistry.RequestPermissionsResultListener {
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
        return if (requestCode == FlutterBeaconPlugin.PERMISSION_REQUEST) {
            listener.onRequestPermissionsResult(requestCode, permissions, grantResults)
            PermissionUtil.remove(this)
        } else false
    }
}
