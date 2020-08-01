import 'package:flutter_beacon_plugin/src/entites/region.dart';

/// Result of a monitoring event.
class MonitoringResult {
  /// The [MonitoringEvent] that was received.
  final MonitoringEvent event;
  /// The [MonitoringState] that was received.
  /// Only available for [MonitoringEvent.DID_DETERMINE_STATE_FOR_REGION]
  final MonitoringState state;
  /// The [Region] that was monitored.
  final Region region;

  const MonitoringResult(this.event, this.state, this.region);

  factory MonitoringResult.fromMap(Map<dynamic, dynamic> map) {
    var event = MonitoringEvent.values.firstWhere((element) => element.toString() == map["event"] as String);
    MonitoringState state;
    if(map.containsKey("state")) {
      state =
          MonitoringState.values.firstWhere((element) => element.toString() ==
              map["state"] as String);
    } else state = null;
    var regionMap = (map["region"] as Map<dynamic, dynamic>).cast<String, dynamic>();
    var region = Region.fromMap(regionMap);

    return MonitoringResult(event, state, region);
  }

  Map<dynamic, dynamic> toMap() => <String, dynamic> {
    "event": event.toString(),
    "state": state.toString(),
    "region": region.toMap()
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonitoringResult &&
          runtimeType == other.runtimeType &&
          event == other.event &&
          state == other.state &&
          region == other.region;

  @override
  int get hashCode => event.hashCode ^ state.hashCode ^ region.hashCode;

  @override
  String toString() {
    return 'MonitoringResult{event: $event, state: $state, region: $region}';
  }
}

enum MonitoringEvent {
  DID_ENTER_REGION,
  DID_EXIT_REGION,
  DID_DETERMINE_STATE_FOR_REGION
}

enum MonitoringState { INSIDE, OUTSIDE }
