import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional import for web-only JS interop
import 'web_helper.dart' if (dart.library.io) 'web_helper_stub.dart';

class NativeHelper {
  static const MethodChannel _channel = MethodChannel(
    'com.example.machine_test/platform',
  );
  static const EventChannel _batteryChannel = EventChannel(
    'com.example.machine_test/battery',
  );

  static Future<String> getDeviceModel() async {
    if (kIsWeb) {
      return 'Web Browser';
    } else {
      return await _channel.invokeMethod('getDeviceModel');
    }
  }

  static Future<String> getSystemVersion() async {
    if (kIsWeb) {
      // Get userAgent string on web using WebHelper
      return await WebHelper.getUserAgent();
    } else {
      return await _channel.invokeMethod('getAndroidVersion');
    }
  }

  static Future<int> getBatteryLevel() async {
    if (kIsWeb) {
      return await WebHelper.getBatteryLevel();
    } else {
      return await _channel.invokeMethod('getBatteryLevel');
    }
  }

  static Stream<int> getBatteryLevelStream() {
    if (kIsWeb) {
      // No event channel for web, return empty stream for now
      return Stream.empty();
    } else {
      return _batteryChannel.receiveBroadcastStream().map(
        (event) => event as int,
      );
    }
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String model = '';
  String version = '';
  int? battery;
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    loadData();

    NativeHelper.getBatteryLevelStream().listen((level) {
      setState(() => battery = level);
    });
  }

  Future<void> loadData() async {
    model = await NativeHelper.getDeviceModel();
    version = await NativeHelper.getSystemVersion();
    battery = await NativeHelper.getBatteryLevel();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Platform Channels Demo')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Device: $model'),
              Text('System: $version'),
              Text('Battery: ${battery! - 1}%'),
            ],
          ),
        ),
      ),
    );
  }
}
