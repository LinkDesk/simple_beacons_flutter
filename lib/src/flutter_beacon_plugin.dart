import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon_plugin/src/entites/region.dart';
import 'package:flutter_beacon_plugin/src/results/monitoring_result.dart';
import 'package:flutter_beacon_plugin/src/results/ranging_result.dart';

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

  static const EventChannel _monitoringChannel =
      const EventChannel('flutter_beacon_plugin_monitoring_event');

  static const EventChannel _rangingChannel =
      const EventChannel('flutter_beacon_plugin_ranging_event');

  /// Set of permission tools for required permissions to scan beacons.
  /// See [PermissionTools]
  final PermissionTools permissions = new PermissionTools(_channel);

  /// Streaming broadcasting every change of the [BluetoothState].
  final Stream<BluetoothState> bluetoothStateStream = _bluetoothStateChannel
      .receiveBroadcastStream()
      .map((event) => parseBluetoothState(event.toString()));

  /// See [startMonitoring]
  final Stream<MonitoringResult> monitoringStream = _monitoringChannel
      .receiveBroadcastStream()
      .map((dynamic event) => MonitoringResult.fromMap(event));

  /// See [startRanging]
  final Stream<RangingResult> rangingStream = _rangingChannel
      .receiveBroadcastStream()
      .map((event) => RangingResult.fromMap((event as Map<dynamic, dynamic>).cast<String, dynamic>()));

  FlutterBeaconPlugin._();

  /// Starts monitoring the specified [regions].
  /// Listen to [monitoringStream] for [MonitoringResult]s
  Future<void> startMonitoring({@required List<Region> regions}) => _channel.invokeMethod('startMonitoring', <String, dynamic>{
    'regions': regions.map((e) => e.toMap()).toList()
  });


  /// Starts ranging the specified [regions]
  /// Listen to [rangingStream] for [RangingResult]s
  Future<void> startRanging({@required List<Region> regions}) => _channel.invokeMethod('startRanging', <String, dynamic>{
    'regions': regions.map((e) => e.toMap()).toList()
  });
}
