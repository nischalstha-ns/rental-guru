import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';

class ManagerDashboardScreen extends StatelessWidget {
  const ManagerDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manager Dashboard')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _action(context, 'All Properties', Icons.home, RouteName.propertyListing),
        _action(context, 'Applications', Icons.assignment, RouteName.tenantList),
        _action(context, 'Verifications', Icons.verified_user, RouteName.verificationStatus),
        _action(context, 'Maintenance', Icons.build, RouteName.maintenanceManagement),
        _action(context, 'Payments', Icons.attach_money, RouteName.paymentTracking),
      ]),
    );
  }
  Widget _action(BuildContext ctx, String label, IconData icon, String route) {
    return ListTile(leading: Icon(icon), title: Text(label), trailing: const Icon(Icons.chevron_right), onTap: () => ctx.push(route));
  }
}