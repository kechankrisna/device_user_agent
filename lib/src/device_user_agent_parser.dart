/// Parsed representation of a device user agent string.
class DeviceUserAgentParser {
  const DeviceUserAgentParser({
    required this.packageName,
    required this.appVersionName,
    required this.osName,
    required this.osVersion,
    required this.deviceName,
    required this.appVersionCode,
    required this.deviceManufacturer,
    required this.deviceModel,
    required this.deviceResolution,
    required this.devicePixelRatio,
    this.architecture = '',
  });

  final String packageName;
  final String appVersionName;
  final String osName;
  final String osVersion;
  final String deviceName;
  final String appVersionCode;
  final String deviceManufacturer;
  final String deviceModel;
  final String deviceResolution;
  final String devicePixelRatio;

  /// CPU architecture (e.g. 'arm64-v8a', 'arm64', 'x86_64').
  /// Empty string when the UA string was produced without the `arch/` segment.
  final String architecture;

  // device_pixel_ratio uses [^\s]+ so it stops before the optional arch segment.
  static final _pattern = RegExp(
    r'(?<package_name>.+)/(?<app_version_name>.+) \((?<os_name>.+) (?<os_version>.+); (?<device_name>.+); build:(?<app_version_code>\d+)\) oem/(?<device_manufacturer>.+) model/(?<device_model>.+) screen/(?<device_resolution>\d+\*\d+)/(?<device_pixel_ratio>[^\s]+)(?: arch/(?<architecture>\S+))?',
  );

  /// Parses a user agent string and returns a [DeviceUserAgentParser], or
  /// `null` if the string does not match the expected format.
  static DeviceUserAgentParser? parse(String userAgent) {
    final match = _pattern.firstMatch(userAgent);
    if (match == null) return null;

    return DeviceUserAgentParser(
      packageName: match.namedGroup('package_name')!,
      appVersionName: match.namedGroup('app_version_name')!,
      osName: match.namedGroup('os_name')!,
      osVersion: match.namedGroup('os_version')!,
      deviceName: match.namedGroup('device_name')!,
      appVersionCode: match.namedGroup('app_version_code')!,
      deviceManufacturer: match.namedGroup('device_manufacturer')!,
      deviceModel: match.namedGroup('device_model')!,
      deviceResolution: match.namedGroup('device_resolution')!,
      devicePixelRatio: match.namedGroup('device_pixel_ratio')!,
      architecture: match.namedGroup('architecture') ?? '',
    );
  }

  /// Reconstructs the user agent string.
  String toUserAgentString() =>
      '$packageName/$appVersionName '
      '($osName $osVersion; $deviceName; build:$appVersionCode) '
      'oem/$deviceManufacturer '
      'model/$deviceModel '
      'screen/$deviceResolution/$devicePixelRatio'
      '${architecture.isNotEmpty ? ' arch/$architecture' : ''}';

  /// Returns a map of Client Hints request headers derived from the parsed UA.
  Map<String, String> userAgentClientHintsHeader() {
    final isMobile = osName == 'Android' || osName == 'iOS';
    return {
      'User-Agent': toUserAgentString(),
      'Sec-CH-UA-Arch': architecture,
      'Sec-CH-UA-Model': deviceModel,
      'Sec-CH-UA-Platform': osName,
      'Sec-CH-UA-Platform-Version': osVersion,
      'Sec-CH-UA': '"$packageName"; v="$appVersionName"',
      'Sec-CH-UA-Full-Version': appVersionName,
      'Sec-CH-UA-Mobile': isMobile ? '?1' : '?0',
    };
  }

  @override
  String toString() => 'DeviceUserAgentParser('
      'packageName: $packageName, '
      'appVersionName: $appVersionName, '
      'osName: $osName, '
      'osVersion: $osVersion, '
      'deviceName: $deviceName, '
      'appVersionCode: $appVersionCode, '
      'deviceManufacturer: $deviceManufacturer, '
      'deviceModel: $deviceModel, '
      'deviceResolution: $deviceResolution, '
      'devicePixelRatio: $devicePixelRatio, '
      'architecture: $architecture)';
}
