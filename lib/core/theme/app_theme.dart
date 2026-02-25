import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// Chat-specific theme extension
// ---------------------------------------------------------------------------

/// Semantic colors for the chat UI that go beyond Material's ColorScheme.
class ChatThemeExtension extends ThemeExtension<ChatThemeExtension> {
  const ChatThemeExtension({
    required this.sidebarBg,
    required this.sidebarHover,
    required this.userBubbleBg,
    required this.assistantCardBg,
    required this.assistantCardBorder,
    required this.codeBg,
    required this.codeHeaderBg,
    required this.subtleBorder,
    required this.inputBg,
  });

  final Color sidebarBg;
  final Color sidebarHover;
  final Color userBubbleBg;
  final Color assistantCardBg;
  final Color assistantCardBorder;
  final Color codeBg;
  final Color codeHeaderBg;
  final Color subtleBorder;
  final Color inputBg;

  @override
  ChatThemeExtension copyWith({
    Color? sidebarBg,
    Color? sidebarHover,
    Color? userBubbleBg,
    Color? assistantCardBg,
    Color? assistantCardBorder,
    Color? codeBg,
    Color? codeHeaderBg,
    Color? subtleBorder,
    Color? inputBg,
  }) {
    return ChatThemeExtension(
      sidebarBg: sidebarBg ?? this.sidebarBg,
      sidebarHover: sidebarHover ?? this.sidebarHover,
      userBubbleBg: userBubbleBg ?? this.userBubbleBg,
      assistantCardBg: assistantCardBg ?? this.assistantCardBg,
      assistantCardBorder: assistantCardBorder ?? this.assistantCardBorder,
      codeBg: codeBg ?? this.codeBg,
      codeHeaderBg: codeHeaderBg ?? this.codeHeaderBg,
      subtleBorder: subtleBorder ?? this.subtleBorder,
      inputBg: inputBg ?? this.inputBg,
    );
  }

  @override
  ChatThemeExtension lerp(covariant ChatThemeExtension? other, double t) {
    if (other == null) return this;
    return ChatThemeExtension(
      sidebarBg: Color.lerp(sidebarBg, other.sidebarBg, t)!,
      sidebarHover: Color.lerp(sidebarHover, other.sidebarHover, t)!,
      userBubbleBg: Color.lerp(userBubbleBg, other.userBubbleBg, t)!,
      assistantCardBg: Color.lerp(assistantCardBg, other.assistantCardBg, t)!,
      assistantCardBorder: Color.lerp(
        assistantCardBorder,
        other.assistantCardBorder,
        t,
      )!,
      codeBg: Color.lerp(codeBg, other.codeBg, t)!,
      codeHeaderBg: Color.lerp(codeHeaderBg, other.codeHeaderBg, t)!,
      subtleBorder: Color.lerp(subtleBorder, other.subtleBorder, t)!,
      inputBg: Color.lerp(inputBg, other.inputBg, t)!,
    );
  }

  // -- Presets --

  static const light = ChatThemeExtension(
    sidebarBg: Color(0xFFF5F5F5),
    sidebarHover: Color(0xFFEDEDED),
    userBubbleBg: Color(0xFFE8F0FE),
    assistantCardBg: Color(0xFFFFFFFF),
    assistantCardBorder: Color(0xFFE8E8E8),
    codeBg: Color(0xFF282C34),
    codeHeaderBg: Color(0xFF21252B),
    subtleBorder: Color(0xFFEAEAEA),
    inputBg: Color(0xFFF0F0F0),
  );

  static const darkDim = ChatThemeExtension(
    sidebarBg: Color(0xFF141420),
    sidebarHover: Color(0xFF1E1E30),
    userBubbleBg: Color(0xFF1A2740),
    assistantCardBg: Color(0xFF1E1E2E),
    assistantCardBorder: Color(0xFF2A2A3E),
    codeBg: Color(0xFF0D0D1A),
    codeHeaderBg: Color(0xFF0A0A15),
    subtleBorder: Color(0xFF2A2A3E),
    inputBg: Color(0xFF1A1A2C),
  );

  static const darkLightsOut = ChatThemeExtension(
    sidebarBg: Color(0xFF0A0A0A),
    sidebarHover: Color(0xFF151515),
    userBubbleBg: Color(0xFF0F1A2C),
    assistantCardBg: Color(0xFF0D0D0D),
    assistantCardBorder: Color(0xFF1A1A1A),
    codeBg: Color(0xFF050508),
    codeHeaderBg: Color(0xFF030306),
    subtleBorder: Color(0xFF1A1A1A),
    inputBg: Color(0xFF111111),
  );
}

// ---------------------------------------------------------------------------
// App theme builder
// ---------------------------------------------------------------------------

class AppTheme {
  AppTheme._();

  static const _seedColor = Color(0xFF00BFA5);
  static const _radius = 14.0;

  /// Resolves a font family name to the real platform font family string
  /// registered by GoogleFonts.
  static String _resolveFontFamily(String name) {
    try {
      return GoogleFonts.getFont(name).fontFamily ?? name;
    } catch (_) {
      return name;
    }
  }

  // -- Light --
  static ThemeData lightTheme({String fontFamily = 'Inter'}) {
    final cs = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
      surface: const Color(0xFFFAFAFA),
    );
    return _build(cs, fontFamily, ChatThemeExtension.light);
  }

  // -- Dark Dim --
  static ThemeData darkDimTheme({String fontFamily = 'Inter'}) {
    final cs = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
      surface: const Color(0xFF1A1A2E),
      onSurface: const Color(0xFFE0E0E0),
    );
    return _build(cs, fontFamily, ChatThemeExtension.darkDim);
  }

  // -- Dark Lights-Out --
  static ThemeData darkLightsOutTheme({String fontFamily = 'Inter'}) {
    final cs = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
      surface: Colors.black,
      onSurface: const Color(0xFFE8E8E8),
    );
    return _build(
      cs,
      fontFamily,
      ChatThemeExtension.darkLightsOut,
      surfaceContainerOverride: const Color(0xFF0D0D0D),
    );
  }

  // -- Builder --
  static ThemeData _build(
    ColorScheme cs,
    String fontFamily,
    ChatThemeExtension chatTheme, {
    Color? surfaceContainerOverride,
  }) {
    final resolvedFamily = _resolveFontFamily(fontFamily);
    final baseTheme = ThemeData(useMaterial3: true, colorScheme: cs);
    final textTheme = baseTheme.textTheme.apply(fontFamily: resolvedFamily);

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      textTheme: textTheme,
      scaffoldBackgroundColor: cs.surface,
      extensions: [chatTheme],
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
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
          borderRadius: BorderRadius.circular(_radius + 10),
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
            borderRadius: BorderRadius.circular(_radius),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
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
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        elevation: 4,
        surfaceTintColor: Colors.transparent,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius),
            borderSide: BorderSide(color: cs.outlineVariant),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: cs.inverseSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: cs.onInverseSurface),
        waitDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
