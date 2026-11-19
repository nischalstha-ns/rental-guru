import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/application_model.dart';
import '../../../applications/domain/providers/application_provider.dart';
import '../../../auth/domain/providers/auth_provider.dart';

class ApplicationDetailScreen extends ConsumerWidget {
  final String applicationId;
  const ApplicationDetailScreen({super.key, required this.applicationId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(applicationDetailProvider(applicationId));
    final state = ref.watch(authStateProvider);
    return Scaffold(appBar: AppBar(title: const Text('Application Details')), body: app.when(
      data: (d) => state.when(data: (a) {
        if (a.role == AppConstants.rolePropertyManager) return _managerView(context, d, ref);
        return _tenantView(context, d);
      }, loading: () => const Center(child: CircularProgressIndicator()), error: (e, _) => Center(child: Text('Error: '))),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: ')),
    ));
  }
  Widget _managerView(BuildContext ctx, RentalApplicationModel app, WidgetRef ref) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(Icons.person, color: Theme.of(ctx).colorScheme.primary), const SizedBox(width: 8), Text(app.tenantId, style: Theme.of(ctx).textTheme.titleMedium)]),
        const Divider(),
        Row(children: [Icon(Icons.calendar_today, color: Theme.of(ctx).colorScheme.primary), const SizedBox(width: 8), Text('Move-in: ')]),
      ]))),
      Row(children: [Expanded(child: OutlinedButton(onPressed: () async { await ref.read(applicationRepositoryProvider).updateStatus(applicationId: app.id, status: AppConstants.applicationStatusRejected, rejectionReason: 'Not suitable'); Navigator.pop(ctx); }, child: const Text('Reject'))), const SizedBox(width: 16), Expanded(child: FilledButton(onPressed: () async { await ref.read(applicationRepositoryProvider).updateStatus(applicationId: app.id, status: AppConstants.applicationStatusApproved); Navigator.pop(ctx); }, child: const Text('Approve')))]),
    ]);
  }
  Widget _tenantView(BuildContext ctx, RentalApplicationModel app) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Application ID: ', style: Theme.of(ctx).textTheme.bodySmall),
        Text('Property ID: ', style: Theme.of(ctx).textTheme.titleMedium),
        Text('Status: ', style: Theme.of(ctx).textTheme.bodyMedium), Text(app.status, style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(color: app.status == AppConstants.applicationStatusPending ? Colors.orange : app.status == AppConstants.applicationStatusApproved ? Colors.green : Colors.red)),
      ]))),
    ]);
  }
}