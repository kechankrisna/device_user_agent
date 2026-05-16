import 'package:device_user_agent/src/core/platform_agent_info.dart';

/// A class that provides user agent information for the Android platform.
class IosAgentInfo extends PlatformAgentInfo<IosDeviceInfo> {
  @override
  Future<IosAgentSource> initializeSource(
    DeviceInfoPlugin deviceInfo,
    PackageInfo packageInfo,
  ) async {
    return AgentSource.from(packageInfo, await deviceInfo.iosInfo);
  }

  @override
  Future<String> get deviceManufacturer => Future.value('Apple');

  @override
  Future<String> get deviceModel => select((s) => s.device.model);

  @override
  Future<String> get deviceName => select((s) => s.device.name);

  @override
  String get osName => 'iOS';

  @override
  Future<String> get osVersion {
    return select((s) => s.device.systemVersion);
  }

  // utsname.machine returns an arch string on simulators ("arm64", "x86_64")
  // and a hardware model ID on physical devices ("iPhone16,1").
  @override
  Future<String> get architecture => select((s) => s.device.utsname.machine);
}
