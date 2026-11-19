import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../../../properties/domain/providers/property_provider.dart';
import '../../data/models/property_model.dart';

class EditPropertyScreen extends ConsumerStatefulWidget {
  final PropertyModel property;
  const EditPropertyScreen({super.key, required this.property});
  @override
  ConsumerState<EditPropertyScreen> createState() => _EditPropertyScreenState();
}
class _EditPropertyScreenState extends ConsumerState<EditPropertyScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _addressCtrl;
  final _form = GlobalKey<FormState>();
  bool _loading = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.property.title ?? '');
    _addressCtrl = TextEditingController(text: widget.property.addressLine ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _loading = true; _errorMsg = null; });
    final repository = ref.read(propertyRepositoryProvider);
    final updated = widget.property.copyWith(
      title: _nameCtrl.text.trim(),
      addressLine: _addressCtrl.text.trim(),
    );
    final result = await repository.update(widget.property.id, updated);
    result.fold((l) => setState(() => _errorMsg = l.toString()), (_) => Navigator.pop(context));
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Property'),
        actions: [
          TextButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save'),
          ),
        ],
      ),
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
            ]),
          ),
        ),
      ),
    );
  }
}