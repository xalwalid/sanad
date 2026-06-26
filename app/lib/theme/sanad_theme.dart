import 'package:flutter/material.dart';

/// Sanad's green identity — single source of truth for color.
/// Matches the 2026-06-25 design hand-off (deeper green on warm cream).
class SanadColors {
  static const primary = Color(0xFF1B4D3E); // primary CTA / selected
  static const heading = Color(0xFF16352B); // deep headings
  static const hero1 = Color(0xFF235C49); // hero gradient top
  static const hero2 = Color(0xFF143A2F); // hero gradient bottom
  static const page = Color(0xFFF3F0E8); // page background (warm cream)
  static const card = Color(0xFFFFFFFF);
  static const selectedTint = Color(0xFFEFF4EF);
  static const iconTile = Color(0xFFEAF0EA);
  static const softCardA = Color(0xFFEFF4EF);
  static const softCardB = Color(0xFFE6EEE6);

  static const textSecondary = Color(0xFF8A9185);
  static const textMuted = Color(0xFFB3B0A4);
  static const body = Color(0xFF5A6359);
  static const border = Color(0xFFE7E2D6);
  static const trackOff = Color(0xFFD8D2C2);

  static const accent = Color(0xFF517F5C); // success/accent
  static const danger = Color(0xFFA32D2D); // destructive (delete)
  static const mid = Color(0xFF3B7A57); // mid green (avatars, soft accents)
  static const ringA = Color(0xFFC7D6C5);
  static const ringB = Color(0xFF8FAF98);

  // SOS / warm support accent
  static const sos1 = Color(0xFFD08A4E);
  static const sos2 = Color(0xFFC26F3C);

  // craving scale (5 steps, cool → warm)
  static const craving = [
    Color(0xFF8FAF98),
    Color(0xFFB8C58A),
    Color(0xFFD8C06A),
    Color(0xFFD89A4E),
    Color(0xFFC26F3C),
  ];

  static const heroGradient =
      LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [hero1, hero2]);
}

class SanadTheme {
  // Cairo is bundled in assets/fonts/ (declared in pubspec) — fully offline.
  static const String fontFamily = 'Cairo';

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: SanadColors.primary,
      primary: SanadColors.primary,
      surface: SanadColors.card,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: SanadColors.page,
      cardTheme: const CardThemeData(
        elevation: 0,
        color: SanadColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: SanadColors.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: SanadColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(58),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge:
            TextStyle(color: SanadColors.heading, fontWeight: FontWeight.w800),
        headlineSmall:
            TextStyle(color: SanadColors.heading, fontWeight: FontWeight.w800),
        titleLarge:
            TextStyle(color: SanadColors.heading, fontWeight: FontWeight.w800),
        titleMedium:
            TextStyle(color: SanadColors.heading, fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(color: SanadColors.body),
        bodySmall: TextStyle(color: SanadColors.textSecondary),
      ),
    );
  }

  // Radii
  static const rCta = 18.0;
  static const rCard = 20.0;
  static const rHero = 30.0;
  static const rChip = 13.0;
  static const rTile = 14.0;

  static const cardShadow = [
    BoxShadow(color: Color(0x141B4D3E), blurRadius: 20, offset: Offset(0, 7)),
  ];
  static const ctaShadow = [
    BoxShadow(color: Color(0x471B4D3E), blurRadius: 26, offset: Offset(0, 12)),
  ];
}
