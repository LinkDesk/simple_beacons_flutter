package com.linkdesk.flutter_beacon_plugin.events

import android.bluetooth.BluetoothAdapter
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import io.flutter.plugin.common.EventChannel

class BluetoothStateBroadcaster constructor(private val context: Context): EventChannel.StreamHandler, BroadcastReceiver() {

    init {
        Log.i("DAS", "ATTACH")
    }
    private var sink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        context.registerReceiver(this, filter)
        sink = events
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        if (action == BluetoothAdapter.ACTION_STATE_CHANGED) {
            val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE,
                    BluetoothAdapter.ERROR)
            val result = when (state) {
                BluetoothAdapter.STATE_OFF -> "STATE_OFF"
                BluetoothAdapter.STATE_TURNING_OFF -> "STATE_TURNING_OFF"
                BluetoothAdapter.STATE_ON -> "STATE_ON"
                BluetoothAdapter.STATE_TURNING_ON -> "STATE_TURNING_ON"
                else -> return sink?.error("INVALID_STATE_RECEIVED", "Received unknown bluetooth state", state) ?: Unit
            }

            sink?.success(result)
        }
    }

    override fun onCancel(arguments: Any?) {
        context.unregisterReceiver(this)
    }
}
