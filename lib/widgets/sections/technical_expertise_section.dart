import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../constants/app_asset.dart';
import '../../theme/app_theme.dart';

class TechnicalExpertiseSection extends StatelessWidget {
  const TechnicalExpertiseSection({super.key});

  static const _skills = [
    _SkillItem('Flutter', 0.95, Color(0xFF3B82F6)),
    _SkillItem('Dart', 0.90, Color(0xFF06B6D4)),
    _SkillItem('Firebase', 0.85, Color(0xFFF59E0B)),
    _SkillItem('REST APIs', 0.90, Color(0xFF10B981)),
    _SkillItem('Provider / Riverpod', 0.88, Color(0xFFD946EF)),
    _SkillItem('UI/UX Design', 0.80, Color(0xFFEC4899)),
    _SkillItem('CI/CD', 0.75, Color(0xFFEF4444)),
    _SkillItem('Git', 0.85, Color(0xFFF97316)),
  ];

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
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeftContent(context, colors, isMobile),
                const SizedBox(height: 48),
                _buildSkillList(colors),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 5,
                    child: _buildLeftContent(context, colors, isMobile)),
                const SizedBox(width: 80),
                Expanded(flex: 6, child: _buildSkillList(colors)),
              ],
            ),
    );
  }

  Widget _buildLeftContent(
      BuildContext context, AppColorScheme colors, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
            children: [
              TextSpan(
                  text: 'Technical ', style: TextStyle(color: colors.text)),
              TextSpan(
                  text: 'Expertise', style: TextStyle(color: colors.accent)),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms),
        const SizedBox(height: 20),
        Text(
          'I leverage the latest tools and technologies to build robust, scalable, and efficient mobile applications. My deep understanding of the Flutter ecosystem allows me to handle complex requirements with ease.',
          style: TextStyle(color: colors.textMuted, fontSize: 14, height: 1.7),
        ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
        const SizedBox(height: 32),
        const Wrap(
          spacing: 32,
          runSpacing: 14,
          children: [
            _BulletPoint('Clean Architecture'),
            _BulletPoint('TDD'),
            _BulletPoint('SOLID Principles'),
            _BulletPoint('Agile Methodology'),
          ],
        ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
        const SizedBox(height: 30),
        Container(
          color: Colors.transparent,
          width: isMobile ? 300 : 420,
          height: isMobile ? 250 : 320,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const ModelViewer(
              src: AppAssets.flutterLogo,
              alt: 'Flutter logo 3D model',
              autoRotate: true,
              cameraControls: true,
              backgroundColor: Colors.transparent,
            ),
          ),
        ).animate().fadeIn(delay: 600.ms, duration: 700.ms),
      ],
    );
  }

  Widget _buildSkillList(AppColorScheme colors) {
    return Column(
      children: _skills
          .asMap()
          .entries
          .map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 22),
                child: _SkillBar(item: entry.value, delay: entry.key * 80),
              ))
          .toList(),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: colors.accent),
        ),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: colors.text, fontSize: 14)),
      ],
    );
  }
}

class _SkillItem {
  final String name;
  final double percentage;
  final Color color;

  const _SkillItem(this.name, this.percentage, this.color);
}

class _SkillBar extends StatefulWidget {
  final _SkillItem item;
  final int delay;

  const _SkillBar({required this.item, required this.delay});

  @override
  State<_SkillBar> createState() => _SkillBarState();
}

class _SkillBarState extends State<_SkillBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fillAnim;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _fillAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _triggerOnce() {
    if (_triggered) return;
    _triggered = true;
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return VisibilityDetector(
      key: Key('skill_${widget.item.name}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3) _triggerOnce();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.item.name,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(widget.item.percentage * 100).toInt()}%',
                style: TextStyle(color: colors.textMuted, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
            child: AnimatedBuilder(
              animation: _fillAnim,
              builder: (_, __) => FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor:
                    (_fillAnim.value * widget.item.percentage).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.item.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
