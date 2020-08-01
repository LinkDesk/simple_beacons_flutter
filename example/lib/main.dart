import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_beacon_plugin/flutter_beacon_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<Beacon> _rangeEvents = <Beacon>[];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    FlutterBeaconPlugin.instance.rangingStream.listen((event) => setState(() =>_rangeEvents.addAll(event.beacons)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(
          builder: (context) {
            return Column(
              children: <Widget>[
                StreamBuilder(
                  stream: FlutterBeaconPlugin.instance.bluetoothStateStream,
                  builder: (BuildContext context, AsyncSnapshot<BluetoothState> snapshot) {
                    if(!snapshot.hasData) {
                      return Text('Bluetooth State: Not available');
                    } else {
                      return Text('Bluetooth State: ${snapshot.data}');
                    }
                  }
                ),
                RaisedButton(
                  child: Text("Check permissions"),
                  onPressed: () async {
                    var state = await FlutterBeaconPlugin.instance.permissions.checkPermissions();

                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Granted: $state'),));              },
                ),
                RaisedButton(
                  child: Text("Request permissions"),
                  onPressed: () async {
                    var state = await FlutterBeaconPlugin.instance.permissions.requestPermissions();
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Granted: $state'),));
                  },
                ),
                RaisedButton(
                  child: Text("Start ranging"),
                  onPressed: () async {
                    await FlutterBeaconPlugin.instance.startRanging(regions: [
                      Region(identifier: 'Room Locator', proximityUUID: '2EE3F39D-AF76-4692-9689-80322D037D3D')
                    ]);
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Ranging started!'),));
                  },
                ),
                Builder(builder: (context) {
                  List<Beacon> lastResults;
                  if(_rangeEvents.length < 10) {
                    lastResults = _rangeEvents;
                  } else {
                    lastResults = _rangeEvents.sublist(_rangeEvents.length -11,_rangeEvents.length);
                  }

                  var text = lastResults.map((e) => "Ranged Beacon(${e.major}${e.minor})").join("\n");
                  return Text(text);
                },)
              ]
            );
          }
        )
      ),
    );
  }
}
