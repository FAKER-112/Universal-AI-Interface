import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // -- Palette --
  static const _seedColor = Color(0xFF00BFA5); // teal accent

  // -- Font resolver --
  static TextTheme _textThemeFor(String fontFamily, TextTheme base) {
    switch (fontFamily) {
      case 'Roboto':
        return GoogleFonts.robotoTextTheme(base);
      case 'Roboto Mono':
        return GoogleFonts.robotoMonoTextTheme(base);
      case 'JetBrains Mono':
        return GoogleFonts.jetBrainsMonoTextTheme(base);
      case 'Fira Code':
        return GoogleFonts.firaCodeTextTheme(base);
      case 'Source Sans 3':
        return GoogleFonts.sourceSans3TextTheme(base);
      case 'Inter':
      default:
        return GoogleFonts.interTextTheme(base);
    }
  }

  // -- Light --
  static ThemeData lightTheme({String fontFamily = 'Inter'}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );
    return _build(colorScheme, fontFamily);
  }

  // -- Dark Dim (dark gray surfaces) --
  static ThemeData darkDimTheme({String fontFamily = 'Inter'}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
      surface: const Color(0xFF1A1A2E),
      onSurface: const Color(0xFFE0E0E0),
    );
    return _build(colorScheme, fontFamily);
  }

  // -- Dark Lights-Out (AMOLED black) --
  static ThemeData darkLightsOutTheme({String fontFamily = 'Inter'}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
      surface: Colors.black,
      onSurface: const Color(0xFFE8E8E8),
    );
    return _build(
      colorScheme,
      fontFamily,
      surfaceContainerOverride: const Color(0xFF0D0D0D),
    );
  }

  // -- Builder --
  static ThemeData _build(
    ColorScheme cs,
    String fontFamily, {
    Color? surfaceContainerOverride,
  }) {
    final baseTextTheme = ThemeData(colorScheme: cs).textTheme;
    final textTheme = _textThemeFor(fontFamily, baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      textTheme: textTheme,
      scaffoldBackgroundColor: cs.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: cs.onSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surface,
        indicatorColor: cs.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: cs.surface,
        indicatorColor: cs.primaryContainer,
        selectedLabelTextStyle: textTheme.labelSmall?.copyWith(
          color: cs.primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: textTheme.labelSmall?.copyWith(
          color: cs.onSurfaceVariant,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerOverride ?? cs.surfaceContainerHighest,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerOverride ?? cs.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: cs.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: cs.onSurfaceVariant),
      ),
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant.withValues(alpha: 0.3),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
