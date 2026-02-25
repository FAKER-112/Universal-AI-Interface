import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ai_client_service/core/theme/app_theme.dart';

/// ChatGPT-style input area: rounded pill field with "+" and image icons on
/// the left, placeholder text, and a circular send button on the right.
/// Includes focus micro-animation and an expandable advanced options row.
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
  bool _focused = false;
  bool _showAdvanced = false;

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
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
    final chatExt = Theme.of(context).extension<ChatThemeExtension>()!;

    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // -- Input pill --
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: chatExt.inputBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _focused
                          ? cs.primary.withValues(alpha: 0.5)
                          : chatExt.subtleBorder,
                      width: _focused ? 1.5 : 1,
                    ),
                    boxShadow: _focused
                        ? [
                            BoxShadow(
                              color: cs.primary.withValues(alpha: 0.08),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // "+" button
                          Padding(
                            padding: const EdgeInsets.only(left: 6, bottom: 6),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add_circle_outline,
                                size: 22,
                                color: cs.onSurfaceVariant.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              tooltip: 'Attach file',
                              splashRadius: 18,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),

                          // Image upload
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.image_outlined,
                                size: 20,
                                color: cs.onSurfaceVariant.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              tooltip: 'Upload image',
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
                                    event.logicalKey ==
                                        LogicalKeyboardKey.enter &&
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
                                style: tt.bodyMedium?.copyWith(
                                  color: cs.onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: widget.isStreaming
                                      ? 'Waiting for response...'
                                      : 'Ask anything...',
                                  hintStyle: tt.bodyMedium?.copyWith(
                                    color: cs.onSurfaceVariant.withValues(
                                      alpha: 0.45,
                                    ),
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

                          // Advanced toggle
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: IconButton(
                              onPressed: () => setState(
                                () => _showAdvanced = !_showAdvanced,
                              ),
                              icon: AnimatedRotation(
                                turns: _showAdvanced ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  Icons.tune,
                                  size: 20,
                                  color: _showAdvanced
                                      ? cs.primary
                                      : cs.onSurfaceVariant.withValues(
                                          alpha: 0.6,
                                        ),
                                ),
                              ),
                              tooltip: 'Advanced options',
                              splashRadius: 18,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),

                          // Send / Stop button
                          Padding(
                            padding: const EdgeInsets.only(right: 6, bottom: 6),
                            child: widget.isStreaming
                                ? _CircleActionButton(
                                    onPressed: widget.onStop,
                                    icon: Icons.stop_rounded,
                                    filled: true,
                                    colorScheme: cs,
                                  )
                                : ValueListenableBuilder<TextEditingValue>(
                                    valueListenable: _controller,
                                    builder: (context, value, _) {
                                      final active = value.text
                                          .trim()
                                          .isNotEmpty;
                                      return _CircleActionButton(
                                        onPressed: active ? _submit : null,
                                        icon: Icons.arrow_upward_rounded,
                                        filled: active,
                                        colorScheme: cs,
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),

                      // -- Advanced options row --
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        crossFadeState: _showAdvanced
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild: Container(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                          child: Row(
                            children: [
                              _OptionChip(
                                label: 'Model',
                                icon: Icons.memory,
                                colorScheme: cs,
                              ),
                              const SizedBox(width: 8),
                              _OptionChip(
                                label: 'Web',
                                icon: Icons.language,
                                colorScheme: cs,
                              ),
                              const SizedBox(width: 8),
                              _OptionChip(
                                label: 'Tools',
                                icon: Icons.build_outlined,
                                colorScheme: cs,
                              ),
                            ],
                          ),
                        ),
                        secondChild: const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),

                // -- Disclaimer --
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 2),
                  child: Text(
                    'AI can make mistakes. Verify important information.',
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant.withValues(alpha: 0.35),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Option chip (for advanced row)
// ---------------------------------------------------------------------------

class _OptionChip extends StatefulWidget {
  const _OptionChip({
    required this.label,
    required this.icon,
    required this.colorScheme,
  });

  final String label;
  final IconData icon;
  final ColorScheme colorScheme;

  @override
  State<_OptionChip> createState() => _OptionChipState();
}

class _OptionChipState extends State<_OptionChip> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    final cs = widget.colorScheme;
    return InkWell(
      onTap: () => setState(() => _active = !_active),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: _active
              ? cs.primary.withValues(alpha: 0.12)
              : cs.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _active
                ? cs.primary.withValues(alpha: 0.3)
                : cs.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: 14,
              color: _active ? cs.primary : cs.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: _active ? FontWeight.w600 : FontWeight.w400,
                color: _active ? cs.primary : cs.onSurfaceVariant,
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
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: filled
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
        padding: EdgeInsets.zero,
        tooltip: filled ? 'Send message' : null,
      ),
    );
  }
}
