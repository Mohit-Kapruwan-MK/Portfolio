import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF050810);
  static const Color surface = Color(0xFF0A0E17);
  static const Color accent = Color(0xFF5EEAD4);
  static const Color accentBright = Color(0xFF22D3EE);
  static const Color text = Color(0xFFEAE5EC);
  static const Color textMuted = Color(0xFF8892A4);
  static const Color cardBg = Color(0xFF0D1420);
  static const Color border = Color(0xFF1A2340);
}

@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.background,
    required this.surface,
    required this.accent,
    required this.accentBright,
    required this.text,
    required this.textMuted,
    required this.cardBg,
    required this.border,
  });

  final Color background;
  final Color surface;
  final Color accent;
  final Color accentBright;
  final Color text;
  final Color textMuted;
  final Color cardBg;
  final Color border;

  static const dark = AppColorScheme(
    background: Color(0xFF050810),
    surface: Color(0xFF0A0E17),
    accent: Color(0xFF5EEAD4),
    accentBright: Color(0xFF22D3EE),
    text: Color(0xFFEAE5EC),
    textMuted: Color(0xFF8892A4),
    cardBg: Color(0xFF0D1420),
    border: Color(0xFF1A2340),
  );

  static const light = AppColorScheme(
    background: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    accent: Color(0xFF0D9488),
    accentBright: Color(0xFF0891B2),
    text: Color(0xFF0F172A),
    textMuted: Color(0xFF64748B),
    cardBg: Color(0xFFF1F5F9),
    border: Color(0xFFE2E8F0),
  );

  @override
  AppColorScheme copyWith({
    Color? background,
    Color? surface,
    Color? accent,
    Color? accentBright,
    Color? text,
    Color? textMuted,
    Color? cardBg,
    Color? border,
  }) =>
      AppColorScheme(
        background: background ?? this.background,
        surface: surface ?? this.surface,
        accent: accent ?? this.accent,
        accentBright: accentBright ?? this.accentBright,
        text: text ?? this.text,
        textMuted: textMuted ?? this.textMuted,
        cardBg: cardBg ?? this.cardBg,
        border: border ?? this.border,
      );

  @override
  AppColorScheme lerp(AppColorScheme? other, double t) {
    if (other == null) return this;
    return AppColorScheme(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentBright: Color.lerp(accentBright, other.accentBright, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColorScheme get appColors =>
      Theme.of(this).extension<AppColorScheme>()!;
}

class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColorScheme.dark.background,
        colorScheme: ColorScheme.dark(
          primary: AppColorScheme.dark.accent,
          surface: AppColorScheme.dark.surface,
          onSurface: AppColorScheme.dark.text,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
          bodyColor: AppColorScheme.dark.text,
          displayColor: AppColorScheme.dark.text,
        ),
        extensions: const [AppColorScheme.dark],
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColorScheme.light.background,
        colorScheme: ColorScheme.light(
          primary: AppColorScheme.light.accent,
          surface: AppColorScheme.light.surface,
          onSurface: AppColorScheme.light.text,
        ),
        textTheme:
            GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
          bodyColor: AppColorScheme.light.text,
          displayColor: AppColorScheme.light.text,
        ),
        extensions: const [AppColorScheme.light],
      );
}
