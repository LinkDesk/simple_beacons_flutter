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

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
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
                )
              ]
            );
          }
        )
      ),
    );
  }
}
