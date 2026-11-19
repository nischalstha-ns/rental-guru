
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplicationFormScreen extends ConsumerStatefulWidget {
  const ApplicationFormScreen({super.key});
  @override
  ConsumerState<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}
class _ApplicationFormScreenState extends ConsumerState<ApplicationFormScreen> {
  final _form = GlobalKey<FormState>();
  final _msgCtrl = TextEditingController();
  DateTime? _moveInDate;
  bool _loading = false;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    // Application submission logic here
    if (mounted) context.pop();
    setState(() => _loading = false);
  }

  @override
  void dispose() { _msgCtrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(appBar: AppBar(title: const Text('Rental Application')), body: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: Form(key: _form, child: Column(children: [
      TextFormField(decoration: const InputDecoration(labelText: 'Message to Landlord'), maxLines: 3, controller: _msgCtrl, validator: (v) => (v == null || v.length < 10) ? 'Please add a message (min 10 chars)' : null),
      const SizedBox(height: 16),
      InputDecorator(decoration: const InputDecoration(labelText: 'Preferred Move-in Date'), child: InkWell(onTap: () async { final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365))); if (d != null) setState(() => _moveInDate = d); }, child: Text(_moveInDate == null ? 'Select date' : _moveInDate!.toLocal().toString().split(' ')[0]))),
      const Spacer(),
      if (_loading) const Center(child: CircularProgressIndicator()),
      FilledButton(onPressed: _loading ? null : _submit, child: const Text('Submit Application')),
    ])))));
  }
}
