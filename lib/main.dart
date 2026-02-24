import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_client_service/core/theme/app_theme.dart';
import 'package:ai_client_service/core/router/app_router.dart';
import 'package:ai_client_service/presentation/providers/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    final lightTheme = AppTheme.lightTheme(fontFamily: settings.fontFamily);

    final darkTheme = settings.darkVariant == DarkVariant.lightsOut
        ? AppTheme.darkLightsOutTheme(fontFamily: settings.fontFamily)
        : AppTheme.darkDimTheme(fontFamily: settings.fontFamily);

    return MaterialApp.router(
      title: 'AI Client',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: settings.themeMode,
      routerConfig: goRouter,
    );
  }
}
