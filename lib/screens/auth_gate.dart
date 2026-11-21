import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/auth_state.dart';
import '../widgets/logo_mark.dart';
import 'home_screen.dart';
import 'landing_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    final Widget page;
    if (auth.checking) {
      page = const _Splash(key: ValueKey('splash'));
    } else if (auth.user != null) {
      page = const HomeScreen(key: ValueKey('home'));
    } else if (!_started) {
      page = LandingScreen(
        key: const ValueKey('landing'),
        onStart: () => setState(() => _started = true),
      );
    } else {
      page = LoginScreen(
        key: const ValueKey('login'),
        onBack: () => setState(() => _started = false),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: page,
    );
  }
}

/// Shown for a moment while the app checks who is signed in.
class _Splash extends StatelessWidget {
  const _Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.6, end: 1),
          duration: const Duration(milliseconds: 700),
          curve: Curves.elasticOut,
          builder: (context, scale, child) =>
              Transform.scale(scale: scale, child: child),
          child: const LogoMark(size: 96),
        ),
      ),
    );
  }
}