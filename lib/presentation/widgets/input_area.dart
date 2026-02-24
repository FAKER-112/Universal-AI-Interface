import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ChatGPT-style input area: rounded pill field with a "+" on the left,
/// placeholder text, and a circular send button on the right.
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
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fieldBg = isDark
        ? cs.onSurface.withValues(alpha: 0.08)
        : cs.onSurface.withValues(alpha: 0.05);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // -- Input pill --
            Container(
              decoration: BoxDecoration(
                color: fieldBg,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // "+" button on the left
                  Padding(
                    padding: const EdgeInsets.only(left: 6, bottom: 6),
                    child: IconButton(
                      onPressed: () {
                        // Attachment action placeholder
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: 22,
                        color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                      tooltip: 'Attach',
                      splashRadius: 18,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),

                  // Text field
                  Expanded(
                    child: KeyboardListener(
                      focusNode: FocusNode(),
                      onKeyEvent: (event) {
                        if (event is KeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.enter &&
                            !HardwareKeyboard.instance.isShiftPressed) {
                          _submit();
                        }
                      },
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        maxLines: 6,
                        minLines: 1,
                        textInputAction: TextInputAction.newline,
                        style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                        decoration: InputDecoration(
                          hintText: widget.isStreaming
                              ? 'Waiting for response...'
                              : 'Ask anything',
                          hintStyle: tt.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          isDense: true,
                        ),
                        enabled: !widget.isStreaming,
                        onSubmitted: (_) => _submit(),
                      ),
                    ),
                  ),

                  // Right-side action buttons
                  Padding(
                    padding: const EdgeInsets.only(right: 6, bottom: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.isStreaming)
                          // Stop button
                          _CircleActionButton(
                            onPressed: widget.onStop,
                            icon: Icons.stop_rounded,
                            filled: true,
                            colorScheme: cs,
                          )
                        else
                          // Send button
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _controller,
                            builder: (context, value, _) {
                              final active = value.text.trim().isNotEmpty;
                              return _CircleActionButton(
                                onPressed: active ? _submit : null,
                                icon: Icons.arrow_upward_rounded,
                                filled: active,
                                colorScheme: cs,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // -- Disclaimer text --
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 2),
              child: Text(
                'AI can make mistakes. Verify important information.',
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Circular action button (send / stop)
// ---------------------------------------------------------------------------

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.onPressed,
    required this.icon,
    required this.filled,
    required this.colorScheme,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final bool filled;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        onPressed: onPressed,
        icon: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: filled
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: filled
                ? colorScheme.surface
                : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
        padding: EdgeInsets.zero,
        tooltip: filled ? 'Send message' : null,
      ),
    );
  }
}
