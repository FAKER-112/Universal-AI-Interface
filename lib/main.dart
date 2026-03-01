import 'dart:io';

import 'package:window_manager/window_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ai_client_service/core/theme/app_theme.dart';
import 'package:ai_client_service/core/router/app_router.dart';
import 'package:ai_client_service/core/security/secure_storage.dart';
import 'package:ai_client_service/data/datasources/chat_local_datasource.dart';
import 'package:ai_client_service/data/models/isar_chat_session.dart';
import 'package:ai_client_service/data/models/isar_chat_message.dart';
import 'package:ai_client_service/data/models/isar_provider_config.dart';
import 'package:ai_client_service/presentation/providers/theme_provider.dart';

/// SharedPreferences key for the custom Isar database path.
const kDbPathKey = 'custom_db_path';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Desktop window manager setup
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(400, 600),
      center: true,
      title: 'AI Client',
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Read custom DB path from SharedPreferences (if set).
  final prefs = await SharedPreferences.getInstance();
  final customPath = prefs.getString(kDbPathKey);

  // Resolve the actual directory to use for Isar.
  String dbPath;
  if (customPath != null && customPath.isNotEmpty) {
    final customDir = Directory(customPath);
    if (await customDir.exists()) {
      dbPath = customPath;
    } else {
      // Custom path no longer exists, fall back to default.
      dbPath = (await getApplicationDocumentsDirectory()).path;
    }
  } else {
    dbPath = (await getApplicationDocumentsDirectory()).path;
  }

  // Open Isar database
  final isar = await Isar.open(
    [IsarChatSessionSchema, IsarChatMessageSchema, IsarProviderConfigSchema],
    directory: dbPath,
    name: 'ai_client',
  );

  final localDataSource = LocalDataSource(isar);
  final secureStorage = SecureStorageDataSource();

  runApp(
    ProviderScope(
      overrides: [
        localDataSourceProvider.overrideWithValue(localDataSource),
        secureStorageProvider.overrideWithValue(secureStorage),
        dbPathProvider.overrideWithValue(dbPath),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

/// Global providers for the datasources, overridden in main().
final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

final secureStorageProvider = Provider<SecureStorageDataSource>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

/// The resolved path where the Isar database files live.
final dbPathProvider = Provider<String>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

/// SharedPreferences instance (initialized before runApp).
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

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
