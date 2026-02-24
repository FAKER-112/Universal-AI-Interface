import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/// Dark mode variant: "dim" (dark gray) or "lightsOut" (pure AMOLED black).
enum DarkVariant { dim, lightsOut }

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.darkVariant = DarkVariant.dim,
    this.fontFamily = 'Inter',
  });

  final ThemeMode themeMode;
  final DarkVariant darkVariant;
  final String fontFamily;

  AppSettings copyWith({
    ThemeMode? themeMode,
    DarkVariant? darkVariant,
    String? fontFamily,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      darkVariant: darkVariant ?? this.darkVariant,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(const AppSettings());

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void setDarkVariant(DarkVariant variant) {
    state = state.copyWith(darkVariant: variant);
  }

  void setFontFamily(String family) {
    state = state.copyWith(fontFamily: family);
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
      return AppSettingsNotifier();
    });
