import Flutter
import UIKit


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let registrar = self.registrar(forPlugin: "PlatformChannelHandler") {
      PlatformChannelHandler.register(with: registrar)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}



class PlatformChannelHandler: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?

  static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(name: "com.example.machine_test/platform", binaryMessenger: registrar.messenger())
    let batteryChannel = FlutterEventChannel(name: "com.example.machine_test/battery", binaryMessenger: registrar.messenger())
    let instance = PlatformChannelHandler()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    batteryChannel.setStreamHandler(instance)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getDeviceModel":
      result(getDeviceModel())
    case "getAndroidVersion":
      result(getiOSVersion())
    case "getBatteryLevel":
      getBatteryLevel(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    UIDevice.current.isBatteryMonitoringEnabled = true
    NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelChanged), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
    // Send initial battery level
    events(Int(UIDevice.current.batteryLevel * 100))
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    NotificationCenter.default.removeObserver(self, name: UIDevice.batteryLevelDidChangeNotification, object: nil)
    UIDevice.current.isBatteryMonitoringEnabled = false
    eventSink = nil
    return nil
  }

  @objc private func batteryLevelChanged(notification: Notification) {
    if let sink = eventSink {
      sink(Int(UIDevice.current.batteryLevel * 100))
    }
  }

  private func getDeviceModel() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    switch identifier {
    case "iPhone1,1": return "iPhone"
    case "iPhone1,2": return "iPhone 3G"
    case "iPhone2,1": return "iPhone 3GS"
    case "iPhone3,1": return "iPhone 4"
    case "iPhone3,2": return "iPhone 4 GSM Rev A"
    case "iPhone3,3": return "iPhone 4 CDMA"
    case "iPhone4,1": return "iPhone 4S"
    case "iPhone5,1": return "iPhone 5 (GSM)"
    case "iPhone5,2": return "iPhone 5 (GSM+CDMA)"
    case "iPhone5,3": return "iPhone 5C (GSM)"
    case "iPhone5,4": return "iPhone 5C (Global)"
    case "iPhone6,1": return "iPhone 5S (GSM)"
    case "iPhone6,2": return "iPhone 5S (Global)"
    case "iPhone7,1": return "iPhone 6 Plus"
    case "iPhone7,2": return "iPhone 6"
    case "iPhone8,1": return "iPhone 6s"
    case "iPhone8,2": return "iPhone 6s Plus"
    case "iPhone8,4": return "iPhone SE (GSM)"
    case "iPhone9,1": return "iPhone 7"
    case "iPhone9,2": return "iPhone 7 Plus"
    case "iPhone9,3": return "iPhone 7"
    case "iPhone9,4": return "iPhone 7 Plus"
    case "iPhone10,1": return "iPhone 8"
    case "iPhone10,2": return "iPhone 8 Plus"
    case "iPhone10,3": return "iPhone X Global"
    case "iPhone10,4": return "iPhone 8"
    case "iPhone10,5": return "iPhone 8 Plus"
    case "iPhone10,6": return "iPhone X GSM"
    case "iPhone11,2": return "iPhone XS"
    case "iPhone11,4": return "iPhone XS Max"
    case "iPhone11,6": return "iPhone XS Max Global"
    case "iPhone11,8": return "iPhone XR"
    case "iPhone12,1": return "iPhone 11"
    case "iPhone12,3": return "iPhone 11 Pro"
    case "iPhone12,5": return "iPhone 11 Pro Max"
    case "iPhone12,8": return "iPhone SE 2nd Gen"
    case "iPhone13,1": return "iPhone 12 Mini"
    case "iPhone13,2": return "iPhone 12"
    case "iPhone13,3": return "iPhone 12 Pro"
    case "iPhone13,4": return "iPhone 12 Pro Max"
    case "iPhone14,2": return "iPhone 13 Pro"
    case "iPhone14,3": return "iPhone 13 Pro Max"
    case "iPhone14,4": return "iPhone 13 Mini"
    case "iPhone14,5": return "iPhone 13"
    case "iPhone14,6": return "iPhone SE 3rd Gen"
    case "iPhone14,7": return "iPhone 14"
    case "iPhone14,8": return "iPhone 14 Plus"
    case "iPhone15,2": return "iPhone 14 Pro"
    case "iPhone15,3": return "iPhone 14 Pro Max"
    case "iPhone15,4": return "iPhone 15"
    case "iPhone15,5": return "iPhone 15 Plus"
    case "iPhone16,1": return "iPhone 15 Pro"
    case "iPhone16,2": return "iPhone 15 Pro Max"
    case "iPhone17,1": return "iPhone 16 Pro"
    case "iPhone17,2": return "iPhone 16 Pro Max"
    case "iPhone17,3": return "iPhone 16"
    case "iPhone17,4": return "iPhone 16 Plus"
    case "iPhone17,5": return "iPhone 16e"

    //https://gist.github.com/adamawolf/3048717 - iOS Device Identifier List
    // Add more identifiers as needed
    default: return identifier
    }
  }

  private func getiOSVersion() -> String {
    let version = UIDevice.current.systemVersion
    return "iOS \(version)"
  }

  private func getBatteryLevel(result: @escaping FlutterResult) {
    UIDevice.current.isBatteryMonitoringEnabled = true
    let batteryLevel = UIDevice.current.batteryLevel
    if batteryLevel < 0 {
      result(FlutterError(code: "UNAVAILABLE", message: "Battery level not available.", details: nil))
    } else {
      result(Int(batteryLevel * 100))
    }
  }
}