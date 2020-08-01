package com.linkdesk.flutter_beacon_plugin.events

import androidx.annotation.CallSuper
import io.flutter.plugin.common.EventChannel

abstract class AbstractBroadcaster : EventChannel.StreamHandler {
    protected var sink: EventChannel.EventSink? = null

    @CallSuper
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }

    @CallSuper
    override fun onCancel(arguments: Any?) {
        sink = null
    }
}
