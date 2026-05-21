import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/portfolio_data.dart';
import '../../theme/app_theme.dart';
import '../common/tilt_card.dart';

class WorkSection extends StatefulWidget {
  const WorkSection({super.key});

  @override
  State<WorkSection> createState() => _WorkSectionState();
}

class _WorkSectionState extends State<WorkSection> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateTo(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isMobile = MediaQuery.of(context).size.width < 768;
    final cardHeight = isMobile ? 400.0 : 340.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: isMobile ? 24 : 80,
        right: 0,
        top: 80,
        bottom: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: isMobile ? 24 : 80),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: colors.text,
                  fontSize: isMobile ? 32 : 48,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  const TextSpan(text: 'My '),
                  TextSpan(
                      text: 'Work', style: TextStyle(color: colors.accent)),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms),
          ),
          const SizedBox(height: 36),
          SizedBox(
            height: cardHeight,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemCount: projects.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: TiltCard(
                  child: _ProjectCard(
                    project: projects[index],
                    number: index + 1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: EdgeInsets.only(right: isMobile ? 24 : 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _ArrowButton(
                      icon: Icons.arrow_back,
                      enabled: _currentIndex > 0,
                      onTap: () => _navigateTo(_currentIndex - 1),
                    ),
                    const SizedBox(width: 8),
                    _ArrowButton(
                      icon: Icons.arrow_forward,
                      enabled: _currentIndex < projects.length - 1,
                      onTap: () => _navigateTo(_currentIndex + 1),
                    ),
                  ],
                ),
                Row(
                  children: projects.asMap().entries.map((entry) {
                    final isActive = entry.key == _currentIndex;
                    return GestureDetector(
                      onTap: () => _navigateTo(entry.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(left: 8),
                        width: isActive ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isActive ? colors.accent : colors.border,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatefulWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _ArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<_ArrowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.enabled && _hovered
                  ? colors.accent
                  : widget.enabled
                      ? colors.border
                      : colors.border.withValues(alpha: 0.4),
            ),
            color: widget.enabled && _hovered
                ? colors.accent.withValues(alpha: 0.08)
                : colors.cardBg,
            boxShadow: widget.enabled && _hovered
                ? [
                    BoxShadow(
                      color: colors.accent.withValues(alpha: 0.2),
                      blurRadius: 16,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Icon(
            widget.icon,
            color: widget.enabled
                ? (_hovered ? colors.accent : colors.text)
                : colors.textMuted.withValues(alpha: 0.4),
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Project project;
  final int number;

  const _ProjectCard({required this.project, required this.number});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.project.link),
            mode: LaunchMode.externalApplication),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          decoration: BoxDecoration(
            color: colors.cardBg,
            border: Border.all(
                color: _hovered ? colors.accent : colors.border),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: colors.accent.withValues(alpha: 0.18),
                      blurRadius: 36,
                      spreadRadius: 4,
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _hovered ? 3 : 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colors.accentBright
                          .withValues(alpha: _hovered ? 1.0 : 0.4),
                      colors.accent.withValues(alpha: _hovered ? 1.0 : 0.4),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '0${widget.number}',
                            style: TextStyle(
                              color: colors.accent.withValues(alpha: 0.55),
                              fontSize: 40,
                              fontWeight: FontWeight.w200,
                              height: 1,
                            ),
                          ),
                          AnimatedRotation(
                            turns: _hovered ? 0.0 : -0.1,
                            duration: const Duration(milliseconds: 300),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 260),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: _hovered
                                    ? colors.accent.withValues(alpha: 0.15)
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_outward,
                                color: _hovered
                                    ? colors.accent
                                    : colors.accent.withValues(alpha: 0.7),
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.project.title,
                        style: TextStyle(
                          color: _hovered ? colors.accent : colors.text,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.project.category,
                        style: TextStyle(
                          color: colors.accent,
                          fontSize: 13,
                          letterSpacing: 0.8,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      Container(height: 1, color: colors.border),
                      const SizedBox(height: 16),
                      Text(
                        'TOOLS & FEATURES',
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.project.tools,
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 14,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
