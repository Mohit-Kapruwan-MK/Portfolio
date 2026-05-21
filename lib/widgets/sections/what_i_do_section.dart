import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/portfolio_data.dart';
import '../../theme/app_theme.dart';

class WhatIDoSection extends StatelessWidget {
  const WhatIDoSection({super.key});

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
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: colors.text,
                fontSize: isMobile ? 52 : 88,
                fontWeight: FontWeight.w700,
                height: 1.0,
                letterSpacing: 1,
              ),
              children: [
                const TextSpan(text: 'W'),
                TextSpan(
                  text: 'HAT',
                  style: TextStyle(
                    color: colors.textMuted,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                const TextSpan(text: '\nI'),
                TextSpan(
                  text: ' DO',
                  style: TextStyle(
                    color: colors.textMuted,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms),
          const SizedBox(height: 48),
          isMobile
              ? Column(
                  children: whatIDoItems
                      .asMap()
                      .entries
                      .map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _WhatIDoCard(
                              item: entry.value,
                              delay: entry.key * 150,
                            ),
                          ))
                      .toList(),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: whatIDoItems
                      .asMap()
                      .entries
                      .map((entry) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: entry.key < whatIDoItems.length - 1
                                      ? 16
                                      : 0),
                              child: _WhatIDoCard(
                                item: entry.value,
                                delay: entry.key * 150,
                              ),
                            ),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }
}

class _WhatIDoCard extends StatefulWidget {
  final WhatIDoItem item;
  final int delay;

  const _WhatIDoCard({required this.item, required this.delay});

  @override
  State<_WhatIDoCard> createState() => _WhatIDoCardState();
}

class _WhatIDoCardState extends State<_WhatIDoCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          border: Border.all(
            color: _expanded ? colors.accent : colors.border,
            width: 1,
          ),
          color:
              _expanded ? colors.accent.withValues(alpha: 0.05) : colors.cardBg,
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.item.title,
              style: TextStyle(
                color: colors.accent,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.item.subtitle,
              style: TextStyle(
                color: colors.text,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _expanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          widget.item.description,
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'SKILLSET & TOOLS',
                          style: TextStyle(
                            color: colors.text,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.item.tags
                              .map((tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: colors.border, width: 1),
                                      color: colors.surface,
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                          color: colors.text, fontSize: 12),
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    )
                  : const SizedBox(height: 20),
            ),
            Row(
              children: [
                Text(
                  _expanded ? 'Show less' : 'Learn more',
                  style: TextStyle(
                    color: colors.accent,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: colors.accent,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: widget.delay.ms).fadeIn(duration: 600.ms).slideY(
          begin: 0.1,
          curve: Curves.easeOut,
        );
  }
}
