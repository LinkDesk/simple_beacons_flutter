
/// Representation of a Region
/// Android: https://altbeacon.github.io/android-beacon-library/javadoc/reference/org/altbeacon/beacon/Region.html
class Region {
  /// Android: https://altbeacon.github.io/android-beacon-library/javadoc/reference/org/altbeacon/beacon/Region.html#getUniqueId()
  final String identifier;
  /// Android: https://altbeacon.github.io/android-beacon-library/javadoc/reference/org/altbeacon/beacon/Region.html#getId1()
  final String proximityUUID;
  /// Android: https://altbeacon.github.io/android-beacon-library/javadoc/reference/org/altbeacon/beacon/Region.html#getId2()
  final int major;
  /// Android: https://altbeacon.github.io/android-beacon-library/javadoc/reference/org/altbeacon/beacon/Region.html#getId3()
  final int minor;

  /// Constructor for a region to monitor/range
  const Region({this.identifier, this.proximityUUID, this.major, this.minor});

  const Region._(this.identifier, this.proximityUUID, this.major, this.minor);

  factory Region.fromMap(Map<String, dynamic> map) => Region._(
    map["identifier"] as String,
    map["proximityUUID"] as String,
    map["major"] as int,
    map["minor"] as int,
  );

  Map<dynamic, dynamic> toMap() => <String, dynamic>{
    "identifier": identifier,
    "proximityUUID": proximityUUID,
    "major": major,
    "minor": minor,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Region &&
          runtimeType == other.runtimeType &&
          identifier == other.identifier &&
          proximityUUID == other.proximityUUID &&
          major == other.major &&
          minor == other.minor;

  @override
  int get hashCode =>
      identifier.hashCode ^
      proximityUUID.hashCode ^
      major.hashCode ^
      minor.hashCode;

  @override
  String toString() {
    return 'Region{identifier: $identifier, proximityUUID: $proximityUUID, major: $major, minor: $minor}';
  }
}
