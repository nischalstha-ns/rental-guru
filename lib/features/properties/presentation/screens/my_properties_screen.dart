import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../properties/domain/providers/property_provider.dart';

class MyPropertiesScreen extends ConsumerWidget {
  const MyPropertiesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final props = ref.watch(myPropertiesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Properties')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteName.addProperty),
        child: const Icon(Icons.add),
      ),
      body: props.when(
        data: (d) => RefreshIndicator(
          onRefresh: () async => ref.refresh(myPropertiesProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: d.length,
            itemBuilder: (_, i) => PropertyCard(property: d[i]),
          ),
        ),
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
      margin: const EdgeInsets.all(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Image.asset(
          'assets/images/sample_house.jpg',
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: 120,
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported, size: 36),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(property.title ?? '', style: Theme.of(context).textTheme.titleMedium)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primaryContainer),
                onPressed: () {},
                child: const Text('Manage', style: TextStyle(color: Colors.white)),
              ),
            ]),
            const SizedBox(height: 4),
            Text(
              '\$${property.pricePerMonth?.toStringAsFixed(0) ?? ''}/mo',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ]),
        ),
      ]),
    );
  }
}