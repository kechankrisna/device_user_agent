import 'package:device_user_agent/src/core/platform_agent_info.dart';

/// A class that provides user agent information for the Windows platform.
class WindowsAgentInfo extends PlatformAgentInfo<WindowsDeviceInfo> {
  @override
  Future<WindowsAgentSource> initializeSource(
    DeviceInfoPlugin deviceInfo,
    PackageInfo packageInfo,
  ) async {
    return AgentSource.from(packageInfo, await deviceInfo.windowsInfo);
  }

  @override
  Future<String> get deviceManufacturer {
    return select((s) => s.device.registeredOwner);
  }

  @override
  Future<String> get deviceModel => select((s) => s.device.releaseId);

  @override
  Future<String> get deviceName => select((s) => s.device.computerName);

  @override
  String get osName => 'Windows';

  @override
  Future<String> get osVersion {
    return select((s) => s.device.displayVersion);
  }

  // buildLabEx format: "22000.1.amd64fre.co_release.210604-1628"
  // The 3rd segment encodes arch as a prefix before "fre" or "chk".
  static final _archPattern = RegExp(r'^(\w+?)(?:fre|chk)$');

  @override
  Future<String> get architecture {
    return select((s) {
      final parts = s.device.buildLabEx.split('.');
      if (parts.length >= 3) {
        final match = _archPattern.firstMatch(parts[2]);
        if (match != null) return match.group(1)!;
      }
      return '';
    });
  }
}
