import 'package:flutter/services.dart';

class PermissionTools {
  final MethodChannel _channel;

  PermissionTools(this._channel);

  Future<PermissionStatus> requestPermissions() async =>
      _decodePermissionStatus(await _channel.invokeMethod('requestPermission'));

  Future<PermissionStatus> checkPermissions() async =>
      _decodePermissionStatus(await _channel.invokeMethod('checkPermissions'));

  PermissionStatus _decodePermissionStatus(bool granted) =>
      granted ? PermissionStatus.authorized : PermissionStatus.denied;
}

enum PermissionStatus { authorized, denied }
