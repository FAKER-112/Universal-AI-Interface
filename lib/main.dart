import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:ai_client_service/core/theme/app_theme.dart';
import 'package:ai_client_service/core/router/app_router.dart';
import 'package:ai_client_service/core/security/secure_storage.dart';
import 'package:ai_client_service/data/datasources/chat_local_datasource.dart';
import 'package:ai_client_service/data/models/isar_chat_session.dart';
import 'package:ai_client_service/data/models/isar_chat_message.dart';
import 'package:ai_client_service/data/models/isar_provider_config.dart';
import 'package:ai_client_service/presentation/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open Isar database
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [IsarChatSessionSchema, IsarChatMessageSchema, IsarProviderConfigSchema],
    directory: dir.path,
    name: 'ai_client',
  );

  final localDataSource = LocalDataSource(isar);
  final secureStorage = SecureStorageDataSource();

  runApp(
    ProviderScope(
      overrides: [
        localDataSourceProvider.overrideWithValue(localDataSource),
        secureStorageProvider.overrideWithValue(secureStorage),
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
