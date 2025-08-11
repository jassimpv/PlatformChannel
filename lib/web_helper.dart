import 'dart:js_interop';

// JavaScript interop definitions for web platform
@JS('navigator')
external Navigator get navigator;

@JS()
external JSObject get window;

@JS()
@staticInterop
class Navigator {}

extension NavigatorExtension on Navigator {
  external JSString get userAgent;
  external JSPromise<JSObject> getBattery();
}

@JS()
@staticInterop
class Battery {}

extension BatteryExtension on Battery {
  external JSNumber get level;
}

class WebHelper {
  static Future<String> getUserAgent() async {
    final userAgent = navigator.userAgent.toDart;
    return userAgent;
  }

  static Future<int> getBatteryLevel() async {
    try {
      final batteryPromise = navigator.getBattery();
      final battery = await batteryPromise.toDart;
      final batteryObj = battery as Battery;
      final level = (batteryObj.level.toDartDouble * 100).toInt();
      return level;
    } catch (e) {
      return -1;
    }
  }
}
