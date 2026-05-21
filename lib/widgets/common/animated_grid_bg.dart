import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AnimatedGridBackground extends StatefulWidget {
  final Widget child;

  const AnimatedGridBackground({super.key, required this.child});

  @override
  State<AnimatedGridBackground> createState() =>
      _AnimatedGridBackgroundState();
}

class _AnimatedGridBackgroundState extends State<AnimatedGridBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = context.appColors.accent;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => CustomPaint(
        painter: _DotGridPainter(_ctrl.value, accentColor),
        child: child,
      ),
      child: RepaintBoundary(child: widget.child),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  final double t;
  final Color accentColor;

  _DotGridPainter(this.t, this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 52.0;
    const dotR = 1.1;
    final paint = Paint()..style = PaintingStyle.fill;
    final cols = (size.width / spacing).ceil() + 1;
    final rows = (size.height / spacing).ceil() + 1;

    for (var c = 0; c < cols; c++) {
      for (var r = 0; r < rows; r++) {
        final wave = math.sin(t * 2 * math.pi + c * 0.5 + r * 0.4);
        final alpha = 0.025 + (wave * 0.5 + 0.5) * 0.055;
        paint.color = accentColor.withValues(alpha: alpha);
        canvas.drawCircle(Offset(c * spacing, r * spacing), dotR, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter old) =>
      old.t != t || old.accentColor != accentColor;
}
