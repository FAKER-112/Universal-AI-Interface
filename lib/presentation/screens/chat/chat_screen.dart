import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_client_service/presentation/providers/chat_provider.dart';
import 'package:ai_client_service/presentation/widgets/message_list.dart';
import 'package:ai_client_service/presentation/widgets/input_area.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatNotifierProvider);
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        // -- App bar area --
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: cs.surface,
            border: Border(
              bottom: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.15),
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                Icon(Icons.auto_awesome, size: 20, color: cs.primary),
                const SizedBox(width: 8),
                Text(
                  'Chat',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
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
          const SizedBox(height: 16),
          Text(
            'What can I help you with?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Type a message below to begin',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
