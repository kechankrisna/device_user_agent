import 'package:device_user_agent/device_user_agent.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device User Agent',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<({String uaString, DeviceUserAgentParser parsed})> _load() async {
    final uaString = await DeviceUserAgent.instance.build();
    debugPrint('User Agent String: $uaString');
    final parsed = DeviceUserAgentParser.parse(uaString)!;
    debugPrint('Parsed User Agent: $parsed');
    final hints = parsed.userAgentClientHintsHeader();
    debugPrint('Client Hints Headers: $hints');
    return (uaString: uaString, parsed: parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Device User Agent'),
      ),
      body: FutureBuilder(
        future: _load(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final uaString = snapshot.data!.uaString;
          final parsed = snapshot.data!.parsed;
          final hints = parsed.userAgentClientHintsHeader();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionCard(
                title: 'User Agent String',
                children: [
                  _InfoRow(label: 'Raw', value: uaString, selectable: true),
                ],
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Parsed Fields',
                children: [
                  _InfoRow(label: 'Package', value: parsed.packageName),
                  _InfoRow(label: 'App Version', value: parsed.appVersionName),
                  _InfoRow(label: 'Build Number', value: parsed.appVersionCode),
                  _InfoRow(label: 'OS', value: parsed.osName),
                  _InfoRow(label: 'OS Version', value: parsed.osVersion),
                  _InfoRow(label: 'Device Name', value: parsed.deviceName),
                  _InfoRow(label: 'Manufacturer', value: parsed.deviceManufacturer),
                  _InfoRow(label: 'Model', value: parsed.deviceModel),
                  _InfoRow(label: 'Resolution', value: parsed.deviceResolution),
                  _InfoRow(label: 'Pixel Ratio', value: parsed.devicePixelRatio),
                  _InfoRow(label: 'Architecture', value: parsed.architecture.isEmpty ? '—' : parsed.architecture),
                ],
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Client Hints Headers',
                children: hints.entries
                    .map((e) => _InfoRow(label: e.key, value: e.value))
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.selectable = false,
  });

  final String label;
  final String value;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: selectable
                ? SelectableText(
                    value,
                    style: textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  )
                : Text(
                    value,
                    style: textTheme.bodySmall,
                  ),
          ),
        ],
      ),
    );
  }
}
