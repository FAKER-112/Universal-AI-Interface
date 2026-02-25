import 'package:flutter/material.dart';

import 'package:ai_client_service/data/models/chat_message.dart';
import 'package:ai_client_service/presentation/widgets/message_bubble.dart';

/// Scrollable message list. Centers content at a comfortable max width
/// with generous vertical rhythm and fade-in animation for new messages.
class MessageListWidget extends StatefulWidget {
  const MessageListWidget({
    super.key,
    required this.messages,
    this.isStreaming = false,
  });

  final List<ChatMessage> messages;
  final bool isStreaming;

  @override
  State<MessageListWidget> createState() => _MessageListWidgetState();
}

class _MessageListWidgetState extends State<MessageListWidget> {
  final _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant MessageListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length ||
        widget.isStreaming) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final msg = widget.messages[index];
        final isLast = index == widget.messages.length - 1;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: MessageBubbleWidget(
                message: msg,
                isStreaming: isLast && widget.isStreaming,
              ),
            ),
          ),
        );
      },
    );
  }
}
