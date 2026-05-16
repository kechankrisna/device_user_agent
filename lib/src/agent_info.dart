import 'dart:async';

import 'package:device_user_agent/src/agents/linux_agent_info.dart';
import 'package:device_user_agent/src/agents/macos_agent_info.dart';
import 'package:device_user_agent/src/agents/windows_agent_info.dart';
import 'package:device_user_agent/src/core/platform_agent_info.dart';
import 'package:flutter/foundation.dart';

import 'agents/android_agent_info.dart';
import 'agents/ios_agent_info.dart';

/// A class that provides user agent information like device & package information.
class AgentInfo {
  /// Creates a new instance of [AgentInfo].
  const AgentInfo();

  PlatformAgentInfo get _platformAgentInfo {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => AndroidAgentInfo(),
      TargetPlatform.iOS => IosAgentInfo(),
      TargetPlatform.macOS => MacosAgentInfo(),
      TargetPlatform.windows => WindowsAgentInfo(),
      TargetPlatform.linux => LinuxAgentInfo(),
      TargetPlatform.fuchsia =>
        throw UnsupportedError('Fuchsia is not supported.'),
    } as PlatformAgentInfo;
  }

  /// The package name of the application. (e.g., 'com.example.app')
  Future<String> get packageName => _platformAgentInfo.packageName;

  /// The version name of the application. (e.g., '1.0.0')
  Future<String> get appVersionName => _platformAgentInfo.appVersionName;

  /// The version code of the application. (e.g., '1')
  Future<String> get appVersionCode => _platformAgentInfo.appVersionCode;

  /// The manufacturer of the device. (e.g., 'Apple')
  Future<String> get deviceManufacturer {
    return _platformAgentInfo.deviceManufacturer;
  }

  /// The model of the device. (e.g., 'iPhone')
  Future<String> get deviceModel => _platformAgentInfo.deviceModel;

  /// The name of the device. (e.g., 'iPhone 15 Pro Max')
  Future<String> get deviceName => _platformAgentInfo.deviceName;

  /// The resolution of the device screen. (e.g., '1080*1920')
  String get deviceResolution => _platformAgentInfo.deviceResolution;

  /// The pixel ratio of the device screen. (e.g., '2.0')
  double get devicePixelRatio => _platformAgentInfo.devicePixelRatio;

  /// The name of the operating system. (e.g., 'iOS')
  String get osName => _platformAgentInfo.osName;

  /// The version of the operating system. (e.g., '17.1.5')
  Future<String> get osVersion => _platformAgentInfo.osVersion;

  /// The CPU architecture of the device. (e.g., 'arm64-v8a', 'arm64', 'x86_64')
  Future<String> get architecture => _platformAgentInfo.architecture;
}
