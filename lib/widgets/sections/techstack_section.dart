import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/portfolio_data.dart';
import '../../theme/app_theme.dart';

class TechStackSection extends StatelessWidget {
  const TechStackSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 80,
      ),
      child: Column(
        children: [
          const _ScanLine(),
          const SizedBox(height: 24),
          Text(
            'MY TECHSTACK',
            style: TextStyle(
              color: colors.text,
              fontSize: isMobile ? 36 : 72,
              fontWeight: FontWeight.w400,
              letterSpacing: 4,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 600.ms),
          const SizedBox(height: 12),
          Text(
            'Tools & technologies I work with every day',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: isMobile ? 13 : 15,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
          const SizedBox(height: 64),
          Wrap(
            spacing: isMobile ? 12 : 20,
            runSpacing: isMobile ? 12 : 20,
            alignment: WrapAlignment.center,
            children: techStack.asMap().entries.map((entry) {
              return _TechBadge(
                name: entry.value,
                delay: entry.key * 80,
                isMobile: isMobile,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Animated scanning line ────────────────────────────────────────────────────

class _ScanLine extends StatefulWidget {
  const _ScanLine();

  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scanAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _scanAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SizedBox(
      width: 120,
      height: 2,
      child: AnimatedBuilder(
        animation: _scanAnim,
        builder: (_, __) => CustomPaint(
          painter: _ScanPainter(_scanAnim.value, colors.border, colors.accent),
        ),
      ),
    );
  }
}

class _ScanPainter extends CustomPainter {
  final double t;
  final Color borderColor;
  final Color accentColor;

  _ScanPainter(this.t, this.borderColor, this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), basePaint);

    final glowStart = (t * size.width - 30.0).clamp(0.0, size.width);
    const glowWidth = 60.0;
    final gradient = LinearGradient(
      colors: [
        Colors.transparent,
        accentColor.withValues(alpha: 0.9),
        Colors.transparent,
      ],
      stops: const [0, 0.5, 1],
    );
    final glowPaint = Paint()
      ..shader = gradient
          .createShader(Rect.fromLTWH(glowStart, 0, glowWidth, size.height));
    canvas.drawRect(
      Rect.fromLTWH(
          glowStart, 0, glowWidth.clamp(0.0, size.width - glowStart), size.height),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanPainter old) =>
      old.t != t || old.accentColor != accentColor;
}

// ── Tech badge ────────────────────────────────────────────────────────────────

class _TechBadge extends StatefulWidget {
  final String name;
  final int delay;
  final bool isMobile;

  const _TechBadge({
    required this.name,
    required this.delay,
    required this.isMobile,
  });

  @override
  State<_TechBadge> createState() => _TechBadgeState();
}

class _TechBadgeState extends State<_TechBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final Animation<double> _floatAnim;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2200 + widget.delay * 20),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final badgeSize = widget.isMobile ? 100.0 : 130.0;

    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, _floatAnim.value),
        child: child,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: badgeSize,
          height: badgeSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hovered ? colors.accent.withValues(alpha: 0.12) : colors.cardBg,
            border: Border.all(
              color: _hovered ? colors.accent : colors.border,
              width: _hovered ? 1.5 : 1,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: colors.accent.withValues(alpha: 0.30),
                      blurRadius: 28,
                      spreadRadius: 3,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: _hovered ? 8 : 5,
                  height: _hovered ? 8 : 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _hovered
                        ? colors.accent
                        : colors.accent.withValues(alpha: 0.4),
                    boxShadow: _hovered
                        ? [
                            BoxShadow(
                              color: colors.accent.withValues(alpha: 0.6),
                              blurRadius: 8,
                            )
                          ]
                        : [],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _hovered ? colors.accent : colors.text,
                    fontSize: widget.isMobile ? 11 : 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: widget.delay.ms)
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.4, 0.4), curve: Curves.easeOut);
  }
}
