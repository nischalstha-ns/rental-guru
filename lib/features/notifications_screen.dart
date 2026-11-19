import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth/domain/providers/auth_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authStateProvider);
    return Scaffold(appBar: AppBar(title: const Text('Notifications')), body: state.when(data: (d) { if (d.user == null) return const Center(child: Text('Sign in to view notifications')); return const Center(child: Text('No new notifications')); }, loading: () => const Center(child: CircularProgressIndicator()), error: (e, _) => Center(child: Text('Error: $e'))));
  }
}