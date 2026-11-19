import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../domain/providers/auth_provider.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}
class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;
  bool _success = false;

  @override void dispose() { _passCtrl.dispose(); _confirmCtrl.dispose(); super.dispose(); }

  Future<void> _handleSubmit() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final result = await ref.read(authRepositoryProvider).updatePassword(_passCtrl.text);
    result.fold(
      (l) => setState(() => _error = l.toString()),
      (_) => setState(() => _success = true),
    );
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('New Password'), leading: BackButton()),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: _success ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.check_circle, size: 64, color: theme.colorScheme.primary),
        const SizedBox(height: 16), Text('Password updated!', style: theme.textTheme.titleLarge),
        const SizedBox(height: 32), SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => context.go(RouteName.login), child: const Text('Sign In'))),
      ]) : Form(key: _form, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (_error != null) Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)),
          child: Text(_error!, style: theme.textTheme.bodySmall)),
        TextFormField(controller: _passCtrl, obscureText: _obscure, decoration: InputDecoration(labelText: 'New Password', prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure))), validator: (v) => (v == null || v.length < 8) ? 'Min 8 characters' : null),
        const SizedBox(height: 16),
        TextFormField(controller: _confirmCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm New Password', prefixIcon: Icon(Icons.lock_outline)),
          validator: (v) => v != _passCtrl.text ? 'Passwords do not match' : null),
        const SizedBox(height: 32),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _loading ? null : _handleSubmit,
          child: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Update Password'))),
      ]))),
    ));
  }
}