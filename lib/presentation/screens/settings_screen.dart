import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark theme'),
            subtitle: const Text('Saved with Shared Preferences'),
            value: mode == ThemeMode.dark,
            onChanged: (value) {
              ref.read(themeProvider.notifier).toggleTheme(value);
            },
          ),
          const Divider(height: 1),
          const ListTile(
            leading: Icon(Icons.storage),
            title: Text('Local favorites'),
            subtitle: Text('Saved in Drift SQLite database'),
          ),
          const ListTile(
            leading: Icon(Icons.cloud_queue),
            title: Text('Order history'),
            subtitle: Text('Saved in Cloud Firestore after Firebase setup'),
          ),
        ],
      ),
    );
  }
}
