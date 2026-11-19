import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import './property_detail_screen.dart';
import '../../../properties/domain/providers/property_provider.dart';

class PropertyListingScreen extends ConsumerWidget {
  const PropertyListingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final props = ref.watch(propertyListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Properties')),
      body: props.when(
        data: (d) {
          if (d.isEmpty) {
            return const Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.home_outlined, size: 48),
                SizedBox(height: 16),
                Text('No properties yet'),
              ]),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(propertyListProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: d.length,
              itemBuilder: (_, i) => PropertyCard(property: d[i]),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final dynamic property;
  const PropertyCard({super.key, required this.property});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PropertyDetailScreen(propertyId: property.id))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset(
            'assets/images/sample_house.jpg',
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 150,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, size: 48),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(property.title ?? '', style: Theme.of(context).textTheme.titleLarge)),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(12)),
                  child: Text('\$${property.monthlyRent?.toStringAsFixed(0) ?? ''}', style: Theme.of(context).textTheme.titleSmall),
                ),
              ]),
            ]),
          ),
          Row(children: [
            _infoChip(context, Icons.bedroom_parent, '${property.bedrooms ?? 0} Beds'),
            _infoChip(context, Icons.bathtub, '${property.bathrooms ?? 0} Baths'),
            _infoChip(context, Icons.square_foot, '${property.areaSqFt ?? 0} sqft'),
          ]),
          if (property.description != null && property.description.toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              property.description.toString().length > 80
                  ? property.description.toString().substring(0, 80) + '...'
                  : property.description.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Row(children: [
              const Icon(Icons.location_on_outlined, size: 16),
              const SizedBox(width: 4),
              Expanded(child: Text('${property.city ?? ''}, ${property.province ?? property.district ?? ''}', style: Theme.of(context).textTheme.bodySmall)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _infoChip(BuildContext ctx, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        avatar: Icon(icon, size: 16),
        label: Text(label, style: Theme.of(ctx).textTheme.labelSmall),
      ),
    );
  }
}