import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/domain/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authStateProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), actions: [
        IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () => context.push(RouteName.settings)),
      ]),
      body: state.when(
        data: (d) {
          if (d.user == null) return const Center(child: CircularProgressIndicator());
          return ListView(padding: const EdgeInsets.all(16), children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  CircleAvatar(radius: 32, backgroundColor: Theme.of(context).colorScheme.primaryContainer, child: Icon(Icons.person, size: 32, color: Theme.of(context).colorScheme.onPrimaryContainer)),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(d.role?.capitalize() ?? 'User', style: Theme.of(context).textTheme.titleLarge),
                    Text(d.user!.email ?? '', style: Theme.of(context).textTheme.bodyMedium),
                    _statusChip(context, d.verificationStatus ?? AppConstants.verificationStatusNotSubmitted),
                  ])),
                ]),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(leading: const Icon(Icons.edit_outlined), title: const Text('Edit Profile'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push(RouteName.editProfile)),
            ListTile(leading: const Icon(Icons.verified_user), title: const Text('Verification Status'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push(RouteName.verificationStatus)),
            ListTile(leading: const Icon(Icons.lock_outline), title: const Text('Security'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async { await ref.read(authRepositoryProvider).signOut(); context.go(RouteName.login); },
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: FilledButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error, backgroundColor: Theme.of(context).colorScheme.errorContainer),
            ),
          ]);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _statusChip(BuildContext ctx, String status) {
    final color = switch (status) {
      AppConstants.verificationStatusApproved => Colors.green,
      AppConstants.verificationStatusPending => Colors.orange,
      _ => Colors.grey,
    };
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
      child: Text(status.replaceAll('_', ' ').capitalize(), style: TextStyle(color: color, fontSize: 12)),
    );
  }
}

extension on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
}