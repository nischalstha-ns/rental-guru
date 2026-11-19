import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../../../properties/domain/providers/property_provider.dart';
import '../../data/models/property_model.dart';

class AddPropertyScreen extends ConsumerStatefulWidget {
  const AddPropertyScreen({super.key});
  @override
  ConsumerState<AddPropertyScreen> createState() => _AddPropertyScreenState();
}
class _AddPropertyScreenState extends ConsumerState<AddPropertyScreen> {
  final _form = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _loading = false;
  String? _errorMsg;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _loading = true; _errorMsg = null; });
    final result = await ref.read(propertyRepositoryProvider).create(
      PropertyModel(
        id: '', landlordId: 'fake-landlord', title: _nameCtrl.text.trim(), addressLine: _addressCtrl.text.trim(),
        monthlyRent: 0, securityDeposit: 0, availabilityStatus: 'available', verificationStatus: 'pending',
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      ),
    );
    result.fold((l) => setState(() => _errorMsg = l.toString()), (_) => context.pop());
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Property')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _form,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              if (_errorMsg != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)),
                  child: Text(_errorMsg!),
                ),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Property Name', prefixIcon: Icon(Icons.home_outlined)),
                validator: Validators.nonEmpty,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressCtrl,
                decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.location_on_outlined)),
                validator: Validators.nonEmpty,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Add Property'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}