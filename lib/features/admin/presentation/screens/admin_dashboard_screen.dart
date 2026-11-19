
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(appBar: AppBar(title: const Text('Admin Dashboard')), body: ListView(padding: const EdgeInsets.all(16), children: [
      _card(theme, context, 'Users', Icons.people, RouteName.userManagement),
      _card(theme, context, 'Verification Queue', Icons.verified_user, RouteName.verificationQueue),
      _card(theme, context, 'Property Approvals', Icons.home, RouteName.propertyApprovalQueue),
      _card(theme, context, 'Audit Logs', Icons.archive, RouteName.auditLogViewer),
      _card(theme, context, 'Suspended Accounts', Icons.block, RouteName.suspendedAccounts),
    ]));
  }
  Widget _card(ThemeData t, BuildContext ctx, String title, IconData icon, String route) => Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(leading: Icon(icon, color: t.colorScheme.primary), title: Text(title), trailing: const Icon(Icons.chevron_right), onTap: () => ctx.push(route)));
}
