import 'package:flutter/services.dart';
import 'package:flutter_beacon_plugin/src/permission_tools.dart';

class FlutterBeaconPlugin {
  static final instance = FlutterBeaconPlugin._();

  static const MethodChannel _channel =
      const MethodChannel('flutter_beacon_plugin');

  final PermissionTools permissions = new PermissionTools(_channel);

  FlutterBeaconPlugin._();
}
