import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_strings.dart';
import '../../theme/app_theme.dart';
import '../../main.dart';

class Navbar extends StatefulWidget {
  final VoidCallback onAbout;
  final VoidCallback onWork;
  final VoidCallback onContact;
  final ScrollController? scrollController;

  const Navbar({
    super.key,
    required this.onAbout,
    required this.onWork,
    required this.onContact,
    this.scrollController,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool _menuOpen = false;
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = widget.scrollController?.offset ?? 0;
    final isScrolled = offset > 60;
    if (isScrolled != _scrolled) setState(() => _scrolled = isScrolled);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.background.withValues(alpha: _scrolled ? 0.92 : 0.85),
                  colors.background.withValues(alpha: 0.0),
                ],
              ),
              border: _scrolled
                  ? Border(
                      bottom: BorderSide(
                        color: colors.border.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    )
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _LogoMK(),
                  if (!isMobile)
                    Row(
                      children: [
                        _NavLink('ABOUT', widget.onAbout),
                        const SizedBox(width: 32),
                        _NavLink('WORK', widget.onWork),
                        const SizedBox(width: 32),
                        _NavLink('CONTACT', widget.onContact),
                        const SizedBox(width: 24),
                        const _ThemeToggle(),
                        const SizedBox(width: 24),
                        GestureDetector(
                          onTap: () => launchUrl(
                              Uri.parse(AppStrings.linkedInUrl)),
                          child: Text(
                            AppStrings.linkedInHandle,
                            style: TextStyle(
                              color: colors.textMuted,
                              fontSize: 12,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        const _ThemeToggle(),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: Icon(
                            _menuOpen ? Icons.close : Icons.menu,
                            color: colors.text,
                          ),
                          onPressed: () =>
                              setState(() => _menuOpen = !_menuOpen),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (isMobile && _menuOpen)
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              color: context.appColors.surface.withValues(alpha: 0.97),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _mobileNavLink(context, 'ABOUT', widget.onAbout),
                  _mobileNavLink(context, 'WORK', widget.onWork),
                  _mobileNavLink(context, 'CONTACT', widget.onContact),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _mobileNavLink(
      BuildContext context, String label, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        setState(() => _menuOpen = false);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(
          label,
          style: TextStyle(
            color: context.appColors.text,
            fontSize: 14,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ── Theme toggle button ───────────────────────────────────────────────────────

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return GestureDetector(
          onTap: () {
            themeNotifier.value =
                isDark ? ThemeMode.light : ThemeMode.dark;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.accent.withValues(alpha: 0.10),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: colors.accent,
              size: 17,
            ),
          ),
        );
      },
    );
  }
}

// ── Logo with subtle glow ─────────────────────────────────────────────────────

class _LogoMK extends StatefulWidget {
  @override
  State<_LogoMK> createState() => _LogoMKState();
}

class _LogoMKState extends State<_LogoMK> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          color: _hovered ? colors.accent : colors.text,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 3,
          shadows: _hovered
              ? [
                  Shadow(
                    color: colors.accent.withValues(alpha: 0.6),
                    blurRadius: 12,
                  ),
                ]
              : [],
        ),
        child: const Text('MK'),
      ),
    );
  }
}

// ── Desktop nav link with animated underline ──────────────────────────────────

class _NavLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _NavLink(this.text, this.onTap);

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _underlineAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _underlineAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return MouseRegion(
      onEnter: (_) => _ctrl.forward(),
      onExit: (_) => _ctrl.reverse(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _underlineAnim,
              builder: (_, child) => Text(
                widget.text,
                style: TextStyle(
                  color: Color.lerp(
                      colors.text, colors.accent, _underlineAnim.value)!,
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 3),
            AnimatedBuilder(
              animation: _underlineAnim,
              builder: (_, __) => Container(
                height: 1,
                width: 40 * _underlineAnim.value,
                color: colors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
