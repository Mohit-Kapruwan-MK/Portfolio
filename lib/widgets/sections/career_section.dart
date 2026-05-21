import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/portfolio_data.dart';
import '../../theme/app_theme.dart';
import '../common/glowing_orb.dart';

class CareerSection extends StatelessWidget {
  const CareerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          top: 80,
          left: -80,
          child: IgnorePointer(
            child: GlowingOrb(
              color: colors.accent.withValues(alpha: 0.4),
              size: 280,
              blurRadius: 80,
              duration: const Duration(seconds: 10),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 80,
            vertical: 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: colors.text,
                    fontSize: isMobile ? 30 : 44,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  children: [
                    const TextSpan(text: 'My career '),
                    TextSpan(
                        text: '&', style: TextStyle(color: colors.accent)),
                    const TextSpan(text: '\nexperience'),
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms),
              const SizedBox(height: 52),
              ...careerItems.asMap().entries.map(
                    (entry) =>
                        _CareerRow(item: entry.value, delay: entry.key * 150),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CareerRow extends StatelessWidget {
  final CareerItem item;
  final int delay;

  const _CareerRow({required this.item, required this.delay});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.accent,
                boxShadow: [
                  BoxShadow(
                    color: colors.accent.withValues(alpha: 0.55),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: isMobile ? 130 : 110,
              color: colors.border,
            ),
          ],
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.role,
                            style: TextStyle(
                              color: colors.text,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.company,
                            style: TextStyle(color: colors.accent, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item.period,
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.description,
                  style: TextStyle(
                    color: colors.textMuted,
                    fontSize: 13,
                    height: 1.65,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    )
        .animate(delay: delay.ms)
        .fadeIn(duration: 600.ms)
        .slideX(begin: -0.08, curve: Curves.easeOut);
  }
}
