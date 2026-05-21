import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Plays a fade+slide entrance animation once when the widget scrolls into view.
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double slideBeginY;
  final Duration duration;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.slideBeginY = 0.12,
    this.duration = const Duration(milliseconds: 700),
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  bool _triggered = false;
  late final Key _detectorKey;

  @override
  void initState() {
    super.initState();
    _detectorKey = UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _detectorKey,
      onVisibilityChanged: (info) {
        if (!_triggered && info.visibleFraction > 0.12) {
          setState(() => _triggered = true);
        }
      },
      child: _triggered
          ? widget.child
              .animate()
              .fadeIn(delay: widget.delay, duration: widget.duration)
              .slideY(
                begin: widget.slideBeginY,
                curve: Curves.easeOut,
                duration: widget.duration,
              )
          : Opacity(opacity: 0, child: widget.child),
    );
  }
}
