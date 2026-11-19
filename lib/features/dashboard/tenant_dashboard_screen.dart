import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../auth/domain/providers/auth_provider.dart';

class TenantDashboardScreen extends ConsumerWidget {
  const TenantDashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authStateProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Rent Guru'), actions: [
        IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () => context.push(RouteName.notifications)),
      ]),
      body: RefreshIndicator(onRefresh: () async {}, child: ListView(padding: const EdgeInsets.all(16), children: [
        state.when(
          data: (d) => Text('Welcome, ${d.user?.email?.split('@').first ?? 'User'}!', style: Theme.of(context).textTheme.titleLarge),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 8),
        if (state.hasValue && state.value?.verificationStatus != 'approved')
          Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.amber[50], borderRadius: BorderRadius.circular(8)),
            child: const Row(children: [Icon(Icons.info_outline, color: Colors.amber), SizedBox(width: 12), Expanded(child: Text('Complete your identity verification to access all features'))])),
        const SizedBox(height: 16),
        _quickAction(context, RouteName.propertyListing, 'Browse Properties', Icons.home_work, Theme.of(context).colorScheme.primary),
        _quickAction(context, RouteName.myApplications, 'My Applications', Icons.assignment, Theme.of(context).colorScheme.secondary),
        _quickAction(context, RouteName.verificationStatus, 'Verification Status', Icons.verified, Colors.amber),
        _quickAction(context, RouteName.maintenanceList, 'Maintenance', Icons.build, Theme.of(context).colorScheme.error),
      ])),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Apps'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
      ], onTap: (i) => switch (i) { 0 => context.go(RouteName.dashboard), 1 => context.push(RouteName.propertyListing), 2 => context.push(RouteName.myApplications), 3 => context.push(RouteName.profile), _ => null }),
    );
  }
  Widget _quickAction(BuildContext ctx, String route, String label, IconData icon, Color color) {
    return ListTile(leading: Icon(icon, color: color), title: Text(label), trailing: const Icon(Icons.chevron_right), onTap: () => ctx.push(route));
  }
}