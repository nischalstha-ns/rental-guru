
import 'package:flutter/material.dart';

class VerificationQueueScreen extends StatelessWidget {
  const VerificationQueueScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Verification Queue')), body: const Center(child: Text('Pending verifications - admin review')));
}
