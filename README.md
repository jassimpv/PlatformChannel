# PlatformChannel

A comprehensive Flutter project demonstrating platform-specific code integration using Method Channels to communicate between Flutter and native platforms (Android/iOS/Web).

## 🚀 Overview

This project showcases how to implement **Platform Channels** in Flutter to access native platform features and APIs across multiple platforms. It serves as a practical example for developers who need to bridge the gap between Flutter's Dart code and platform-specific native code on mobile and web platforms.

### Key Features

- ✅ Cross-platform communication (Flutter ↔ Android/iOS/Web)
- ✅ Method Channel implementation examples
- ✅ Web platform integration with JavaScript interop
- ✅ Clean project structure with separation of concerns
- ✅ Error handling and exception management
- ✅ Production-ready code patterns

## 📋 Prerequisites

Before running this project, ensure you have:

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio with Android SDK (for Android development)
- Xcode (for iOS development on macOS)
- A modern web browser (Chrome, Firefox, Safari, Edge)
- A physical device, emulator/simulator, or web browser for testing

## 🛠️ Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/jassimpv/PlatformChannel.git
   cd PlatformChannel
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   # Run on mobile (Android/iOS)
   flutter run

   # Run on web
   flutter run -d web-server --web-port 8080

   # Or run on Chrome
   flutter run -d chrome
   ```

## 📁 Project Structure

```
lib/
├── main.dart                 # Main application entry point
├── web_helper.dart          # Web platform helper implementation
└── web_helper_stub.dart     # Web helper stub for non-web platforms

android/
└── app/src/main/kotlin/     # Android platform code
    └── MainActivity.kt      # Method channel handlers

ios/
└── Runner/
    └── AppDelegate.swift    # iOS platform code

web/
├── index.html               # Web entry point
```

## 🔧 Platform Channel Implementation

### 🎯 Core Concept

Platform Channels enable bidirectional communication between Flutter and platform-specific code using a simple message-passing mechanism. This project demonstrates:

1. **Method Channels**: For invoking platform-specific methods (Mobile)
2. **JavaScript Interop**: For web platform integration using `dart:js_interop`
3. **Event Channels**: For streaming data from platform to Flutter
4. **Basic Message Channels**: For simple data exchange
5. **Conditional Platform Implementation**: Using `kIsWeb` and platform detection

## 🚨 Troubleshooting

### Common Issues

#### **Channel Not Found Error**

```
MissingPluginException(No implementation found for method X on channel Y)
```

**Solution**: Ensure the channel name matches exactly between Dart and native code.

#### **Method Not Implemented**

```
PlatformException(error, METHOD_NOT_IMPLEMENTED, null, null)
```

**Solution**: Check that the method name in the native handler matches the Dart call.

#### **Permission Denied (Android)**

**Solution**: Add required permissions to `android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.BATTERY_STATS" />
```

#### **Web Platform Issues**

**CORS Errors**: When testing locally, use `flutter run -d chrome --web-renderer html`
**Battery API Not Supported**: Modern browsers may restrict or disable the Battery API for privacy
**JavaScript Interop Issues**: Ensure `dart:js_interop` is properly configured in `pubspec.yaml`

#### **Platform Detection Problems**

**Solution**: Use `kIsWeb` for web detection and `Platform.isAndroid`/`Platform.isIOS` for mobile

## 📚 Advanced Topics

### Event Channels (Mobile)

For continuous data streaming from platform to Flutter:

```dart
static const EventChannel _eventChannel =
    EventChannel('com.example.platform_channel/events');

Stream<double> get batteryStream =>
    _eventChannel.receiveBroadcastStream().cast<double>();
```

### Basic Message Channels (Mobile)

For simple data exchange:

```dart
static const BasicMessageChannel _messageChannel =
    BasicMessageChannel('com.example.platform_channel/messages', StandardMessageCodec());
```

### Web-Specific Features

For web-only functionality using JavaScript interop:

```dart
// Access browser storage
@JS('localStorage.setItem')
external void setLocalStorage(String key, String value);

@JS('localStorage.getItem')
external String? getLocalStorage(String key);

// Access geolocation
@JS('navigator.geolocation.getCurrentPosition')
external void getCurrentPosition(JSFunction success, JSFunction error);
```

### Cross-Platform Abstraction

Create a unified interface for all platforms:

```dart
abstract class PlatformService {
  Future<String> getPlatformVersion();
  Future<String> getBatteryInfo();
}

class MobilePlatformService implements PlatformService {
  // Method channel implementation
}

class WebPlatformService implements PlatformService {
  // JavaScript interop implementation
}
```

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Resources

- [Flutter Platform Channels Documentation](https://docs.flutter.dev/development/platform-integration/platform-channels)
- [Writing Custom Platform-Specific Code](https://docs.flutter.dev/platform-integration/platform-channels)
- [Method Channel API Reference](https://api.flutter.dev/flutter/services/MethodChannel-class.html)
- [Platform Channel Samples](https://github.com/flutter/samples/tree/main/platform_channels)

## 📞 Support

If you have any questions or run into issues, please:

1. Check the [Issues](https://github.com/jassimpv/PlatformChannel/issues) section
2. Create a new issue with detailed information
3. Join the Flutter community discussions

---

**Made with ❤️ by [jassimpv](https://github.com/jassimpv)**
