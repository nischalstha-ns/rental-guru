import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../properties/domain/providers/property_provider.dart';
import '../../../auth/domain/providers/auth_provider.dart';

class PropertyDetailScreen extends ConsumerWidget {
  final String propertyId;
  const PropertyDetailScreen({super.key, required this.propertyId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prop = ref.watch(propertyDetailProvider(propertyId));
    final state = ref.watch(authStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Details'),
        actions: [IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {})],
      ),
      body: prop.when(
        data: (d) => state.when(
          data: (a) {
            if (a.accountStatus == 'suspended') return const Center(child: Text('Account suspended'));
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Image.asset(
                  'assets/images/sample_house.jpg',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 64),
                  ),
                ),
                const SizedBox(height: 16),
                Text(d.title ?? '', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('\$${d.monthlyRent?.toStringAsFixed(0) ?? ''}/month', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
                const SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.location_on_outlined, size: 16),
                  const SizedBox(width: 4),
                  Text('${d.city ?? ''}, ${d.province ?? d.district ?? ''}'),
                ]),
                if (d.description != null) ...[
                  const SizedBox(height: 16),
                  Text('Description', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(d.description.toString()),
                ],
                const SizedBox(height: 16),
                Row(children: [
                  _chip(context, Icons.bedroom_parent, '${d.bedrooms ?? 0} Beds'),
                  _chip(context, Icons.bathtub, '${d.bathrooms ?? 0} Baths'),
                  _chip(context, Icons.square_foot, '${d.areaSqFt ?? 0} sqft'),
                ]),
                const SizedBox(height: 32),
                FilledButton(onPressed: () => context.push('${RouteName.applicationForm}/${d.id}'), child: const Text('Apply Now')),
              ]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _chip(BuildContext ctx, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        avatar: Icon(icon, size: 16),
        label: Text(label, style: Theme.of(ctx).textTheme.labelSmall),
      ),
    );
  }
}