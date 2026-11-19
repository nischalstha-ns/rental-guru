
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../domain/providers/auth_provider.dart';

class AccountStatusScreen extends ConsumerWidget {
  const AccountStatusScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(appBar: AppBar(title: const Text('Account Status'), backgroundColor: theme.colorScheme.errorContainer),
      body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.block, size: 72, color: theme.colorScheme.error),
        const SizedBox(height: 16), Text('Account Suspended', style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.error)),
        const SizedBox(height: 8), Text('Your account has been temporarily suspended. Please contact support for assistance.', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 32),
        FilledButton(onPressed: () async { await ref.read(authRepositoryProvider).signOut(); context.go(RouteName.login); }, child: const Text('Sign Out')),
      ])))),
    );
  }
}
