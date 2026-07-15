import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A mesmerizing AI-thinking indicator with orbital dots that pulse,
/// orbit, and trail around a glowing centre — giving the feeling of
/// an intelligent system deep in thought.
///
/// Drop it anywhere a loading / "AI is working" state is needed:
/// ```dart
/// const AiThinkingIndicator();
/// AiThinkingIndicator(size: 64, label: 'Analysing your meal…');
/// ```
class AiThinkingIndicator extends StatefulWidget {
  /// Overall diameter of the widget (dots orbit within this box).
  final double size;

  /// Optional label shown beneath the animation.
  final String? label;

  /// Base colour for the dots. Defaults to [KaloriColors.primary].
  final Color? color;

  const AiThinkingIndicator({
    super.key,
    this.size = 48,
    this.label,
    this.color,
  });

  @override
  State<AiThinkingIndicator> createState() => _AiThinkingIndicatorState();
}

class _AiThinkingIndicatorState extends State<AiThinkingIndicator>
    with TickerProviderStateMixin {
  late final AnimationController _orbitController;
  late final AnimationController _pulseController;
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();

    // Main orbit rotation — smooth infinite spin.
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    // Per-dot scale pulse — gives a breathing feel.
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Central glow pulse — slower, dreamier.
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.color ?? KaloriColors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _orbitController,
              _pulseController,
              _glowController,
            ]),
            builder: (context, _) {
              return CustomPaint(
                painter: _ThinkingPainter(
                  orbitProgress: _orbitController.value,
                  pulseProgress: _pulseController.value,
                  glowProgress: _glowController.value,
                  baseColor: baseColor,
                ),
              );
            },
          ),
        ),
        if (widget.label != null) ...[
          const SizedBox(height: 12),
          _AnimatedLabel(
            label: widget.label!,
            color: baseColor,
            pulseAnimation: _pulseController,
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Custom painter — draws the orbital dots, trails, and central glow.
// ---------------------------------------------------------------------------
class _ThinkingPainter extends CustomPainter {
  final double orbitProgress;
  final double pulseProgress;
  final double glowProgress;
  final Color baseColor;

  static const int _dotCount = 3;

  _ThinkingPainter({
    required this.orbitProgress,
    required this.pulseProgress,
    required this.glowProgress,
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centre = Offset(size.width / 2, size.height / 2);
    final orbitRadius = size.width * 0.32;
    final maxDotRadius = size.width * 0.08;

    // ── Central glow ──────────────────────────────────────────────
    final glowRadius = size.width * 0.14 + (glowProgress * size.width * 0.04);
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          baseColor.withValues(alpha: 0.35 + glowProgress * 0.15),
          baseColor.withValues(alpha: 0.0),
        ],
      ).createShader(
        Rect.fromCircle(center: centre, radius: glowRadius * 2),
      );
    canvas.drawCircle(centre, glowRadius * 2, glowPaint);

    // Solid core dot
    final corePaint = Paint()..color = baseColor.withValues(alpha: 0.6 + glowProgress * 0.25);
    canvas.drawCircle(centre, glowRadius * 0.45, corePaint);

    // ── Orbiting dots with trails ─────────────────────────────────
    for (int i = 0; i < _dotCount; i++) {
      final phaseOffset = (i / _dotCount); // evenly spaced
      final angle = (orbitProgress + phaseOffset) * 2 * math.pi;

      // Stagger the pulse per dot so they breathe independently.
      final dotPulse =
          math.sin((pulseProgress + phaseOffset) * math.pi).abs();
      final dotRadius = maxDotRadius * (0.6 + 0.4 * dotPulse);

      final dx = centre.dx + orbitRadius * math.cos(angle);
      final dy = centre.dy + orbitRadius * math.sin(angle);

      // Trail — a series of fading ghost dots behind the main one.
      const trailCount = 5;
      for (int t = trailCount; t >= 1; t--) {
        final trailAngle = angle - (t * 0.12);
        final trailDx = centre.dx + orbitRadius * math.cos(trailAngle);
        final trailDy = centre.dy + orbitRadius * math.sin(trailAngle);
        final trailOpacity = (1.0 - t / (trailCount + 1)) * 0.35;
        final trailRadius = dotRadius * (1.0 - t * 0.12);

        final trailPaint = Paint()
          ..color = _dotColor(i).withValues(alpha: trailOpacity);
        canvas.drawCircle(Offset(trailDx, trailDy), trailRadius, trailPaint);
      }

      // Main dot with a subtle outer glow.
      final dotGlowPaint = Paint()
        ..color = _dotColor(i).withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(dx, dy), dotRadius * 1.6, dotGlowPaint);

      final dotPaint = Paint()..color = _dotColor(i);
      canvas.drawCircle(Offset(dx, dy), dotRadius, dotPaint);
    }
  }

  /// Each dot gets a slightly different hue shift for visual richness.
  Color _dotColor(int index) {
    final hsl = HSLColor.fromColor(baseColor);
    final hueShift = index * 25.0; // subtle rotation per dot
    return hsl
        .withHue((hsl.hue + hueShift) % 360)
        .withLightness((hsl.lightness + 0.1).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  bool shouldRepaint(covariant _ThinkingPainter oldDelegate) => true;
}

// ---------------------------------------------------------------------------
// Animated label with a subtle fade-pulse and an ellipsis that cycles.
// ---------------------------------------------------------------------------
class _AnimatedLabel extends StatefulWidget {
  final String label;
  final Color color;
  final AnimationController pulseAnimation;

  const _AnimatedLabel({
    required this.label,
    required this.color,
    required this.pulseAnimation,
  });

  @override
  State<_AnimatedLabel> createState() => _AnimatedLabelState();
}

class _AnimatedLabelState extends State<_AnimatedLabel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ellipsisController;

  @override
  void initState() {
    super.initState();
    _ellipsisController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _ellipsisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.pulseAnimation, _ellipsisController]),
      builder: (context, _) {
        // Cycling ellipsis: .  ..  ...  (blank)
        final dotCount = (_ellipsisController.value * 4).floor() % 4;
        final ellipsis = '.' * dotCount;

        final opacity = 0.6 + 0.4 * widget.pulseAnimation.value;

        return Opacity(
          opacity: opacity,
          child: Text(
            '${widget.label}$ellipsis',
            style: TextStyle(
              color: widget.color,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        );
      },
    );
  }
}
