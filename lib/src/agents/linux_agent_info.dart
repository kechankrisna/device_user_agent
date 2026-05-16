import 'package:device_user_agent/src/core/platform_agent_info.dart';

/// A class that provides user agent information for the Linux platform.
class LinuxAgentInfo extends PlatformAgentInfo<LinuxDeviceInfo> {
  @override
  Future<LinuxAgentSource> initializeSource(
    DeviceInfoPlugin deviceInfo,
    PackageInfo packageInfo,
  ) async {
    return AgentSource.from(packageInfo, await deviceInfo.linuxInfo);
  }

  @override
  Future<String> get deviceManufacturer => select((s) => s.device.name);

  @override
  Future<String> get deviceModel => select((s) => s.device.id);

  @override
  Future<String> get deviceName => select((s) => s.device.prettyName);

  @override
  String get osName => 'Linux';

  @override
  Future<String> get osVersion {
    return select((s) => s.device.versionId ?? '0');
  }

  @override
  Future<String> get architecture => Future.value('x86_64');
}
