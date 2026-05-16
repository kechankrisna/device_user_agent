import 'package:device_user_agent/src/core/platform_agent_info.dart';

/// A class that provides user agent information for the macOS platform.
class MacosAgentInfo extends PlatformAgentInfo<MacOsDeviceInfo> {
  @override
  Future<MacOSAgentSource> initializeSource(
    DeviceInfoPlugin deviceInfo,
    PackageInfo packageInfo,
  ) async {
    return AgentSource.from(packageInfo, await deviceInfo.macOsInfo);
  }

  @override
  Future<String> get deviceManufacturer => Future.value('Apple');

  @override
  Future<String> get deviceModel => select((s) => s.device.model);

  @override
  Future<String> get deviceName => select((s) => s.device.hostName);

  @override
  String get osName => 'macOS';

  @override
  Future<String> get osVersion {
    return select((s) {
      final d = s.device;
      return '${d.majorVersion}.${d.minorVersion}.${d.patchVersion}';
    });
  }

  @override
  Future<String> get architecture => select((s) => s.device.arch);
}
