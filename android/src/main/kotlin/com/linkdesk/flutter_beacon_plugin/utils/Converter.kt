package com.linkdesk.flutter_beacon_plugin.utils

import com.linkdesk.flutter_beacon_plugin.MonitoringResult
import org.altbeacon.beacon.Beacon
import org.altbeacon.beacon.Identifier
import org.altbeacon.beacon.MonitorNotifier
import org.altbeacon.beacon.Region
import java.util.*

fun Region.toMap(): Map<String, Any?> = mapOf(
        "identifier" to uniqueId,
        "proximityUUID" to id1?.toString()?.toUpperCase(Locale.US),
        "major" to id2?.toInt(),
        "minor" to id3?.toInt()
)

fun Beacon.toMap(): Map<String, Any?> = mapOf(
        "proximityUUID" to id1?.toString()?.toUpperCase(Locale.US),
        "major" to id2?.toInt(),
        "minor" to id3?.toInt(),
        "rssi" to rssi,
        "txPower" to txPower,
        "accuracy" to "%.2f".format(Locale.ROOT, distance),
        "macAddress" to bluetoothAddress
)

fun parseMonitoringState(state: Int) = when (state) {
    MonitorNotifier.INSIDE -> MonitoringResult.State.INSIDE
    MonitorNotifier.OUTSIDE -> MonitoringResult.State.OUTSIDE
    else -> throw IllegalArgumentException("Got invalid monitoring state $state")
}

fun parseRegion(map: Map<String, Any>): Region {
    val identifier = map["identifier"] as? String? ?: ""
    val identifiers = mutableListOf<Identifier>()
    val uuid = map["proximityUUID"]
    if (uuid is String) {
        identifiers.add(Identifier.parse(uuid))
    }

    val major = map["major"]
    if(major is Int) {
        identifiers.add(Identifier.fromInt(major))
    }

    val minor = map["major"]
    if(minor is Int) {
        identifiers.add(Identifier.fromInt(minor))
    }

    return Region(identifier, identifiers)
}
