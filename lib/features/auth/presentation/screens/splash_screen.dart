import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../domain/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  @override
  void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2)); _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn); _controller.forward(); _navigate(); }
  Future<void> _navigate() async { await Future.delayed(const Duration(milliseconds: 1800)); if (!mounted) return; final state = await ref.read(authStateProvider.future); if (!mounted) return; if (state.user != null && state.accountStatus != 'suspended') context.go(RouteName.dashboard); else context.go(RouteName.login); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: FadeTransition(opacity: _fade, child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.home_rounded, size: 80, color: Theme.of(context).colorScheme.primary),
      const SizedBox(height: 16), Text('Rent Guru', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
    ]))),
    );
  }
}