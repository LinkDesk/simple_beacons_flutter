import 'package:flutter/services.dart';

class PermissionTools {
  final MethodChannel _channel;

  PermissionTools(this._channel);

  /// Requests the location permission needed to range and monitor beacons and returns the updated [PermissionStatus].
  /// [force] - Whether the permission popup should be shown or only if the permission has not been granted already
  /// On Android: https://developer.android.com/reference/android/Manifest.permission#ACCESS_FINE_LOCATION
  Future<PermissionStatus> requestPermissions({bool force = false}) async =>
      _decodePermissionStatus(await _channel.invokeMethod(
          'requestPermission', <String, dynamic>{'force': force}));

  /// Checks whether the app has the needed permissions to range and monitor beacons.
  /// See [PermissionStatus] for possible return values
  /// On Android: https://developer.android.com/reference/android/Manifest.permission#ACCESS_FINE_LOCATION
  Future<PermissionStatus> checkPermissions() async =>
      _decodePermissionStatus(await _channel.invokeMethod('checkPermission'));

  PermissionStatus _decodePermissionStatus(bool granted) =>
      granted ? PermissionStatus.authorized : PermissionStatus.denied;
}

/// Representation of native permission authorizations.
enum PermissionStatus { 
  /// Permission has been authorized.
  /// On Android: 
  ///   https://developer.android.com/reference/androidx/core/content/ContextCompat#checkSelfPermission(android.content.Context,%20java.lang.String)
  ///   returned https://developer.android.com/reference/android/content/pm/PackageManager?hl=en#PERMISSION_GRANTED
  ///   for https://developer.android.com/reference/android/Manifest.permission#ACCESS_FINE_LOCATION
  authorized,
  /// Permission has not been authorized.
  /// On Android: 
  ///   https://developer.android.com/reference/androidx/core/content/ContextCompat#checkSelfPermission(android.content.Context,%20java.lang.String)
  ///   returned https://developer.android.com/reference/android/content/pm/PackageManager?hl=en#PERMISSION_DENIED
  ///   for https://developer.android.com/reference/android/Manifest.permission#ACCESS_FINE_LOCATION
  denied 
}
