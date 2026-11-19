import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/application_model.dart';
import '../../../applications/domain/providers/application_provider.dart';

class MyApplicationsScreen extends ConsumerWidget {
  const MyApplicationsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(myApplicationsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      body: apps.when(
        data: (d) => RefreshIndicator(
          onRefresh: () async => ref.refresh(myApplicationsProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: d.length,
            itemBuilder: (_, i) => ApplicationCard(application: d[i]),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final RentalApplicationModel application;
  const ApplicationCard({super.key, required this.application});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color statusColor;
    switch (application.status) {
      case AppConstants.applicationStatusPending:
        statusColor = Colors.orange;
        break;
      case AppConstants.applicationStatusApproved:
        statusColor = theme.colorScheme.primaryContainer;
        break;
      case AppConstants.applicationStatusRejected:
        statusColor = theme.colorScheme.errorContainer;
        break;
      default:
        statusColor = Colors.grey[200]!;
    }
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(application.propertyId ?? ''),
        subtitle: Text('Applied on ${application.createdAt.toLocal().toString().split(" ").first}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            application.status.replaceAll('_', ' ').capitalize(),
            style: theme.textTheme.labelSmall,
          ),
        ),
        onTap: () => context.push('${RouteName.applicationReview}/${application.id}'),
      ),
    );
  }
}

extension on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
}