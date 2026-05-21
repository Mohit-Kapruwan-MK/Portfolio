import 'package:flutter/material.dart';
import 'dart:math' as math;

class GlowingOrb extends StatefulWidget {
  final Color color;
  final double size;
  final double blurRadius;
  final Duration duration;

  const GlowingOrb({
    super.key,
    required this.color,
    this.size = 300,
    this.blurRadius = 60,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<GlowingOrb> createState() => _GlowingOrbState();
}

class _GlowingOrbState extends State<GlowingOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => Transform.rotate(
        angle: _ctrl.value * 2 * math.pi,
        child: child,
      ),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color.withValues(alpha: 0.12),
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.35),
              blurRadius: widget.blurRadius,
              spreadRadius: widget.blurRadius / 4,
            ),
          ],
        ),
      ),
    );
  }
}
