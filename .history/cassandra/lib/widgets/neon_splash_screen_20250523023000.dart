import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NeonSplashScreen extends StatefulWidget {
  final VoidCallback onContinue;
  const NeonSplashScreen({required this.onContinue, super.key});

  @override
  State<NeonSplashScreen> createState() => _NeonSplashScreenState();
}

class _NeonSplashScreenState extends State<NeonSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScaleAnim;
  late AnimationController _bgController;
  late Animation<double> _gradientAnim;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _logoScaleAnim = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _gradientAnim = Tween<double>(begin: 0, end: 1).animate(_bgController);
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _showButton = true);
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Animated neon gradient background
          AnimatedBuilder(
            animation: _gradientAnim,
            builder: (context, child) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _NeonGradientPainter(_gradientAnim.value),
              );
            },
          ),
          // Particle shimmer
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _bgController,
                builder: (context, child) => CustomPaint(
                  painter: _NeonParticlePainter(_bgController.value),
                ),
              ),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoScaleAnim,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.tertiary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.22),
                          blurRadius: 32,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Center(
                          child: Icon(
                            Icons.auto_awesome,
                            size: 60,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: theme.colorScheme.tertiary.withOpacity(0.7),
                                blurRadius: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                // Neon glowing app name
                ShaderMask(
                  shaderCallback: (rect) => LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.tertiary,
                      theme.colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(rect),
                  child: Text(
                    'Cassandra',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.3,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: theme.colorScheme.tertiary.withOpacity(0.7),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                  ).animate().shimmer(
                        color: theme.colorScheme.tertiary,
                        duration: 1200.ms,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Predict the Future',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.1,
                  ),
                ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
                const SizedBox(height: 48),
                if (_showButton)
                  _NeonGlassButton(
                    text: 'Get Started',
                    onPressed: widget.onContinue,
                    color: theme.colorScheme.primary,
                  ).animate().fadeIn(duration: 600.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Animated neon gradient painter
class _NeonGradientPainter extends CustomPainter {
  final double t;
  _NeonGradientPainter(this.t);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      colors: [
        Color.lerp(const Color(0xFF9B5CFF), const Color(0xFFFF2DCA), t)!,
        Color.lerp(const Color(0xFF00FFF7), const Color(0xFF9B5CFF), t)!,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant _NeonGradientPainter old) => old.t != t;
}

// Particle shimmer painter
class _NeonParticlePainter extends CustomPainter {
  final double t;
  _NeonParticlePainter(this.t);
  final int count = 22;
  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(42);
    for (int i = 0; i < count; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = (size.height * (1 - ((t + i / count) % 1.0)));
      final radius = 2.0 + rnd.nextDouble() * 3.0;
      final color = [
        const Color(0xFF9B5CFF),
        const Color(0xFFFF2DCA),
        const Color(0xFF00FFF7),
      ][i % 3].withOpacity(0.18 + 0.18 * rnd.nextDouble());
      canvas.drawCircle(Offset(x, y), radius, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _NeonParticlePainter old) => old.t != t;
}

// Glassmorphism neon button
class _NeonGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  const _NeonGlassButton({required this.text, required this.onPressed, required this.color});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
        decoration: BoxDecoration(
          color: color.withOpacity(0.18),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
          backgroundBlendMode: BlendMode.screen,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.1,
              ),
        ),
      ),
    );
  }
} 