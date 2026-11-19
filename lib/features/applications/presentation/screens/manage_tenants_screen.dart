import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../data/models/application_model.dart';
import '../../../applications/domain/providers/application_provider.dart';

class ManageTenantsScreen extends ConsumerWidget {
  const ManageTenantsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(approvedApplicationsProvider);
    return Scaffold(appBar: AppBar(title: const Text('Manage Tenants')), body: apps.when(data: (d) => RefreshIndicator(onRefresh: () async => ref.refresh(approvedApplicationsProvider), child: ListView.builder(padding: const EdgeInsets.all(8), itemCount: d.length, itemBuilder: (_, i) => ApplicationCard(application: d[i]))), loading: () => const Center(child: CircularProgressIndicator()), error: (e, _) => Center(child: Text('Error: $e'))));
  }
}
class ApplicationCard extends StatelessWidget {
  final RentalApplicationModel application;
  const ApplicationCard({super.key, required this.application});
  @override
  Widget build(BuildContext context) {
    return Card(margin: const EdgeInsets.all(8), child: ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: Text(application.tenantId ?? ''), subtitle: Text('Applied for ${application.propertyId ?? ''}')));
  }
}