import 'package:device_user_agent/device_user_agent.dart';
import 'package:device_user_agent/src/agent_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Fake AgentInfo — overrides every getter with fixed values so no native
// plugin channels are needed. debugDefaultTargetPlatformOverride still sets
// the correct TargetPlatform context for any platform-branching logic.
// ---------------------------------------------------------------------------

class _FakeAgentInfo extends AgentInfo {
  const _FakeAgentInfo({
    required String packageName,
    required String appVersionName,
    required this.osName,
    required String osVersion,
    required String deviceName,
    required String appVersionCode,
    required String deviceManufacturer,
    required String deviceModel,
    required this.deviceResolution,
    required this.devicePixelRatio,
    required String architecture,
  })  : _packageName = packageName,
        _appVersionName = appVersionName,
        _osVersion = osVersion,
        _deviceName = deviceName,
        _appVersionCode = appVersionCode,
        _deviceManufacturer = deviceManufacturer,
        _deviceModel = deviceModel,
        _architecture = architecture;

  final String _packageName;
  final String _appVersionName;
  final String _osVersion;
  final String _deviceName;
  final String _appVersionCode;
  final String _deviceManufacturer;
  final String _deviceModel;
  final String _architecture;

  @override
  final String osName;
  @override
  final String deviceResolution;
  @override
  final double devicePixelRatio;

  @override
  Future<String> get packageName => Future.value(_packageName);
  @override
  Future<String> get appVersionName => Future.value(_appVersionName);
  @override
  Future<String> get osVersion => Future.value(_osVersion);
  @override
  Future<String> get deviceName => Future.value(_deviceName);
  @override
  Future<String> get appVersionCode => Future.value(_appVersionCode);
  @override
  Future<String> get deviceManufacturer => Future.value(_deviceManufacturer);
  @override
  Future<String> get deviceModel => Future.value(_deviceModel);
  @override
  Future<String> get architecture => Future.value(_architecture);
}

// ---------------------------------------------------------------------------
// Per-platform fake instances
// ---------------------------------------------------------------------------

const _ios = _FakeAgentInfo(
  packageName: 'com.acmesoftware.dua',
  appVersionName: '1.0.19',
  osName: 'iOS',
  osVersion: '17.2',
  deviceName: 'iPhone 15 Pro Max',
  appVersionCode: '240322033',
  deviceManufacturer: 'Apple',
  deviceModel: 'iPhone15,4',
  deviceResolution: '1290*2796',
  devicePixelRatio: 3.0,
  architecture: 'arm64',
);

const _android = _FakeAgentInfo(
  packageName: 'com.example.app',
  appVersionName: '2.3.1',
  osName: 'Android',
  osVersion: '14',
  deviceName: 'Pixel 8 Pro',
  appVersionCode: '230901001',
  deviceManufacturer: 'Google',
  deviceModel: 'Pixel 8 Pro',
  deviceResolution: '1344*2992',
  devicePixelRatio: 2.625,
  architecture: 'arm64-v8a',
);

const _macos = _FakeAgentInfo(
  packageName: 'com.example.app',
  appVersionName: '3.0.0',
  osName: 'macOS',
  osVersion: '14.4.1',
  deviceName: 'MacBook Pro',
  appVersionCode: '300001',
  deviceManufacturer: 'Apple',
  deviceModel: 'MacBookPro18,1',
  deviceResolution: '3456*2234',
  devicePixelRatio: 2.0,
  architecture: 'arm64',
);

const _windows = _FakeAgentInfo(
  packageName: 'com.example.app',
  appVersionName: '3.0.0',
  osName: 'Windows',
  osVersion: '11',
  deviceName: 'DESKTOP-ABC123',
  appVersionCode: '300001',
  deviceManufacturer: 'Microsoft Corporation',
  deviceModel: '21H2',
  deviceResolution: '1920*1080',
  devicePixelRatio: 1.5,
  architecture: 'amd64',
);

const _linux = _FakeAgentInfo(
  packageName: 'com.example.app',
  appVersionName: '3.0.0',
  osName: 'Linux',
  osVersion: '22.04',
  deviceName: 'Ubuntu 22.04 LTS',
  appVersionCode: '300001',
  deviceManufacturer: 'Ubuntu',
  deviceModel: 'ubuntu',
  deviceResolution: '2560*1440',
  devicePixelRatio: 1.0,
  architecture: 'x86_64',
);

// ---------------------------------------------------------------------------
// Helper — wraps the test body in try/finally so the override is always
// cleared before testWidgets runs _verifyInvariants.
// ---------------------------------------------------------------------------

Future<void> _runWithPlatform(
  TargetPlatform platform,
  Future<void> Function() body,
) async {
  debugDefaultTargetPlatformOverride = platform;
  try {
    await body();
  } finally {
    debugDefaultTargetPlatformOverride = null;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('DeviceUserAgent.build() → DeviceUserAgentParser.userAgentClientHintsHeader()', () {
    testWidgets('Simulate iOS behavior', (tester) async {
      await _runWithPlatform(TargetPlatform.iOS, () async {
        final uaString = await DeviceUserAgent.withAgentInfo(_ios).build();
        final headers = DeviceUserAgentParser.parse(uaString)!.userAgentClientHintsHeader();

        expect(headers['User-Agent'], uaString);
        expect(headers['Sec-CH-UA-Platform'], 'iOS');
        expect(headers['Sec-CH-UA-Arch'], 'arm64');
        expect(headers['Sec-CH-UA-Mobile'], '?1');
        expect(headers['Sec-CH-UA-Model'], 'iPhone15,4');
        expect(headers['Sec-CH-UA-Platform-Version'], '17.2');
        expect(headers['Sec-CH-UA-Full-Version'], '1.0.19');
      });
    });

    testWidgets('Simulate Android behavior', (tester) async {
      await _runWithPlatform(TargetPlatform.android, () async {
        final uaString = await DeviceUserAgent.withAgentInfo(_android).build();
        final headers = DeviceUserAgentParser.parse(uaString)!.userAgentClientHintsHeader();

        expect(headers['User-Agent'], uaString);
        expect(headers['Sec-CH-UA-Platform'], 'Android');
        expect(headers['Sec-CH-UA-Arch'], 'arm64-v8a');
        expect(headers['Sec-CH-UA-Mobile'], '?1');
        expect(headers['Sec-CH-UA-Model'], 'Pixel 8 Pro');
        expect(headers['Sec-CH-UA-Platform-Version'], '14');
        expect(headers['Sec-CH-UA-Full-Version'], '2.3.1');
      });
    });

    testWidgets('Simulate macOS behavior', (tester) async {
      await _runWithPlatform(TargetPlatform.macOS, () async {
        final uaString = await DeviceUserAgent.withAgentInfo(_macos).build();
        final headers = DeviceUserAgentParser.parse(uaString)!.userAgentClientHintsHeader();

        expect(headers['User-Agent'], uaString);
        expect(headers['Sec-CH-UA-Platform'], 'macOS');
        expect(headers['Sec-CH-UA-Arch'], 'arm64');
        expect(headers['Sec-CH-UA-Mobile'], '?0');
        expect(headers['Sec-CH-UA-Model'], 'MacBookPro18,1');
        expect(headers['Sec-CH-UA-Platform-Version'], '14.4.1');
      });
    });

    testWidgets('Simulate Windows behavior', (tester) async {
      await _runWithPlatform(TargetPlatform.windows, () async {
        final uaString = await DeviceUserAgent.withAgentInfo(_windows).build();
        final headers = DeviceUserAgentParser.parse(uaString)!.userAgentClientHintsHeader();

        expect(headers['User-Agent'], uaString);
        expect(headers['Sec-CH-UA-Platform'], 'Windows');
        expect(headers['Sec-CH-UA-Arch'], 'amd64');
        expect(headers['Sec-CH-UA-Mobile'], '?0');
        expect(headers['Sec-CH-UA-Platform-Version'], '11');
      });
    });

    testWidgets('Simulate Linux behavior', (tester) async {
      await _runWithPlatform(TargetPlatform.linux, () async {
        final uaString = await DeviceUserAgent.withAgentInfo(_linux).build();
        final headers = DeviceUserAgentParser.parse(uaString)!.userAgentClientHintsHeader();

        expect(headers['User-Agent'], uaString);
        expect(headers['Sec-CH-UA-Platform'], 'Linux');
        expect(headers['Sec-CH-UA-Arch'], 'x86_64');
        expect(headers['Sec-CH-UA-Mobile'], '?0');
        expect(headers['Sec-CH-UA-Platform-Version'], '22.04');
      });
    });

    testWidgets('omits arch/ segment when architecture is empty', (tester) async {
      await _runWithPlatform(TargetPlatform.android, () async {
        const noArch = _FakeAgentInfo(
          packageName: 'com.example.app',
          appVersionName: '1.0.0',
          osName: 'Android',
          osVersion: '13',
          deviceName: 'Galaxy S23',
          appVersionCode: '100',
          deviceManufacturer: 'Samsung',
          deviceModel: 'SM-S911B',
          deviceResolution: '1080*2340',
          devicePixelRatio: 2.5,
          architecture: '',
        );

        final uaString = await DeviceUserAgent.withAgentInfo(noArch).build();

        expect(uaString, isNot(contains('arch/')));
        final parsed = DeviceUserAgentParser.parse(uaString)!;
        expect(parsed.architecture, '');
        expect(parsed.toUserAgentString(), uaString);
      });
    });

    testWidgets('devicePixelRatio integer value serialises with decimal point', (tester) async {
      await _runWithPlatform(TargetPlatform.linux, () async {
        final uaString = await DeviceUserAgent.withAgentInfo(_linux).build();
        // 1.0 must stay "1.0", not "1" — parser regex expects [^\s]+
        expect(uaString, contains('/1.0 '));
        final parsed = DeviceUserAgentParser.parse(uaString);
        expect(parsed, isNotNull);
        expect(parsed!.devicePixelRatio, '1.0');
      });
    });

    testWidgets('built UA string round-trips through the parser on all platforms', (tester) async {
      final cases = [
        (TargetPlatform.iOS, _ios),
        (TargetPlatform.android, _android),
        (TargetPlatform.macOS, _macos),
        (TargetPlatform.windows, _windows),
        (TargetPlatform.linux, _linux),
      ];

      for (final (platform, info) in cases) {
        await _runWithPlatform(platform, () async {
          final uaString = await DeviceUserAgent.withAgentInfo(info).build();
          final parsed = DeviceUserAgentParser.parse(uaString)!;
          expect(parsed.toUserAgentString(), uaString,
              reason: '${platform.name}: round-trip failed');
        });
      }
    });
  });
}
