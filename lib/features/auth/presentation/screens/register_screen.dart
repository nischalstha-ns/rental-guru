import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  String? _errorMsg;
  String _selectedRole = 'tenant';
  bool _termsAccepted = false;
  final roles = ['tenant', 'landlord', 'property_manager'];

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _passCtrl.dispose(); _confirmCtrl.dispose(); super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_form.currentState!.validate()) return;
    if (!_termsAccepted) { setState(() => _errorMsg = 'Please accept the terms and privacy policy.'); return; }
    setState(() { _loading = true; _errorMsg = null; });
    final result = await ref.read(authRepositoryProvider).signUp(
      fullName: _nameCtrl.text.trim(), email: _emailCtrl.text.trim(), phone: _phoneCtrl.text.trim(),
      password: _passCtrl.text, confirmPassword: _confirmCtrl.text, role: _selectedRole);
    result.fold(
      (l) => setState(() => _errorMsg = l.toString()),
      (_) => context.go(RouteName.dashboard),
    );
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account'), leading: BackButton()),
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(key: _form, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (_errorMsg != null)
            Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)),
              child: Text(_errorMsg!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onErrorContainer))),
          TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)), validator: Validators.fullName),
          const SizedBox(height: 16),
          TextFormField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)), validator: Validators.email),
          const SizedBox(height: 16),
          TextFormField(controller: _phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined)), validator: Validators.phone),
          const SizedBox(height: 16),
          TextFormField(controller: _passCtrl, obscureText: _obscure, decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure))), validator: Validators.password),
          const SizedBox(height: 16),
          TextFormField(controller: _confirmCtrl, obscureText: _obscureConfirm, decoration: InputDecoration(labelText: 'Confirm Password', prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton(icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm))), validator: (v) => v != _passCtrl.text ? 'Passwords do not match' : null),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(value: _selectedRole, decoration: const InputDecoration(labelText: 'Role'), items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r.replaceAll('_', ' ').capitalize()))).toList(), onChanged: (v) => setState(() => _selectedRole = v!)),
          const SizedBox(height: 16),
          Row(children: [Checkbox(value: _termsAccepted, onChanged: (v) => setState(() => _termsAccepted = v ?? false)), Expanded(child: Text('I agree to the Terms of Service and Privacy Policy', style: theme.textTheme.bodySmall))]),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _loading ? null : _handleRegister, child: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Create Account')),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Already have an account? '), TextButton(onPressed: () => context.pop(), child: const Text('Sign In'))]),
        ]))),
    ));
  }
}
extension on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
}