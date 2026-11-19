import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';

class LandlordDashboardScreen extends StatelessWidget {
  const LandlordDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Landlord Dashboard')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _action(context, 'My Properties', Icons.home, RouteName.myProperties),
        _action(context, 'Add Property', Icons.add_circle, RouteName.addProperty),
        _action(context, 'Applications', Icons.assignment, RouteName.tenantList),
        _action(context, 'Leases', Icons.description, RouteName.leaseManagement),
        _action(context, 'Payments', Icons.attach_money, RouteName.paymentTracking),
        _action(context, 'Maintenance', Icons.build, RouteName.maintenanceManagement),
      ]),
    );
  }
  Widget _action(BuildContext ctx, String label, IconData icon, String route) {
    return ListTile(leading: Icon(icon), title: Text(label), trailing: const Icon(Icons.chevron_right), onTap: () => ctx.push(route));
  }
}