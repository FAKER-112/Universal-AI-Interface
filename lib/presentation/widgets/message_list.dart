import 'package:flutter/material.dart';

import 'package:ai_client_service/data/models/chat_message.dart';
import 'package:ai_client_service/presentation/widgets/message_bubble.dart';

/// Scrollable message list with floating scroll-to-top / scroll-to-bottom
/// buttons that appear contextually.
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
  bool _showScrollDown = false;
  bool _showScrollUp = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant MessageListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length ||
        widget.isStreaming) {
      _scrollToBottom();
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final atBottom = pos.pixels >= pos.maxScrollExtent - 100;
    final atTop = pos.pixels <= 100;

    setState(() {
      _showScrollDown = !atBottom;
      _showScrollUp = !atTop;
    });
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

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Messages
        ListView.builder(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: MessageBubbleWidget(
                    message: msg,
                    isStreaming: isLast && widget.isStreaming,
                  ),
                ),
              ),
            );
          },
        ),

        // Scroll to top
        if (_showScrollUp)
          Positioned(
            top: 12,
            right: 16,
            child: _ScrollFab(
              icon: Icons.keyboard_arrow_up_rounded,
              tooltip: 'Scroll to top',
              onPressed: _scrollToTop,
              colorScheme: cs,
            ),
          ),

        // Scroll to bottom
        if (_showScrollDown)
          Positioned(
            bottom: 12,
            right: 16,
            child: _ScrollFab(
              icon: Icons.keyboard_arrow_down_rounded,
              tooltip: 'Scroll to bottom',
              onPressed: _scrollToBottom,
              colorScheme: cs,
            ),
          ),
      ],
    );
  }
}

class _ScrollFab extends StatelessWidget {
  const _ScrollFab({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.colorScheme,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shape: const CircleBorder(),
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Tooltip(
          message: tooltip,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surfaceContainerHighest,
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}
