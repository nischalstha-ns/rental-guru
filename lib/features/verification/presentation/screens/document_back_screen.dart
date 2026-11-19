
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DocumentBackScreen extends StatelessWidget {
  const DocumentBackScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Upload Document Back')), body: const Center(child: Text('Document Back - Same flow as Front')));
  }
}
