import 'package:device_user_agent/src/device_user_agent_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const rawIos =
      'com.acmesoftware.dua/1.0.19 (iOS 17.2; iPhone 15 Pro Max; build:240322033) oem/Apple model/iPhone15,4 screen/1290*2796/3.0';
  const rawIosWithArch =
      'com.acmesoftware.dua/1.0.19 (iOS 17.2; iPhone 15 Pro Max; build:240322033) oem/Apple model/iPhone15,4 screen/1290*2796/3.0 arch/arm64';
  const rawAndroid =
      'com.example.app/2.3.1 (Android 14; Pixel 8 Pro; build:230901001) oem/Google model/Pixel 8 Pro screen/1344*2992/2.625';
  const rawAndroidWithArch =
      'com.example.app/2.3.1 (Android 14; Pixel 8 Pro; build:230901001) oem/Google model/Pixel 8 Pro screen/1344*2992/2.625 arch/arm64-v8a';
  const rawMacos =
      'com.example.app/3.0.0 (macOS 14.4.1; MacBook Pro; build:300001) oem/Apple model/MacBookPro18,1 screen/3456*2234/2.0 arch/arm64';
  const rawWindows =
      'com.example.app/3.0.0 (Windows 11; DESKTOP-ABC123; build:300001) oem/Microsoft Corporation model/21H2 screen/1920*1080/1.5 arch/amd64';
  const rawLinux =
      'com.example.app/3.0.0 (Linux 22.04; Ubuntu 22.04 LTS; build:300001) oem/Ubuntu model/ubuntu screen/2560*1440/1.0 arch/x86_64';

  group('DeviceUserAgentParser.parse', () {
    test('parses all fields from an iOS user agent string', () {
      final ua = DeviceUserAgentParser.parse(rawIos);

      expect(ua, isNotNull);
      expect(ua!.packageName, 'com.acmesoftware.dua');
      expect(ua.appVersionName, '1.0.19');
      expect(ua.osName, 'iOS');
      expect(ua.osVersion, '17.2');
      expect(ua.deviceName, 'iPhone 15 Pro Max');
      expect(ua.appVersionCode, '240322033');
      expect(ua.deviceManufacturer, 'Apple');
      expect(ua.deviceModel, 'iPhone15,4');
      expect(ua.deviceResolution, '1290*2796');
      expect(ua.devicePixelRatio, '3.0');
      expect(ua.architecture, '');
    });

    test('parses architecture from an iOS user agent string with arch segment', () {
      final ua = DeviceUserAgentParser.parse(rawIosWithArch);

      expect(ua, isNotNull);
      expect(ua!.architecture, 'arm64');
      expect(ua.devicePixelRatio, '3.0');
    });

    test('parses all fields from an Android user agent string', () {
      final ua = DeviceUserAgentParser.parse(rawAndroid);

      expect(ua, isNotNull);
      expect(ua!.packageName, 'com.example.app');
      expect(ua.appVersionName, '2.3.1');
      expect(ua.osName, 'Android');
      expect(ua.osVersion, '14');
      expect(ua.deviceName, 'Pixel 8 Pro');
      expect(ua.appVersionCode, '230901001');
      expect(ua.deviceManufacturer, 'Google');
      expect(ua.deviceModel, 'Pixel 8 Pro');
      expect(ua.deviceResolution, '1344*2992');
      expect(ua.devicePixelRatio, '2.625');
      expect(ua.architecture, '');
    });

    test('parses architecture from an Android user agent string with arch segment', () {
      final ua = DeviceUserAgentParser.parse(rawAndroidWithArch);

      expect(ua, isNotNull);
      expect(ua!.architecture, 'arm64-v8a');
      expect(ua.devicePixelRatio, '2.625');
    });

    test('parses all fields from a macOS user agent string', () {
      final ua = DeviceUserAgentParser.parse(rawMacos);

      expect(ua, isNotNull);
      expect(ua!.osName, 'macOS');
      expect(ua.osVersion, '14.4.1');
      expect(ua.deviceManufacturer, 'Apple');
      expect(ua.deviceModel, 'MacBookPro18,1');
      expect(ua.deviceResolution, '3456*2234');
      expect(ua.devicePixelRatio, '2.0');
      expect(ua.architecture, 'arm64');
    });

    test('parses all fields from a Windows user agent string', () {
      final ua = DeviceUserAgentParser.parse(rawWindows);

      expect(ua, isNotNull);
      expect(ua!.osName, 'Windows');
      expect(ua.osVersion, '11');
      expect(ua.deviceManufacturer, 'Microsoft Corporation');
      expect(ua.deviceModel, '21H2');
      expect(ua.deviceResolution, '1920*1080');
      expect(ua.devicePixelRatio, '1.5');
      expect(ua.architecture, 'amd64');
    });

    test('parses all fields from a Linux user agent string', () {
      final ua = DeviceUserAgentParser.parse(rawLinux);

      expect(ua, isNotNull);
      expect(ua!.osName, 'Linux');
      expect(ua.osVersion, '22.04');
      expect(ua.deviceManufacturer, 'Ubuntu');
      expect(ua.deviceModel, 'ubuntu');
      expect(ua.deviceResolution, '2560*1440');
      expect(ua.devicePixelRatio, '1.0');
      expect(ua.architecture, 'x86_64');
    });

    test('returns null for an empty string', () {
      expect(DeviceUserAgentParser.parse(''), isNull);
    });

    test('returns null for a malformed string', () {
      expect(DeviceUserAgentParser.parse('not-a-user-agent'), isNull);
    });
  });

  group('DeviceUserAgentParser.toUserAgentString', () {
    test('reconstructs the original iOS user agent string (no arch)', () {
      final ua = DeviceUserAgentParser.parse(rawIos)!;
      expect(ua.toUserAgentString(), rawIos);
    });

    test('reconstructs the iOS user agent string with arch segment', () {
      final ua = DeviceUserAgentParser.parse(rawIosWithArch)!;
      expect(ua.toUserAgentString(), rawIosWithArch);
    });

    test('reconstructs the original Android user agent string (no arch)', () {
      final ua = DeviceUserAgentParser.parse(rawAndroid)!;
      expect(ua.toUserAgentString(), rawAndroid);
    });

    test('reconstructs the Android user agent string with arch segment', () {
      final ua = DeviceUserAgentParser.parse(rawAndroidWithArch)!;
      expect(ua.toUserAgentString(), rawAndroidWithArch);
    });

    test('reconstructs the macOS user agent string', () {
      final ua = DeviceUserAgentParser.parse(rawMacos)!;
      expect(ua.toUserAgentString(), rawMacos);
    });

    test('reconstructs the Windows user agent string', () {
      final ua = DeviceUserAgentParser.parse(rawWindows)!;
      expect(ua.toUserAgentString(), rawWindows);
    });

    test('reconstructs the Linux user agent string', () {
      final ua = DeviceUserAgentParser.parse(rawLinux)!;
      expect(ua.toUserAgentString(), rawLinux);
    });
  });

  group('DeviceUserAgentParser.userAgentClientHintsHeader', () {
    test('Sec-CH-UA-Arch is empty when arch segment is absent', () {
      final headers = DeviceUserAgentParser.parse(rawIos)!.userAgentClientHintsHeader();
      expect(headers['Sec-CH-UA-Arch'], '');
    });

    test('Sec-CH-UA-Arch reflects the parsed architecture for iOS', () {
      final headers = DeviceUserAgentParser.parse(rawIosWithArch)!.userAgentClientHintsHeader();

      expect(headers['User-Agent'], rawIosWithArch);
      expect(headers['Sec-CH-UA-Arch'], 'arm64');
      expect(headers['Sec-CH-UA-Platform'], 'iOS');
      expect(headers['Sec-CH-UA-Platform-Version'], '17.2');
      expect(headers['Sec-CH-UA-Model'], 'iPhone15,4');
      expect(headers['Sec-CH-UA'], '"com.acmesoftware.dua"; v="1.0.19"');
      expect(headers['Sec-CH-UA-Full-Version'], '1.0.19');
      expect(headers['Sec-CH-UA-Mobile'], '?1');
    });

    test('Sec-CH-UA-Arch reflects arm64-v8a for Android', () {
      final headers = DeviceUserAgentParser.parse(rawAndroidWithArch)!.userAgentClientHintsHeader();

      expect(headers['User-Agent'], rawAndroidWithArch);
      expect(headers['Sec-CH-UA-Arch'], 'arm64-v8a');
      expect(headers['Sec-CH-UA-Platform'], 'Android');
      expect(headers['Sec-CH-UA-Platform-Version'], '14');
      expect(headers['Sec-CH-UA-Model'], 'Pixel 8 Pro');
      expect(headers['Sec-CH-UA'], '"com.example.app"; v="2.3.1"');
      expect(headers['Sec-CH-UA-Full-Version'], '2.3.1');
      expect(headers['Sec-CH-UA-Mobile'], '?1');
    });

    test('marks non-mobile platforms as ?0', () {
      final headers = DeviceUserAgentParser.parse(rawMacos)!.userAgentClientHintsHeader();

      expect(headers['Sec-CH-UA-Mobile'], '?0');
      expect(headers['Sec-CH-UA-Arch'], 'arm64');
      expect(headers['Sec-CH-UA-Platform'], 'macOS');
    });

    test('Windows and Linux are treated as non-mobile', () {
      expect(
        DeviceUserAgentParser.parse(rawWindows)!.userAgentClientHintsHeader()['Sec-CH-UA-Mobile'],
        '?0',
      );
      expect(
        DeviceUserAgentParser.parse(rawLinux)!.userAgentClientHintsHeader()['Sec-CH-UA-Mobile'],
        '?0',
      );
    });
  });

  group('DeviceUserAgentParser.toString', () {
    test('includes all fields', () {
      final ua = DeviceUserAgentParser.parse(rawIosWithArch)!;
      final str = ua.toString();

      expect(str, contains('com.acmesoftware.dua'));
      expect(str, contains('1.0.19'));
      expect(str, contains('iOS'));
      expect(str, contains('17.2'));
      expect(str, contains('iPhone 15 Pro Max'));
      expect(str, contains('240322033'));
      expect(str, contains('Apple'));
      expect(str, contains('iPhone15,4'));
      expect(str, contains('1290*2796'));
      expect(str, contains('3.0'));
      expect(str, contains('arm64'));
    });
  });
}
