import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../auth/domain/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: AppBar(title: const Text('Settings')), body: ListView(children: [
      ListTile(leading: const Icon(Icons.person_outline), title: const Text('Profile'), onTap: () => context.push(RouteName.profile)),
      ListTile(leading: const Icon(Icons.lock_outline), title: const Text('Security'), onTap: () {}),
      ListTile(leading: const Icon(Icons.notifications_outlined), title: const Text('Notifications'), onTap: () {}),
      ListTile(leading: const Icon(Icons.language), title: const Text('Language'), onTap: () {}),
      ListTile(leading: const Icon(Icons.info_outline), title: const Text('About'), onTap: () {}),
      const Divider(),
      ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text('Sign Out', style: TextStyle(color: Colors.red)), onTap: () async { await ref.read(authRepositoryProvider).signOut(); context.go(RouteName.login); }),
    ]));
  }
}