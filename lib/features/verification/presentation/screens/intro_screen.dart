import 'package:flutter/material.dart';

class VerificationIntroScreen extends StatelessWidget {
  const VerificationIntroScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Identity Verification')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user, size: 72, color: theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text('Identity Verification', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(
                'We need to verify your identity to ensure a safe rental marketplace. Your documents are stored securely and only reviewed by authorized personnel.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              _infoRow(theme, Icons.shield, 'Your data is encrypted'),
              _infoRow(theme, Icons.visibility_off, 'Only admins can review documents'),
              _infoRow(theme, Icons.delete_outline, 'You can request deletion anytime'),
              const Spacer(),
              FilledButton(onPressed: () {}, child: const Text('Continue')),
              const SizedBox(height: 12),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Skip for now')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(ThemeData t, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Icon(icon, size: 20, color: t.colorScheme.primary),
        const SizedBox(width: 12),
        Text(text, style: t.textTheme.bodyMedium),
      ]),
    );
  }
}