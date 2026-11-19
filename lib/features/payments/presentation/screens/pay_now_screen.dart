import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../payments/domain/providers/payment_provider.dart';

class PayNowScreen extends ConsumerStatefulWidget {
  final String leaseId;
  const PayNowScreen({super.key, required this.leaseId});
  @override
  ConsumerState<PayNowScreen> createState() => _PayNowScreenState();
}
class _PayNowScreenState extends ConsumerState<PayNowScreen> {
  bool _loading = false;
  String? _error;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(appBar: AppBar(title: const Text('Pay Rent')), body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (_error != null) Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)), child: Text(_error!)),
      const Text('Confirm your payment details below.', style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
      const SizedBox(height: 24),
      FilledButton.icon(onPressed: _loading ? null : () async {
        setState(() { _loading = true; _error = null; });
        final result = await ref.read(paymentRepositoryProvider).makePayment(leaseId: widget.leaseId, amount: 0, note: '');
        result.fold((l) => setState(() => _error = l.toString()), (_) => context.pop());
        setState(() => _loading = false);
      }, icon: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.payment), label: const Text('Confirm Payment')),
    ]))));
  }
}