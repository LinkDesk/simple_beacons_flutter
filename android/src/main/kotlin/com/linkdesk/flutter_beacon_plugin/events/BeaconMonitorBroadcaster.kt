package com.linkdesk.flutter_beacon_plugin.events

import com.linkdesk.flutter_beacon_plugin.MonitoringResult
import com.linkdesk.flutter_beacon_plugin.utils.parseMonitoringState
import io.flutter.plugin.common.EventChannel
import org.altbeacon.beacon.*

class BeaconMonitorBroadcaster(private val beaconManager: BeaconManager) : AbstractBroadcaster(), MonitorNotifier {

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        super.onListen(arguments, events)
        beaconManager.addMonitorNotifier(this)
    }

    override fun onCancel(arguments: Any?) {
        super.onCancel(arguments)
        beaconManager.removeMonitorNotifier(this)
    }

    override fun didDetermineStateForRegion(state: Int, region: Region) {
        broadcastEvent(region, MonitoringResult.Event.DID_DETERMINE_STATE_FOR_REGION, state)
    }

    override fun didEnterRegion(region: Region) =
            broadcastEvent(region, MonitoringResult.Event.DID_ENTER_REGION)

    override fun didExitRegion(region: Region) =
            broadcastEvent(region, MonitoringResult.Event.DID_EXIT_REGION)

    private fun broadcastEvent(region: Region, event: MonitoringResult.Event, stateRaw: Int? = null) {
        val state = stateRaw?.let { parseMonitoringState(it) }
        val result = MonitoringResult(event, state, region)

        sink?.success(result.toMap())
    }

}