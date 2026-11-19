import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _errorMsg;

  @override
  void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  Future<void> _handleLogin() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _loading = true; _errorMsg = null; });
    final result = await ref.read(authRepositoryProvider).signIn(_emailCtrl.text.trim(), _passCtrl.text);
    result.fold(
      (l) => setState(() => _errorMsg = l.toString()),
      (_) async {
        final state = await ref.read(authStateProvider.future);
        if (!mounted) return;
        switch (state.accountStatus) {
          case 'suspended': context.go(RouteName.accountStatus); break;
          default: context.go(RouteName.dashboard);
        }
      },
    );
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.home_rounded, size: 72, color: theme.colorScheme.primary),
        const SizedBox(height: 8), Text('Rent Guru', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8), Text('Your trusted rental platform', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 48),
        if (_errorMsg != null) Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)),
          child: Text(_errorMsg!, style: theme.textTheme.bodySmall)),
        Form(key: _form, child: Column(children: [
          TextFormField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)), validator: Validators.email),
          const SizedBox(height: 16),
          TextFormField(controller: _passCtrl, obscureText: _obscure,
            decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure))),
            validator: Validators.password),
        ])),
        const SizedBox(height: 8),
        Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => context.push(RouteName.forgotPassword), child: const Text('Forgot Password?'))),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _loading ? null : _handleLogin,
          child: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Sign In'))),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Don't have an account? "),
          TextButton(onPressed: () => context.push(RouteName.register), child: const Text('Sign Up')),
        ]),
      ]))),
    );
  }
}