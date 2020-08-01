import 'package:flutter_beacon_plugin/src/entites/beacon.dart';
import 'package:flutter_beacon_plugin/src/entites/region.dart';

/// Representation of a received range result.
class RangingResult {
  /// List of ranged [Beacon]s.
  final List<Beacon> beacons;
  /// Ranged [Region].
  final Region region;

  const RangingResult(this.beacons, this.region);

  factory RangingResult.fromMap(Map<dynamic, dynamic> map) {
    var beaconsList = map["beacons"] as List<Map<dynamic, dynamic>>;
    var beacons = beaconsList.map((it) {
      var map = it.cast<String, dynamic>();
      return Beacon.fromMap(map);
    }).toList(growable: false);

    var regionMap = (map["region"] as Map<dynamic, dynamic>).cast<String, dynamic>();
    var region = Region.fromMap(regionMap);

    return RangingResult(beacons, region);
  }

  Map<dynamic, dynamic> toMap() => <String, dynamic> {
    "beacons": beacons.map((beacon) => beacon.toMap()).toList(growable: false),
    "region": region.toMap()
  };
}
