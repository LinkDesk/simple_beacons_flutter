import 'package:flutter/services.dart';

import 'bluetooth_state.dart';
import 'converter.dart';
import 'permission_tools.dart';

class FlutterBeaconPlugin {
  /// Instance of [FlutterBeaconPlugin].
  static final instance = FlutterBeaconPlugin._();

  static const MethodChannel _channel =
      const MethodChannel('flutter_beacon_plugin');

  static const EventChannel _bluetoothStateChannel =
      const EventChannel('flutter_beacon_plugin_bluetooth_state_event');

  /// Set of permission tools for required permissions to scan beacons.
  /// See [PermissionTools]
  final PermissionTools permissions = new PermissionTools(_channel);


  /// Streaming broadcasting every change of the [BluetoothState].
  final Stream<BluetoothState> bluetoothStateStream = _bluetoothStateChannel
      .receiveBroadcastStream()
       .map((event) => parseBluetoothState(event.toString()));

  FlutterBeaconPlugin._();
}
