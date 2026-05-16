import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_user_agent/src/core/flutter_binding.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'agent_source.dart';

export 'package:device_info_plus/device_info_plus.dart';
export 'package:package_info_plus/package_info_plus.dart';

export 'agent_source.dart';

/// A class that provides user agent information like device & package information.
abstract class PlatformAgentInfo<I extends BaseDeviceInfo> {
  /// Creates a new instance of [PlatformAgentInfo].
  PlatformAgentInfo() {
    _init();
  }

  final Completer<AgentSource<I>> _source = Completer();
  final FlutterBinding _binding = const FlutterBinding();

  Future<void> _init() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    _source.complete(initializeSource(deviceInfo, packageInfo));
  }

  /// Initializes the [AgentSource] with the given [DeviceInfoPlugin] and [PackageInfo].
  @protected
  Future<AgentSource<I>> initializeSource(
    DeviceInfoPlugin deviceInfo,
    PackageInfo packageInfo,
  );

  /// Selects a value from the [AgentSource].
  @protected
  Future<T> select<T>(T Function(AgentSource<I> source) selector) async {
    return selector(await _source.future);
  }

  /// The package name of the application. (e.g., 'com.example.app')
  @nonVirtual
  Future<String> get packageName => select((s) => s.package.packageName);

  /// The version code of the application. (e.g., '1')
  @nonVirtual
  Future<String> get appVersionCode => select((s) => s.package.buildNumber);

  /// The version name of the application. (e.g., '1.0.0')
  @nonVirtual
  Future<String> get appVersionName => select((s) => s.package.version);

  /// The resolution of the device screen. (e.g., '1080*1920')
  @nonVirtual
  String get deviceResolution {
    final size = _binding.physicalSize;
    return '${size.width.toInt()}*${size.height.toInt()}';
  }

  /// The device pixel ratio. (e.g., 2.0)
  @nonVirtual
  double get devicePixelRatio => _binding.devicePixelRatio;

  /// The name of the operating system. (e.g., 'iOS')
  String get osName;

  /// The version of the operating system. (e.g., '17.1.5')
  Future<String> get osVersion;

  /// The name of the device. (e.g., 'iPhone 15 Pro Max')
  Future<String> get deviceName;

  /// The manufacturer of the device. (e.g., 'Apple')
  Future<String> get deviceManufacturer;

  /// The model of the device. (e.g., '15,4')
  Future<String> get deviceModel;

  /// The CPU architecture of the device. (e.g., 'arm64-v8a', 'arm64')
  Future<String> get architecture;
}
