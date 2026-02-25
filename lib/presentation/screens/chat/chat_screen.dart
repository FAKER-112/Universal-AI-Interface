import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_client_service/core/theme/app_theme.dart';
import 'package:ai_client_service/presentation/providers/chat_provider.dart';
import 'package:ai_client_service/presentation/widgets/message_list.dart';
import 'package:ai_client_service/presentation/widgets/input_area.dart';
import 'package:ai_client_service/presentation/widgets/model_selector.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatNotifierProvider);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final chatExt = Theme.of(context).extension<ChatThemeExtension>()!;

    return Column(
      children: [
        // -- Chat header with model selector --
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: cs.surface,
            border: Border(bottom: BorderSide(color: chatExt.subtleBorder)),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                // Mobile hamburger (only visible when no sidebar)
                if (MediaQuery.sizeOf(context).width < 600)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      icon: const Icon(Icons.menu, size: 22),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      tooltip: 'Menu',
                    ),
                  ),

                // Model selector
                ModelSelector(
                  currentModel: 'mock-model-v1',
                  availableModels: const [
                    'mock-model-v1',
                    'mock-model-v2',
                    'gpt-4o',
                    'claude-3.5-sonnet',
                  ],
                  onModelChanged: (model) {
                    // Will hook into provider configuration later
                  },
                ),

                const SizedBox(width: 12),

                // Chat title
                Expanded(
                  child: Text(
                    chatState.messages.isEmpty ? 'New chat' : 'Chat',
                    style: tt.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: cs.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Stop streaming action
                if (chatState.isStreaming)
                  TextButton.icon(
                    onPressed: () =>
                        ref.read(chatNotifierProvider.notifier).cancelStream(),
                    icon: const Icon(Icons.stop_circle_outlined, size: 18),
                    label: const Text('Stop'),
                    style: TextButton.styleFrom(foregroundColor: cs.error),
                  ),
              ],
            ),
          ),
        ),

        // -- Messages --
        Expanded(
          child: chatState.messages.isEmpty
              ? _EmptyState(colorScheme: cs)
              : MessageListWidget(
                  messages: chatState.messages,
                  isStreaming: chatState.isStreaming,
                ),
        ),

        // -- Input --
        InputAreaWidget(
          isStreaming: chatState.isStreaming,
          onSend: (text) {
            ref.read(chatNotifierProvider.notifier).sendMessage(text);
          },
          onStop: () {
            ref.read(chatNotifierProvider.notifier).cancelStream();
          },
        ),
      ],
    );
  }
}

/// Shown when there are no messages yet.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.colorScheme});
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.15),
                  colorScheme.tertiary.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 32,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'What can I help you with?',
            style: tt.headlineSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask anything -- I\'m here to help.',
            style: tt.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
