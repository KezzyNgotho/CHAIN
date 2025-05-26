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
      backgroundColor: const Color(0xFF0A0A12),
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _gradientAnim,
            builder: (context, child) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _GradientPainter(_gradientAnim.value),
              );
            },
          ),
          // Subtle particle effect
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _bgController,
                builder: (context, child) => CustomPaint(
                  painter: _ParticlePainter(_bgController.value),
                ),
              ),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.9),
                        theme.colorScheme.secondary.withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.8),
                          theme.colorScheme.secondary.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.flash_on,
                        size: 48,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: theme.colorScheme.tertiary.withOpacity(0.7),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Neon glowing app name
                ShaderMask(
                  shaderCallback: (rect) => LinearGradient(
                    colors: [
                      const Color(0xFF6366F1), // Indigo
                      const Color(0xFF3B82F6), // Blue
                      const Color(0xFF2563EB), // Deep Blue
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(rect),
                  child: Text(
                    'Cassandra',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: theme.colorScheme.tertiary.withOpacity(0.7),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ).animate().shimmer(
                        color: theme.colorScheme.tertiary,
                        duration: 1200.ms,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Predict the Future',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.8,
                  ),
                ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
                const SizedBox(height: 32),
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
class _GradientPainter extends CustomPainter {
  final double t;
  _GradientPainter(this.t);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      colors: [
        Color.lerp(const Color(0xFF1A1A2E), const Color(0xFF16213E), t)!,
        Color.lerp(const Color(0xFF1E2D51), const Color(0xFF1A1A2E), t)!,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _GradientPainter old) => old.t != t;
}

// Particle shimmer painter
class _ParticlePainter extends CustomPainter {
  final double t;
  _ParticlePainter(this.t);
  final int count = 22;
  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(42);
    for (int i = 0; i < count; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = (size.height * (1 - ((t + i / count) % 1.0)));
      final radius = 2.0 + rnd.nextDouble() * 3.0;
      final color = const Color(0xFF1E2D51).withOpacity(0.18 + 0.18 * rnd.nextDouble());
      canvas.drawCircle(Offset(x, y), radius, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.t != t;
}

// Glassmorphism neon button
class _NeonGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  const _NeonGlassButton({required this.text, required this.onPressed, required this.color, super.key});
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