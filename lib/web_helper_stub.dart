// Stub implementation for non-web platforms
class WebHelper {
  static Future<String> getUserAgent() async {
    throw UnsupportedError('WebHelper is only supported on web platform');
  }

  static Future<int> getBatteryLevel() async {
    throw UnsupportedError('WebHelper is only supported on web platform');
  }
}
