package com.linkdesk.flutter_beacon_plugin.events

import android.util.Log
import com.linkdesk.flutter_beacon_plugin.RangeResult
import io.flutter.plugin.common.EventChannel
import org.altbeacon.beacon.Beacon
import org.altbeacon.beacon.BeaconManager
import org.altbeacon.beacon.RangeNotifier
import org.altbeacon.beacon.Region

class BeaconRangeBroadcaster(private val beaconManager: BeaconManager) : AbstractBroadcaster(), RangeNotifier {

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        super.onListen(arguments, events)
        beaconManager.addRangeNotifier(this)
    }

    override fun onCancel(arguments: Any?) {
        super.onCancel(arguments)
        beaconManager.removeRangeNotifier(this)
    }

    override fun didRangeBeaconsInRegion(beacons: MutableCollection<Beacon>, region: Region) {
        Log.d("flutter_beacon_plugin", "Ranged $beacons in $region")
        val result = RangeResult(beacons, region)

        sink?.success(result.toMap())
    }
}