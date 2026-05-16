import 'package:device_user_agent/src/core/platform_agent_info.dart';

/// A class that provides user agent information for the Android platform.
class AndroidAgentInfo extends PlatformAgentInfo<AndroidDeviceInfo> {
  @override
  Future<AndroidAgentSource> initializeSource(
    DeviceInfoPlugin deviceInfo,
    PackageInfo packageInfo,
  ) async {
    return AgentSource.from(packageInfo, await deviceInfo.androidInfo);
  }

  @override
  Future<String> get deviceManufacturer => select((s) => s.device.manufacturer);

  @override
  Future<String> get deviceModel => select((s) => s.device.model);

  @override
  Future<String> get deviceName => select((s) => s.device.display);

  @override
  String get osName => 'Android';

  @override
  Future<String> get osVersion {
    return select((s) => s.device.version.sdkInt.toString());
  }

  @override
  Future<String> get architecture {
    return select((s) => s.device.supportedAbis.firstOrNull ?? '');
  }
}
