import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/portfolio_data.dart';
import '../../theme/app_theme.dart';
import '../common/glowing_orb.dart';

class FlutterShowcaseSection extends StatefulWidget {
  const FlutterShowcaseSection({super.key});

  @override
  State<FlutterShowcaseSection> createState() => _FlutterShowcaseSectionState();
}

class _FlutterShowcaseSectionState extends State<FlutterShowcaseSection>
    with TickerProviderStateMixin {
  late final AnimationController _orbitCtrl;
  late final AnimationController _floatCtrl;
  late final Timer _carouselTimer;
  int _activeProjectIndex = 0;

  @override
  void initState() {
    super.initState();
    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) {
        setState(() {
          _activeProjectIndex =
              (_activeProjectIndex + 1) % projects.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _orbitCtrl.dispose();
    _floatCtrl.dispose();
    _carouselTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          top: 60,
          left: -60,
          child: IgnorePointer(
            child: GlowingOrb(
              color: colors.accentBright.withValues(alpha: 0.4),
              size: 240,
              blurRadius: 70,
              duration: const Duration(seconds: 10),
            ),
          ),
        ),
        Positioned(
          bottom: 60,
          right: -60,
          child: IgnorePointer(
            child: GlowingOrb(
              color: colors.accent.withValues(alpha: 0.4),
              size: 220,
              blurRadius: 65,
              duration: const Duration(seconds: 8),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 80,
            vertical: 100,
          ),
          child: Column(
            children: [
              Text(
                'FLUTTER IN ACTION',
                style: TextStyle(
                  color: colors.accent,
                  fontSize: 11,
                  letterSpacing: 5,
                  fontWeight: FontWeight.w600,
                ),
              ).animate().fadeIn(duration: 600.ms),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: colors.text,
                    fontSize: isMobile ? 30 : 50,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                  children: [
                    const TextSpan(text: "Apps I've "),
                    TextSpan(
                        text: 'Built',
                        style: TextStyle(color: colors.accent)),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
              const SizedBox(height: 72),
              isMobile
                  ? _MobileShowcase(
                      activeIndex: _activeProjectIndex,
                      orbitCtrl: _orbitCtrl,
                      floatCtrl: _floatCtrl,
                      onSelect: (i) =>
                          setState(() => _activeProjectIndex = i),
                    )
                  : _DesktopShowcase(
                      activeIndex: _activeProjectIndex,
                      orbitCtrl: _orbitCtrl,
                      floatCtrl: _floatCtrl,
                      onSelect: (i) =>
                          setState(() => _activeProjectIndex = i),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DesktopShowcase extends StatelessWidget {
  final int activeIndex;
  final AnimationController orbitCtrl;
  final AnimationController floatCtrl;
  final ValueChanged<int> onSelect;

  const _DesktopShowcase({
    required this.activeIndex,
    required this.orbitCtrl,
    required this.floatCtrl,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: _ProjectList(activeIndex: activeIndex, onSelect: onSelect)),
        const SizedBox(width: 48),
        _PhoneMockup(
            activeIndex: activeIndex,
            orbitCtrl: orbitCtrl,
            floatCtrl: floatCtrl),
        const SizedBox(width: 48),
        Expanded(child: _ProjectDetail(activeIndex: activeIndex)),
      ],
    );
  }
}

class _MobileShowcase extends StatelessWidget {
  final int activeIndex;
  final AnimationController orbitCtrl;
  final AnimationController floatCtrl;
  final ValueChanged<int> onSelect;

  const _MobileShowcase({
    required this.activeIndex,
    required this.orbitCtrl,
    required this.floatCtrl,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PhoneMockup(
            activeIndex: activeIndex,
            orbitCtrl: orbitCtrl,
            floatCtrl: floatCtrl),
        const SizedBox(height: 40),
        _ProjectList(activeIndex: activeIndex, onSelect: onSelect),
      ],
    );
  }
}

class _PhoneMockup extends StatelessWidget {
  final int activeIndex;
  final AnimationController orbitCtrl;
  final AnimationController floatCtrl;

  const _PhoneMockup({
    required this.activeIndex,
    required this.orbitCtrl,
    required this.floatCtrl,
  });

  static const _phoneWidth = 190.0;
  static const _phoneHeight = 400.0;
  static const _ringPadding = 60.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AnimatedBuilder(
      animation: Listenable.merge([orbitCtrl, floatCtrl]),
      builder: (_, __) {
        final floatOffsetY =
            math.sin(floatCtrl.value * math.pi) * 10 - 5;
        final orbitAngle = orbitCtrl.value * 2 * math.pi;

        return SizedBox(
          width: _phoneWidth + _ringPadding * 2,
          height: _phoneHeight + _ringPadding * 2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: orbitAngle * 0.6,
                child: _buildRing(
                  _phoneWidth + _ringPadding * 2,
                  _phoneHeight + _ringPadding * 2,
                  colors.accentBright.withValues(alpha: 0.06),
                  1,
                ),
              ),
              Transform.rotate(
                angle: -orbitAngle,
                child: _buildRing(
                  _phoneWidth + _ringPadding * 1.4,
                  _phoneHeight + _ringPadding * 1.4,
                  colors.accent.withValues(alpha: 0.10),
                  1,
                ),
              ),
              ..._buildOrbitDots(
                orbitAngle,
                (_phoneWidth + _ringPadding * 1.4) / 2,
                (_phoneHeight + _ringPadding * 1.4) / 2,
                colors.accent,
              ),
              Positioned(
                bottom: _ringPadding - 10,
                child: Transform.translate(
                  offset: Offset(0, floatOffsetY * 0.4),
                  child: Container(
                    width: _phoneWidth * 0.7,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: colors.accent.withValues(alpha: 0.22),
                          blurRadius: 32,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, floatOffsetY),
                child: _Phone(activeIndex: activeIndex),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRing(double width, double height, Color color, double stroke) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(math.max(width, height)),
        border: Border.all(color: color, width: stroke),
      ),
    );
  }

  List<Widget> _buildOrbitDots(
      double angle, double radiusX, double radiusY, Color accentColor) {
    return List.generate(4, (i) {
      final dotAngle = angle + i * math.pi / 2;
      return Transform.translate(
        offset:
            Offset(math.cos(dotAngle) * radiusX, math.sin(dotAngle) * radiusY),
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accentColor.withValues(alpha: 0.7),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _Phone extends StatelessWidget {
  final int activeIndex;
  const _Phone({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: 190,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        color: colors.cardBg,
        border: Border.all(
          color: colors.accent.withValues(alpha: 0.28),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.accentBright.withValues(alpha: 0.12),
            blurRadius: 40,
            spreadRadius: 6,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(33),
        child: Column(
          children: [
            // Status bar
            Container(
              height: 40,
              color: colors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '9:41',
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    width: 54,
                    height: 18,
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.signal_cellular_alt,
                          color: colors.text, size: 13),
                      const SizedBox(width: 4),
                      Icon(Icons.battery_full, color: colors.text, size: 13),
                    ],
                  ),
                ],
              ),
            ),
            // App content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0, 0.08),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                ),
                child: _AppScreen(
                  key: ValueKey(activeIndex),
                  project: projects[activeIndex],
                ),
              ),
            ),
            // Home indicator
            Container(
              height: 26,
              color: colors.surface,
              child: Center(
                child: Container(
                  width: 80,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.text.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppScreen extends StatelessWidget {
  final Project project;
  const _AppScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tint = project.tintColor;

    return Container(
      color: colors.background,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [tint, tint.withValues(alpha: 0.5)],
                  ),
                ),
                child:
                    const Icon(Icons.flutter_dash, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  project.title,
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.notifications_outlined, color: colors.textMuted, size: 16),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  tint.withValues(alpha: 0.18),
                  tint.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(color: tint.withValues(alpha: 0.25)),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone_iphone_rounded, color: tint, size: 28),
                  const SizedBox(height: 4),
                  Text(
                    'Live on Store',
                    style: TextStyle(
                      color: tint,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _statChip(Icons.star_rounded, '4.8', tint, colors),
              const SizedBox(width: 6),
              _statChip(Icons.download_rounded, '10k+', tint, colors),
              const SizedBox(width: 6),
              _statChip(Icons.flutter_dash, 'Flutter', tint, colors),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(3, (i) => _shimmerRow(i, colors)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icons.home_rounded,
              Icons.search_rounded,
              Icons.bookmark_rounded,
              Icons.person_rounded,
            ]
                .map((icon) => Icon(
                      icon,
                      color:
                          icon == Icons.home_rounded ? tint : colors.textMuted,
                      size: 18,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _statChip(
      IconData icon, String label, Color tint, AppColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 9, color: tint),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(color: colors.text, fontSize: 9)),
        ],
      ),
    );
  }

  Widget _shimmerRow(int index, AppColorScheme colors) {
    const widthFactors = [0.75, 0.55, 0.65];
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        height: 8,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: colors.border.withValues(alpha: 0.6),
        ),
        child: FractionallySizedBox(
          widthFactor: widthFactors[index % widthFactors.length],
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: colors.border,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectList extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onSelect;

  const _ProjectList({required this.activeIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: projects.asMap().entries.map((entry) {
        final isActive = entry.key == activeIndex;
        return GestureDetector(
          onTap: () => onSelect(entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isActive
                  ? colors.accent.withValues(alpha: 0.07)
                  : Colors.transparent,
              border: Border.all(
                color: isActive
                    ? colors.accent
                    : colors.border.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '0${entry.key + 1}',
                  style: TextStyle(
                    color: isActive
                        ? colors.accent
                        : colors.textMuted.withValues(alpha: 0.35),
                    fontSize: 22,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    entry.value.title,
                    style: TextStyle(
                      color: isActive ? colors.text : colors.textMuted,
                      fontSize: 15,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (isActive)
                  Icon(Icons.arrow_forward_ios, color: colors.accent, size: 13),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ProjectDetail extends StatelessWidget {
  final int activeIndex;
  const _ProjectDetail({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final project = projects[activeIndex];
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: Column(
        key: ValueKey(activeIndex),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            project.title,
            style: TextStyle(
              color: colors.text,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            project.category,
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 14,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'TECH STACK',
            style: TextStyle(
              color: colors.accent,
              fontSize: 10,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            project.tools,
            style: TextStyle(color: colors.text, fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }
}
