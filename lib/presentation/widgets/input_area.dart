import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Text input area with Send / Stop Generating actions.
class InputAreaWidget extends StatefulWidget {
  const InputAreaWidget({
    super.key,
    required this.isStreaming,
    required this.onSend,
    required this.onStop,
  });

  final bool isStreaming;
  final ValueChanged<String> onSend;
  final VoidCallback onStop;

  @override
  State<InputAreaWidget> createState() => _InputAreaWidgetState();
}

class _InputAreaWidgetState extends State<InputAreaWidget> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          top: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.2)),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Text field
            Expanded(
              child: KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (event) {
                  // Enter sends, Shift+Enter inserts newline.
                  if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.enter &&
                      !HardwareKeyboard.instance.isShiftPressed) {
                    _submit();
                  }
                },
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLines: 5,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: widget.isStreaming
                        ? 'Waiting for response...'
                        : 'Type a message...',
                    suffixIcon: widget.isStreaming
                        ? IconButton(
                            onPressed: widget.onStop,
                            icon: Icon(
                              Icons.stop_circle_rounded,
                              color: cs.error,
                            ),
                            tooltip: 'Stop generating',
                          )
                        : ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _controller,
                            builder: (context, value, _) {
                              final active = value.text.trim().isNotEmpty;
                              return IconButton(
                                onPressed: active ? _submit : null,
                                icon: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: active
                                        ? cs.primary
                                        : cs.onSurface.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.arrow_upward_rounded,
                                    color: active
                                        ? cs.onPrimary
                                        : cs.onSurfaceVariant.withValues(
                                            alpha: 0.4,
                                          ),
                                    size: 20,
                                  ),
                                ),
                                tooltip: 'Send message',
                              );
                            },
                          ),
                  ),
                  enabled: !widget.isStreaming,
                  onSubmitted: (_) => _submit(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
