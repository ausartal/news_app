import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/theme_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeControllerProvider);
    final themeController = ref.read(themeControllerProvider.notifier);

    return CustomScrollView(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        const SliverAppBar(
          pinned: true,
          title: Text('Settings'),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Card(
                  child: SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle:
                        const Text('Switch between light and dark theme.'),
                    value: isDarkMode,
                    onChanged: (_) => themeController.toggleTheme(),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.offline_bolt_rounded),
                    title: const Text('Offline Cache'),
                    subtitle: const Text(
                        'Latest successful data is kept locally for offline viewing.'),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.tune_rounded),
                    title: const Text('API Powered'),
                    subtitle: const Text(
                        'News data is fetched directly from NewsAPI.org.'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
