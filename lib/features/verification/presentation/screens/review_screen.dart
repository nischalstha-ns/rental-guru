
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';

class ReviewSubmissionScreen extends StatelessWidget {
  const ReviewSubmissionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Review Submission')),
      body: const Center(child: Text('Review your uploaded documents before submitting.')));
  }
}
