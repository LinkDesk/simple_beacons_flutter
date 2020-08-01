/// Representation of a beacon
/// Android: https://altbeacon.github.io/android-beacon-library/javadoc/reference/org/altbeacon/beacon/Beacon.html
class Beacon {

  /// Android: https://altbeacon.github.io/android-beacon-library/javadoc/reference/org/altbeacon/beacon/Beacon.html#getId1()
  final String proximityUUID;
  /// Android: https://altbeacon.github.io/android-beacon-library/javadoc/reference/org/altbeacon/beacon/Beacon.html#getId2()
  final int major;
  /// Android: https://altbeacon.github.io/android-beacon-library/javadoc/reference/org/altbeacon/beacon/Beacon.html#getId3()
  final int minor;
  /// Android: https://altbeacon.github.io/android-beacon-library/javadoc/reference/org/altbeacon/beacon/Beacon.html#getRssi()
  final int rssi;
  /// Android: https://altbeacon.github.io/android-beacon-library/javadoc/reference/org/altbeacon/beacon/Beacon.html#getTxPower()
  final int txPower;
  /// Android: https://altbeacon.github.io/android-beacon-library/javadoc/reference/org/altbeacon/beacon/Beacon.html#getTxPower() (formatted with "%.2f")
  final String accuracy;
  /// Android: https://altbeacon.github.io/android-beacon-library/javadoc/reference/org/altbeacon/beacon/Beacon.html#getBluetoothAddress()
  final String macAddress;

  const Beacon(this.proximityUUID, this.major, this.minor, this.rssi,
      this.txPower, this.accuracy, this.macAddress);

  factory Beacon.fromMap(Map<dynamic, dynamic> map) => Beacon(
        map["proximityUUID"] as String,
        map["major"] as int,
        map["minor"] as int,
        map["rssi"] as int,
        map["txPower"] as int,
        map["accuracy"] as String,
        map["macAddress"] as String,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        "proximityUUID": proximityUUID,
        "major": major,
        "minor": minor,
        "rssi": rssi,
        "txPower": txPower,
        "accuracy": accuracy,
        "macAddress": macAddress
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Beacon &&
          runtimeType == other.runtimeType &&
          proximityUUID == other.proximityUUID &&
          major == other.major &&
          minor == other.minor &&
          rssi == other.rssi &&
          txPower == other.txPower &&
          accuracy == other.accuracy &&
          macAddress == other.macAddress;

  @override
  int get hashCode =>
      proximityUUID.hashCode ^
      major.hashCode ^
      minor.hashCode ^
      rssi.hashCode ^
      txPower.hashCode ^
      accuracy.hashCode ^
      macAddress.hashCode;

  @override
  String toString() {
    return 'Beacon{proximityUUID: $proximityUUID, major: $major, minor: $minor, rssi: $rssi, txPower: $txPower, accuracy: $accuracy, macAddress: $macAddress}';
  }
}
