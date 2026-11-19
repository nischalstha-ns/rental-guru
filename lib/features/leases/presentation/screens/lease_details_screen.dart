
import 'package:flutter/material.dart';

class LeaseDetailsScreen extends StatelessWidget {
  final String id;
  const LeaseDetailsScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Lease Details')), body: const Center(child: Text('Lease details view')));
}
