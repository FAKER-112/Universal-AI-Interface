import 'package:flutter/material.dart';

import 'package:ai_client_service/data/models/chat_message.dart';
import 'package:ai_client_service/presentation/widgets/message_bubble.dart';

/// Scrollable list of chat messages with auto-scroll on new content.
class MessageListWidget extends StatefulWidget {
  const MessageListWidget({
    super.key,
    required this.messages,
    required this.isStreaming,
  });

  final List<ChatMessage> messages;
  final bool isStreaming;

  @override
  State<MessageListWidget> createState() => _MessageListWidgetState();
}

class _MessageListWidgetState extends State<MessageListWidget> {
  final _controller = ScrollController();
  bool _autoScroll = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.position.pixels;
    // Re-enable auto-scroll when user scrolls back to bottom.
    _autoScroll = (maxScroll - currentScroll) < 60;
  }

  @override
  void didUpdateWidget(covariant MessageListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_autoScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _scrollToBottom() {
    if (!_controller.hasClients) return;
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final msg = widget.messages[index];
        final isLast = index == widget.messages.length - 1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: MessageBubbleWidget(
            message: msg,
            isStreaming: isLast && widget.isStreaming,
          ),
        );
      },
    );
  }
}
