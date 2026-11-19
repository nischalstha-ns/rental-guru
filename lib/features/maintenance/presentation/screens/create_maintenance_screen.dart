import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../maintenance/domain/providers/maintenance_provider.dart';

class CreateMaintenanceScreen extends ConsumerStatefulWidget {
  const CreateMaintenanceScreen({super.key});
  @override
  ConsumerState<CreateMaintenanceScreen> createState() => _CreateMaintenanceScreenState();
}
class _CreateMaintenanceScreenState extends ConsumerState<CreateMaintenanceScreen> {
  final _form = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  String _selectedPriority = 'medium';
  @override void dispose() { _descCtrl.dispose(); super.dispose(); }
  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final result = await ref.read(maintenanceRepositoryProvider).create(description: _descCtrl.text.trim(), priority: _selectedPriority);
    result.fold((l) => setState(() => _error = l.toString()), (_) => Navigator.pop(context));
    setState(() => _loading = false);
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(appBar: AppBar(title: const Text('New Request')), body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Form(key: _form, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (_error != null) Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)), child: Text(_error!)),
      DropdownButtonFormField<String>(initialValue: _selectedPriority, decoration: const InputDecoration(labelText: 'Priority'), items: [AppConstants.maintenancePriorityLow, AppConstants.maintenancePriorityMedium, AppConstants.maintenancePriorityHigh, AppConstants.maintenancePriorityEmergency].map((p) => DropdownMenuItem(value: p, child: Text(p.capitalize()))).toList(), onChanged: (v) => setState(() => _selectedPriority = v!)),
      const SizedBox(height: 16),
      TextFormField(controller: _descCtrl, maxLines: 5, decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true), validator: Validators.nonEmpty),
      const SizedBox(height: 24),
      ElevatedButton(onPressed: _loading ? null : _submit, child: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Submit')),
    ])))));
  }
}
extension on String { String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1); }