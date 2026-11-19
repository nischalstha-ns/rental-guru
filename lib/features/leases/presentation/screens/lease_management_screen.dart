import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../leases/domain/providers/lease_provider.dart';

class LeaseManagementScreen extends ConsumerWidget {
  const LeaseManagementScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leases = ref.watch(myLeasesProvider);
    return Scaffold(appBar: AppBar(title: const Text('My Leases')), body: leases.when(data: (d) => RefreshIndicator(onRefresh: () async => ref.refresh(myLeasesProvider), child: ListView.builder(padding: const EdgeInsets.all(8), itemCount: d.length, itemBuilder: (_, i) => LeaseCard(lease: d[i]))), loading: () => const Center(child: CircularProgressIndicator()), error: (e, _) => Center(child: Text('Error: $e'))));
  }
}
class LeaseCard extends StatelessWidget {
  final dynamic lease;
  const LeaseCard({super.key, required this.lease});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = lease.status == AppConstants.leaseStatusActive;
    return Card(margin: const EdgeInsets.all(8), child: ListTile(title: Text(lease.propertyId?.toString() ?? ''), subtitle: Text('Ends: ${lease.endDate?.toString().split(" ").first ?? ""}'), trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: isActive ? Colors.green[100] : Colors.grey[200], borderRadius: BorderRadius.circular(12)), child: Text(isActive ? 'Active' : 'Ended', style: TextStyle(color: isActive ? Colors.green[900] : Colors.grey[700], fontSize: 12)))));
  }
}