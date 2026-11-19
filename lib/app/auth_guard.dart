
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router/route_names.dart';

class RoleGuard extends StatelessWidget {
  final String requiredRole;
  final Widget child;
  const RoleGuard({super.key, required this.requiredRole, required this.child});
  @override
  Widget build(BuildContext context) {
    // Role guard logic would check auth state and redirect if role doesn't match
    return child;
  }
}
