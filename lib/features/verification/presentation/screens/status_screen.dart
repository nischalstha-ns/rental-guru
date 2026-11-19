import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/providers/auth_provider.dart';
import '../../../../core/constants/app_constants.dart';

class VerificationStatusScreen extends ConsumerWidget {
  const VerificationStatusScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authStateProvider);
    final theme = Theme.of(context);
    return Scaffold(appBar: AppBar(title: const Text('Verification Status')),
      body: state.when(
        data: (d) {
          final status = d.verificationStatus ?? AppConstants.verificationStatusNotSubmitted;
          final color = switch (status) { AppConstants.verificationStatusApproved => Colors.green, AppConstants.verificationStatusPending => Colors.orange, AppConstants.verificationStatusRejected => Colors.red, _ => Colors.grey };
          return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(status == AppConstants.verificationStatusApproved ? Icons.verified : status == AppConstants.verificationStatusRejected ? Icons.error_outline : Icons.pending, size: 72, color: color),
            const SizedBox(height: 16), Text('Verification: ', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8), Text(status.replaceAll('_', ' ').capitalize(), style: theme.textTheme.titleMedium?.copyWith(color: color)),
          ]));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ));
  }
}
extension on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
}