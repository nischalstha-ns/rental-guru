
import os
BASE = 'lib'
def wf(path, content):
    full = os.path.join(BASE, path)
    os.makedirs(os.path.dirname(full), exist_ok=True)
    with open(full, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f'  OK  {path}')
print('Starting build...')
print('\n=== AUTH ===')

wf('features/auth/data/models/auth_response.dart', '''class AuthResponse {
  final bool success;
  final String? errorMessage;
  const AuthResponse({required this.success, this.errorMessage});
  factory AuthResponse.ok() => const AuthResponse(success: true);
  factory AuthResponse.fail(String msg) => AuthResponse(success: false, errorMessage: msg);
}
''')

wf('features/auth/domain/repositories/auth_repository.dart', r'''
import '../../../../core/errors/failure.dart';
abstract class AuthRepository {
  Future<Result<void, Failure>> signIn(String email, String password);
  Future<Result<void, Failure>> signUp({
    required String fullName, required String email, required String phone,
    required String password, required String confirmPassword, required String role,
  });
  Future<void> signOut();
  Future<Result<void, Failure>> sendPasswordResetEmail(String email);
  Future<Result<void, Failure>> updatePassword(String newPassword);
  Future<Result<Map<String, dynamic>, Failure>> getCurrentProfile();
}
''')

wf('features/auth/presentation/screens/login_screen.dart', r'''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
  String? _error;

  @override
  void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  Future<void> _handleLogin() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final result = await ref.read(authRepositoryProvider).signIn(_emailCtrl.text.trim(), _passCtrl.text);
    result.fold((l) => setState(() => _error = l.message), (_) => context.go(RouteName.dashboard));
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(24.0), child: Column(
        mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.home_rounded, size: 72, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text('Rent Guru', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
          Text('Smart Rental Management', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
          const SizedBox(height: 40),
          if (_error != null) Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)),
            child: Text(_error!, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onErrorContainer))),
          Form(key: _form, child: Column(children: [
            TextFormField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)), validator: Validators.email),
            const SizedBox(height: 16),
            TextFormField(controller: _passCtrl, obscureText: _obscure,
              decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure))),
              validator: Validators.password),
          ])),
          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => context.push(RouteName.forgotPassword), child: const Text('Forgot Password?'))),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
            onPressed: _loading ? null : _handleLogin,
            child: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Sign In', style: TextStyle(fontSize: 16)),
          )),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('No account? '), TextButton(onPressed: () => context.push(RouteName.register), child: const Text('Sign Up')),
          ]),
        ]),
      ))),
    );
  }
}
''')

print('Auth login done')

# ============================================================
# AUTH FEATURE
# ============================================================
print('\n=== AUTH ===')

wf('features/auth/data/models/auth_response.dart', '''class AuthResponse {
  final bool success;
  final String? errorMessage;
  const AuthResponse({required this.success, this.errorMessage});
  factory AuthResponse.ok() => const AuthResponse(success: true);
  factory AuthResponse.fail(String msg) => AuthResponse(success: false, errorMessage: msg);
}
''')

wf('features/auth/domain/repositories/auth_repository.dart', r'''
import '../../../../core/errors/failure.dart';

abstract class AuthRepository {
  Future<Result<void, Failure>> signIn(String email, String password);
  Future<Result<void, Failure>> signUp({
    required String fullName, required String email, required String phone,
    required String password, required String confirmPassword, required String role,
  });
  Future<void> signOut();
  Future<Result<void, Failure>> sendPasswordResetEmail(String email);
  Future<Result<void, Failure>> updatePassword(String newPassword);
  Future<Result<Map<String, dynamic>, Failure>> getCurrentProfile();
}
''')

wf('features/auth/presentation/screens/login_screen.dart', r'''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/providers/auth_provider.dart';

part 'login_screen.g.dart';

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
  String? _error;

  @override
  void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  Future<void> _handleLogin() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final result = await ref.read(authRepositoryProvider).signIn(_emailCtrl.text.trim(), _passCtrl.text);
    result.fold(
      (l) => setState(() => _error = l.message),
      (_) => context.go(RouteName.dashboard),
    );
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.home_rounded, size: 72, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text('Rent Guru', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Smart Rental Management', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
          const SizedBox(height: 40),
          if (_error != null) Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)),
            child: Text(_error!, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onErrorContainer)),
          ),
          Form(key: _form, child: Column(children: [
            TextFormField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
              validator: Validators.email),
            const SizedBox(height: 16),
            TextFormField(controller: _passCtrl, obscureText: _obscure,
              decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure))),
              validator: Validators.password),
          ])),
          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => context.push(RouteName.forgotPassword), child: const Text('Forgot Password?'))),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
            onPressed: _loading ? null : _handleLogin,
            child: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Sign In', style: TextStyle(fontSize: 16)),
          )),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('Don\'t have an account? '),
            TextButton(onPressed: () => context.push(RouteName.register), child: const Text('Sign Up')),
          ]),
        ]),
      )));
  }
}
''')

print('Auth part 1 done')
'''
with open('build_all.py', 'a', encoding='utf-8') as f:
    f.write(script)
print('Script appended')
"

