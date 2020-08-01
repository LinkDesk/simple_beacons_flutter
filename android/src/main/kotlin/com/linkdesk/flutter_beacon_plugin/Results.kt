package com.linkdesk.flutter_beacon_plugin

import com.linkdesk.flutter_beacon_plugin.utils.toMap
import org.altbeacon.beacon.Beacon
import org.altbeacon.beacon.Region

data class RangeResult(val beacons: Collection<Beacon>, val region: Region) {
    fun toMap(): Map<String, Any> = mapOf(
            "beacons" to beacons.map(Beacon::toMap),
            "region" to region.toMap()
    )
}

data class MonitoringResult(val event: Event, val state: State?, val region: Region) {

    fun toMap(): Map<String, Any?> = mapOf(
            "event" to event.name,
            "state" to state?.name,
            "region" to region.toMap()
    )

    enum class Event {
        DID_ENTER_REGION,
        DID_EXIT_REGION,
        DID_DETERMINE_STATE_FOR_REGION
    }

    enum class State {
        INSIDE,
        OUTSIDE
    }
}
