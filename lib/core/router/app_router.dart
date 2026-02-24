import 'package:go_router/go_router.dart';

import 'package:ai_client_service/presentation/screens/shell/app_shell.dart';
import 'package:ai_client_service/presentation/screens/chat/chat_screen.dart';
import 'package:ai_client_service/presentation/screens/settings/settings_screen.dart';
import 'package:ai_client_service/presentation/screens/history/history_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/chat/new',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/chat/:id',
          builder: (context, state) {
            final chatId = state.pathParameters['id'] ?? 'new';
            return ChatScreen(chatId: chatId);
          },
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => const HistoryScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
