import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import 'auth/domain/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(appBar: AppBar(title: const Text('Settings')), body: ListView(children: [
      SwitchListTile(title: const Text('Dark Mode'), subtitle: const Text('Use dark theme'), value: Theme.of(context).brightness == Brightness.dark, onChanged: (v) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(v ? 'Dark mode enabled' : 'Light mode enabled')))),
      const Divider(),
      ListTile(leading: const Icon(Icons.info_outline), title: const Text('About'), subtitle: const Text('Rent Guru v1.0.0'), onTap: () => showDialog(context: context, builder: (_) => const AlertDialog(title: Text('About Rent Guru'), content: Text('A production-ready rental management system powered by Flutter and Supabase.')))),
      const Divider(),
      ListTile(leading: const Icon(Icons.help_outline), title: const Text('Help & Support'), onTap: () {}),
      const Divider(),
      ListTile(leading: Icon(Icons.logout, color: theme.colorScheme.error), title: Text('Sign Out', style: TextStyle(color: theme.colorScheme.error)), onTap: () async { await ref.read(authStateProvider.future); if (context.mounted) context.go(RouteName.login); }),
    ]));
  }
}
