import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../common/scroll_reveal.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrollReveal(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'ABOUT ME',
                    style: TextStyle(
                      color: colors.accent,
                      fontSize: 12,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(height: 1, color: colors.accent),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          ScrollReveal(
            delay: const Duration(milliseconds: 150),
            child: Text(
              'Passionate and results-driven Software Engineer with 3+ years of experience in mobile app development, specializing in Flutter. Skilled in building high-performance, scalable, and user-friendly cross-platform applications with modern UI/UX principles. A tech enthusiast who enjoys exploring innovative solutions, learning emerging technologies, and turning ideas into impactful digital products. Fluent in English and Hindi, with strong communication and collaboration skills. Currently open to exciting opportunities where I can contribute, grow, and create meaningful experiences.',
              style: TextStyle(
                color: colors.text,
                fontSize: isMobile ? 18 : 22,
                fontWeight: FontWeight.w300,
                height: 1.7,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 48),
          ScrollReveal(
            delay: const Duration(milliseconds: 300),
            child: isMobile
                ? Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: _buildStatCards(),
                  )
                : Row(
                    children: _buildStatCards()
                        .map((card) => Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: card,
                            ))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStatCards() {
    return const [
      _StatCard(value: '3+', label: 'Years Experience'),
      _StatCard(value: '4', label: 'Apps Shipped'),
      _StatCard(value: '2', label: 'Platforms'),
      _StatCard(value: '∞', label: 'Coffees'),
    ];
  }
}

class _StatCard extends StatefulWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: _hovered ? colors.accent.withValues(alpha: 0.07) : colors.cardBg,
          border: Border.all(
            color: _hovered ? colors.accent : colors.border,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: colors.accent.withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.value,
              style: TextStyle(
                color: colors.accent,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: TextStyle(
                color: colors.textMuted,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOut);
  }
}
