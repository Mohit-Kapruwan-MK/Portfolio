import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  static const _services = [
    _ServiceItem(
      icon: Icons.phone_android_rounded,
      iconColor: Color(0xFF3B82F6),
      title: 'Mobile App Development',
      description:
          'Native-performance cross-platform apps using Flutter for iOS and Android.',
    ),
    _ServiceItem(
      icon: Icons.dashboard_rounded,
      iconColor: Color(0xFF06B6D4),
      title: 'UI/UX Implementation',
      description:
          'Pixel-perfect implementation of complex designs with smooth animations.',
    ),
    _ServiceItem(
      icon: Icons.storage_rounded,
      iconColor: Color(0xFFD946EF),
      title: 'Backend Integration',
      description:
          'Seamless integration with Firebase, REST APIs, and GraphQL services.',
    ),
    _ServiceItem(
      icon: Icons.bolt_rounded,
      iconColor: Color(0xFFF59E0B),
      title: 'Performance Optimization',
      description:
          'Optimizing app performance, reducing build size, and fixing memory leaks.',
    ),
    _ServiceItem(
      icon: Icons.code_rounded,
      iconColor: Color(0xFF10B981),
      title: 'Clean Code Architecture',
      description:
          'Scalable codebases using Clean Architecture, SOLID principles, and TDD.',
    ),
    _ServiceItem(
      icon: Icons.rocket_launch_rounded,
      iconColor: Color(0xFFEC4899),
      title: 'App Store Deployment',
      description:
          'Handling the entire publishing process to Google Play and Apple App Store.',
    ),
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
      child: Column(
        children: [
          Text(
            'Services',
            style: TextStyle(
              color: colors.text,
              fontSize: isMobile ? 32 : 52,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 600.ms),
          const SizedBox(height: 16),
          Text(
            'Comprehensive solutions for your mobile application needs,\nfrom concept to deployment.',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: isMobile ? 13 : 15,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
          const SizedBox(height: 56),
          isMobile
              ? Column(
                  children: _services
                      .asMap()
                      .entries
                      .map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _ServiceCard(
                                item: entry.value, delay: entry.key * 80),
                          ))
                      .toList(),
                )
              : Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _services
                            .sublist(0, 3)
                            .asMap()
                            .entries
                            .map((entry) => Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: entry.key < 2 ? 20 : 0,
                                      bottom: 20,
                                    ),
                                    child: _ServiceCard(
                                        item: entry.value,
                                        delay: entry.key * 80),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _services
                            .sublist(3, 6)
                            .asMap()
                            .entries
                            .map((entry) => Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: entry.key < 2 ? 20 : 0),
                                    child: _ServiceCard(
                                        item: entry.value,
                                        delay: (entry.key + 3) * 80),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _ServiceItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });
}

class _ServiceCard extends StatefulWidget {
  final _ServiceItem item;
  final int delay;

  const _ServiceCard({required this.item, required this.delay});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _hovered
              ? widget.item.iconColor.withValues(alpha: 0.06)
              : colors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? widget.item.iconColor.withValues(alpha: 0.35)
                : colors.border,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: widget.item.iconColor.withValues(alpha: 0.12),
                    blurRadius: 24,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.item.iconColor.withValues(alpha: 0.14),
              ),
              child: Icon(widget.item.icon,
                  color: widget.item.iconColor, size: 26),
            ),
            const SizedBox(height: 20),
            Text(
              widget.item.title,
              style: TextStyle(
                color: colors.text,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.item.description,
              style: TextStyle(
                color: colors.textMuted,
                fontSize: 13,
                height: 1.65,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: widget.delay.ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.12, curve: Curves.easeOut);
  }
}
