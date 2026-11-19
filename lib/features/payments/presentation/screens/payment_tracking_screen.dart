import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../payments/domain/providers/payment_provider.dart';

class PaymentTrackingScreen extends ConsumerWidget {
  const PaymentTrackingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payments = ref.watch(paymentListProvider);
    return Scaffold(appBar: AppBar(title: const Text('Payments')), body: payments.when(data: (d) => RefreshIndicator(onRefresh: () async => ref.refresh(paymentListProvider), child: ListView.builder(padding: const EdgeInsets.all(8), itemCount: d.length, itemBuilder: (_, i) => PaymentCard(payment: d[i]))), loading: () => const Center(child: CircularProgressIndicator()), error: (e, _) => Center(child: Text('Error: $e'))));
  }
}
class PaymentCard extends StatelessWidget {
  final dynamic payment;
  const PaymentCard({super.key, required this.payment});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPaid = payment.status == AppConstants.paymentStatusPaid;
    return Card(margin: const EdgeInsets.all(8), child: ListTile(title: Text('\$${payment.amount?.toStringAsFixed(2) ?? '0.00'}'), subtitle: Text('${payment.dueDate?.toString().split(" ").first ?? ""} | ${payment.type?.capitalize()}'), trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: isPaid ? Colors.green[100] : Colors.red[100], borderRadius: BorderRadius.circular(12)), child: Text((isPaid ? 'Paid' : 'Overdue').capitalize(), style: TextStyle(color: isPaid ? Colors.green[900] : Colors.red[900], fontSize: 12)))));
  }
}
extension on String { String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1); }