// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const MethodChannel methodChannel =
      MethodChannel('samples.flutter.io/battery');

  String _batteryLevel = 'Battery level: unknown.';
  String _chargingStatus = 'Battery status: unknown.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await methodChannel.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level: $result%.';
    } on PlatformException {
      batteryLevel = 'Failed to get battery level.';
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  void initState() {
    _getBatteryLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_batteryLevel, key: const Key('Battery level label')),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  child: const Text('Refresh'),
                  onPressed: _getBatteryLevel,
                ),
              ),
            ],
          ),
          Text(_chargingStatus),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: MyApp()));
}
