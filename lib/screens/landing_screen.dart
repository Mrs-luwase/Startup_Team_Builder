import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/logo_mark.dart';

class LandingScreen extends StatefulWidget {
  final VoidCallback onStart;
  const LandingScreen({super.key, required this.onStart});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  // _intro plays once when the screen opens; _bounce loops the arrows.
  late final AnimationController _intro;
  late final AnimationController _bounce;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
    _bounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _intro.dispose();
    _bounce.dispose();
    super.dispose();
  }

  // A slice of the intro animation, from `begin` to `end` (0.0 to 1.0).
  Animation<double> _step(double begin, double end,
      [Curve curve = Curves.easeOutCubic]) {
    return CurvedAnimation(parent: _intro, curve: Interval(begin, end, curve: curve));
  }

  Widget _fadeUp(Animation<double> a, Widget child) {
    return FadeTransition(
      opacity: a,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(a),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final photoZoom = _step(0, 1);
    final logoFade = _step(0.0, 0.25);
    final logoMove = _step(0.25, 0.7, Curves.easeInOutCubic);
    final textIn = _step(0.6, 0.9);
    final buttonIn = _step(0.75, 1.0);

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        // Swipe up (fast upward drag) = continue.
        onVerticalDragEnd: (d) {
          if ((d.primaryVelocity ?? 0) < -300) widget.onStart();
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Photo with a slow zoom-out.
            AnimatedBuilder(
              animation: _intro,
              builder: (context, child) => Transform.scale(
                scale: 1.1 - 0.1 * photoZoom.value,
                child: child,
              ),
              child: Image.asset(
                'assets/images/landing.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.green, Color(0xFF0E3A23)],
                    ),
                  ),
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xE6000000)],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Logo: starts big and higher up, settles smaller in place.
                    AnimatedBuilder(
                      animation: _intro,
                      builder: (context, child) {
                        final m = logoMove.value;
                        return Opacity(
                          opacity: logoFade.value,
                          child: Transform.translate(
                            offset: Offset(0, -(1 - m) * h * 0.15),
                            child: Transform.scale(
                              scale: 1.8 - 0.8 * m,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: const LogoMark(size: 64),
                    ),
                    const SizedBox(height: 16),
                    _fadeUp(
                      textIn,
                      const Text(
                        'Build something\ngreat. Together.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _fadeUp(
                      buttonIn,
                      FilledButton(
                        onPressed: widget.onStart,
                        child: const Text('Get started'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Bouncing arrows: tap them, or swipe up anywhere.
                    _fadeUp(
                      buttonIn,
                      GestureDetector(
                        onTap: widget.onStart,
                        child: AnimatedBuilder(
                          animation: _bounce,
                          builder: (context, child) => Transform.translate(
                            offset: Offset(0, -8 * _bounce.value),
                            child: child,
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.keyboard_double_arrow_up,
                                  color: Colors.white70, size: 28),
                              Text('Swipe up',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}