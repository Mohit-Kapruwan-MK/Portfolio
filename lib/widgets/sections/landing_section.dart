import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:video_player/video_player.dart';
import '../../constants/app_asset.dart';
import '../../theme/app_theme.dart';
import '../common/glowing_orb.dart';

// Landing section always has a dark video backdrop, so static dark-mode
// colours (AppColors) are intentional — they don't follow the theme toggle.
class LandingSection extends StatelessWidget {
  const LandingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final horizontalPadding = isMobile ? 24.0 : 60.0;

    return SizedBox(
      height: size.height,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const Positioned.fill(child: _VideoBackground()),

          // Dark overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.58),
              ),
            ),
          ),

          // Vignette
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.15,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.50),
                  ],
                  stops: const [0.25, 1.0],
                ),
              ),
            ),
          ),

          // Top fade
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withValues(alpha: 0.90),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Bottom fade
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.85),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.65, 1.0],
                ),
              ),
            ),
          ),

          // Glow orbs
          const Positioned(
            top: -80,
            left: -80,
            child: GlowingOrb(
              color: AppColors.accentBright,
              size: 320,
              blurRadius: 90,
              duration: Duration(seconds: 5),
            ),
          ),
          const Positioned(
            bottom: 60,
            right: -80,
            child: GlowingOrb(
              color: AppColors.accentBright,
              size: 280,
              blurRadius: 70,
              duration: Duration(seconds: 7),
            ),
          ),
          Positioned(
            top: size.height * 0.3,
            right: -60,
            child: GlowingOrb(
              color: AppColors.accent.withValues(alpha: 0.4),
              size: 180,
              blurRadius: 80,
              duration: const Duration(seconds: 9),
            ),
          ),

          // Name (left) + typewriter role (right)
          Positioned(
            left: horizontalPadding,
            right: horizontalPadding,
            top: size.height * (isMobile ? 0.08 : 0.10),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameWidget(isMobile),
                      const SizedBox(height: 20),
                      _buildRoleWidget(isMobile),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameWidget(isMobile),
                      _buildRoleWidget(isMobile),
                    ],
                  ),
          ),

          // Headline + stats
          Positioned(
            left: 0,
            right: 0,
            top: size.height * (isMobile ? 0.47 : 0.44),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.textMuted),
                      color: AppColors.surface.withValues(alpha: 0.65),
                    ),
                    child: const Text(
                      'Available for Freelance & Full-time',
                      style: TextStyle(
                        color: Color(0xFF00CCFF),
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

                  SizedBox(height: isMobile ? 14 : 22),

                  Text(
                    'Building Future',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: isMobile ? 38 : 82,
                      fontWeight: FontWeight.w800,
                      height: 1.05,
                      letterSpacing: isMobile ? -0.5 : -2,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 700.ms)
                      .slideY(begin: 0.2, curve: Curves.easeOut),

                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF0099FF),
                        Color(0xFF00CCFF),
                        Color(0xFFAA00FF),
                        Color(0xFFFF00BB),
                      ],
                    ).createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      'Mobile Experiences',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 38 : 82,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                        letterSpacing: isMobile ? -0.5 : -2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 700.ms)
                      .slideY(begin: 0.2, curve: Curves.easeOut),

                  SizedBox(height: isMobile ? 28 : 44),

                  _StatsRow(isMobile: isMobile),
                ],
              ),
            ),
          ),

          // Scroll cue
          Positioned(
            bottom: isMobile ? 24 : 32,
            left: 0,
            right: 0,
            child: const Center(child: _ScrollCue()),
          ),
        ],
      ),
    );
  }

  Widget _buildNameWidget(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "HELLO, I'M",
          style: TextStyle(
            color: AppColors.accent,
            fontSize: isMobile ? 14 : 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 700.ms).slideY(begin: 0.3),
        const SizedBox(height: 4),
        Text(
          'MOHIT',
          style: TextStyle(
            color: AppColors.text,
            fontSize: isMobile ? 34 : 46,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            height: 1.1,
          ),
        ).animate().fadeIn(delay: 600.ms, duration: 700.ms).slideY(begin: 0.3),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.text, AppColors.accent],
            stops: [0.4, 1.0],
          ).createShader(bounds),
          child: Text(
            'KAPRUWAN',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 34 : 46,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              height: 1.1,
            ),
          ),
        ).animate().fadeIn(delay: 800.ms, duration: 700.ms).slideY(begin: 0.3),
      ],
    );
  }

  Widget _buildRoleWidget(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: isMobile ? 50 : 62,
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'FLUTTER',
                textStyle: TextStyle(
                  color: AppColors.accent,
                  fontSize: isMobile ? 35 : 44,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
                speed: const Duration(milliseconds: 90),
              ),
              TypewriterAnimatedText(
                'MOBILE',
                textStyle: TextStyle(
                  color: AppColors.accent,
                  fontSize: isMobile ? 35 : 44,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
                speed: const Duration(milliseconds: 90),
              ),
              TypewriterAnimatedText(
                'CREATIVE',
                textStyle: TextStyle(
                  color: AppColors.accent,
                  fontSize: isMobile ? 35 : 44,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
                speed: const Duration(milliseconds: 90),
              ),
            ],
            repeatForever: true,
            pause: const Duration(milliseconds: 1800),
            displayFullTextOnTap: true,
          ),
        ),
        Text(
          'DEVELOPER',
          style: TextStyle(
            color: AppColors.accentBright,
            fontSize: isMobile ? 18 : 26,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ).animate().fadeIn(delay: 1000.ms, duration: 700.ms),
      ],
    );
  }
}

// ── Looping video background ──────────────────────────────────────────────────

class _VideoBackground extends StatefulWidget {
  const _VideoBackground();

  @override
  State<_VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<_VideoBackground> {
  late final VideoPlayerController _ctrl;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _ctrl = VideoPlayerController.asset(AppAssets.introVideo)
      ..initialize().then((_) {
        if (!mounted) return;
        _ctrl
          ..setVolume(0)
          ..setLooping(true)
          ..play();
        setState(() => _ready = true);
      }).catchError((_) {});
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const ColoredBox(color: AppColors.background);
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: _ctrl.value.size.width,
        height: _ctrl.value.size.height,
        child: VideoPlayer(_ctrl),
      ),
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final bool isMobile;
  const _StatsRow({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _statItem('3+', 'Years\nExp'),
        _divider(),
        _statItem('4', 'Apps\nShipped'),
        _divider(),
        _statItem('2', 'Platforms'),
      ],
    )
        .animate()
        .fadeIn(delay: 900.ms, duration: 700.ms)
        .slideY(begin: 0.2, curve: Curves.easeOut);
  }

  Widget _statItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.accent,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            height: 1.3,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.border,
    );
  }
}

// ── Bouncing scroll cue ───────────────────────────────────────────────────────

class _ScrollCue extends StatelessWidget {
  const _ScrollCue();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'SCROLL',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 9,
            letterSpacing: 3,
          ),
        ),
        SizedBox(height: 6),
        Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted, size: 18),
      ],
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fadeIn(delay: 2000.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0, curve: Curves.easeInOut);
  }
}
