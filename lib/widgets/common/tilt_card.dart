import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 3D perspective-tilt card that responds to mouse hover — pure Flutter.
/// On mobile (no hover) it renders the child unchanged.
class TiltCard extends StatefulWidget {
  final Widget child;
  final double maxTiltDegrees;

  const TiltCard({
    super.key,
    required this.child,
    this.maxTiltDegrees = 5.0,
  });

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> {
  Offset _tilt = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {},
      onExit: (_) => setState(() => _tilt = Offset.zero),
      onHover: (event) {
        final rb = context.findRenderObject() as RenderBox?;
        if (rb == null) return;
        final local = rb.globalToLocal(event.position);
        final sz = rb.size;
        setState(() {
          _tilt = Offset(
            (local.dx / sz.width - 0.5) * 2,
            -(local.dy / sz.height - 0.5) * 2,
          );
        });
      },
      child: TweenAnimationBuilder<Offset>(
        tween: Tween(begin: Offset.zero, end: _tilt),
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        builder: (context, tilt, child) {
          final maxRad = widget.maxTiltDegrees * math.pi / 180;
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateX(tilt.dy * maxRad)
              ..rotateY(tilt.dx * maxRad),
            alignment: Alignment.center,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
