import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/maintenance_request_model.dart';
import '../../../maintenance/domain/providers/maintenance_provider.dart';

class MaintenanceListScreen extends ConsumerWidget {
  const MaintenanceListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(maintenanceRequestsProvider);
    return Scaffold(appBar: AppBar(title: const Text('Maintenance Requests')), body: requests.when(data: (d) => RefreshIndicator(onRefresh: () async => ref.refresh(maintenanceRequestsProvider), child: ListView.builder(padding: const EdgeInsets.all(8), itemCount: d.length, itemBuilder: (_, i) => MaintenanceCard(request: d[i]))), loading: () => const Center(child: CircularProgressIndicator()), error: (e, _) => Center(child: Text('Error: $e'))));
  }
}
class MaintenanceCard extends StatelessWidget {
  final MaintenanceRequestModel request;
  const MaintenanceCard({super.key, required this.request});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (request.priority) { AppConstants.maintenancePriorityLow => Colors.blue, AppConstants.maintenancePriorityMedium => Colors.orange, AppConstants.maintenancePriorityHigh => Colors.red, AppConstants.maintenancePriorityEmergency => Colors.red.shade700, _ => Colors.grey };
    return Card(margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: ListTile(leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.2), child: Icon(_priorityIcon(request.priority), color: color)), title: Text(request.description), subtitle: Text('Priority: ${request.priority.capitalize()} | Status: ${request.status.capitalize()}'), trailing: Text(request.createdAt.toLocal().toString().split(" ").first)));
  }
  IconData _priorityIcon(String priority) => switch (priority) { AppConstants.maintenancePriorityLow => Icons.info_outline, AppConstants.maintenancePriorityMedium => Icons.warning_amber_outlined, AppConstants.maintenancePriorityHigh => Icons.error_outline, AppConstants.maintenancePriorityEmergency => Icons.error_outline, _ => Icons.help_outline };
}
extension on String { String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1); }