import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}
class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;
  String? _errorMsg;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _loading = true; _errorMsg = null; });
    final result = await ref.read(authRepositoryProvider).sendPasswordResetEmail(_emailCtrl.text.trim());
    result.fold(
      (l) => setState(() => _errorMsg = l.toString()),
      (_) => setState(() => _sent = true),
    );
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password'), leading: BackButton()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_sent) ...[
                Icon(Icons.lock_reset, size: 64, color: theme.colorScheme.primary),
                const SizedBox(height: 24),
                Text('Enter your email to receive a reset link', textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 32),
                if (_errorMsg != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)),
                    child: Text(_errorMsg!, style: theme.textTheme.bodySmall),
                  ),
                Form(
                  key: _form,
                  child: TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                    validator: Validators.email,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _handleSubmit,
                    child: _loading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Send Reset Link'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(onPressed: () => context.pop(), child: const Text('Back to Sign In')),
              ] else ...[
                Icon(Icons.check_circle, size: 64, color: theme.colorScheme.primary),
                const SizedBox(height: 24),
                Text('Check your email', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('We sent a password reset link to your email.', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => context.go(RouteName.login),
                    child: const Text('Back to Sign In'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(onPressed: () => setState(() => _sent = false), child: const Text("Didn't receive? Try again")),
              ],
            ],
          ),
        ),
      ),
    );
  }
}