package com.linkdesk.flutter_beacon_plugin

import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import com.linkdesk.flutter_beacon_plugin.events.BeaconMonitorBroadcaster
import com.linkdesk.flutter_beacon_plugin.events.BeaconRangeBroadcaster
import com.linkdesk.flutter_beacon_plugin.events.BluetoothStateBroadcaster
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import org.altbeacon.beacon.BeaconConsumer
import org.altbeacon.beacon.BeaconManager
import org.altbeacon.beacon.BeaconParser
import org.altbeacon.beacon.Region

class FlutterBeaconPlugin : FlutterPlugin, ActivityAware, BeaconConsumer {
    private lateinit var channel: MethodChannel
    private lateinit var bluetoothStateChannel: EventChannel
    private lateinit var monitoringChannel: EventChannel
    private lateinit var rangingChannel: EventChannel
    private lateinit var beaconManager: BeaconManager
    var activity: ActivityPluginBinding? = null
    private var rangingRegions = mutableListOf<Region>()
    private var monitoringRegions = mutableListOf<Region>()
    private var bluetoothServiceConnected = false
    private var needToStartMonitoring = false
    private var needToStartRanging = false

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_beacon_plugin")
        channel.setMethodCallHandler(MethodCallHandlerImpl(this))
        bluetoothStateChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_beacon_plugin_bluetooth_state_event")
        monitoringChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_beacon_plugin_monitoring_event")
        rangingChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_beacon_plugin_ranging_event")
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
        activity = null
        bluetoothStateChannel.setStreamHandler(null)
        beaconManager.unbind(this)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = onAttachedToActivity(binding)

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addRequestPermissionsResultListener(PermissionUtil)
        activity = binding
        bluetoothStateChannel.setStreamHandler(BluetoothStateBroadcaster(binding.activity))

        val beaconManager = BeaconManager.getInstanceForApplication(binding.activity)
        // add ibeacon support
        beaconManager.beaconParsers.add(BeaconParser().setBeaconLayout("m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24"))
        monitoringChannel.setStreamHandler(BeaconMonitorBroadcaster(beaconManager))
        rangingChannel.setStreamHandler(BeaconRangeBroadcaster(beaconManager))
        this.beaconManager = beaconManager
        beaconManager.bind(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        bluetoothServiceConnected = false
    }

    override fun getApplicationContext(): Context = activity!!.activity.applicationContext

    override fun unbindService(service: ServiceConnection) = applicationContext.unbindService(service)

    override fun bindService(intent: Intent, service: ServiceConnection, i: Int): Boolean = applicationContext.bindService(intent, service, i).also { Unit }

    override fun onBeaconServiceConnect() {
        bluetoothServiceConnected = true
        if (needToStartMonitoring) {
            _restartMonitoring()
            needToStartMonitoring = false
        }

        if (needToStartRanging) {
            _restartRanging()
            needToStartRanging = false
        }
    }

    @Suppress("FunctionName")
    private fun _restartMonitoring() =
            monitoringRegions.filterNot { it in beaconManager.monitoredRegions }.forEach(beaconManager::startMonitoringBeaconsInRegion)

    fun restartMonitoring() {
        if (bluetoothServiceConnected) {
            _restartMonitoring()
        } else {
            needToStartMonitoring = true
        }
    }

    @Suppress("FunctionName")
    private fun _restartRanging() =
            rangingRegions.filterNot { it in beaconManager.rangedRegions }.forEach(beaconManager::startRangingBeaconsInRegion)

    fun restartRanging() {
        if (bluetoothServiceConnected) {
            _restartRanging()
        } else {
            needToStartRanging = true
        }
    }

    fun registerRangeRegions(regions: List<Region>) = rangingRegions.addAll(regions)

    fun registerMonitorRegions(regions: List<Region>) = monitoringRegions.addAll(regions)

    companion object {
        const val PERMISSION_REQUEST = 424242
    }
}
