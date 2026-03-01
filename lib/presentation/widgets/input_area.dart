import 'dart:io';

import 'package:ai_client_service/data/models/chat_attachment.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:mime/mime.dart';

import 'package:ai_client_service/core/theme/app_theme.dart';

/// Modern expandable input area. The text field grows as the user types more
/// lines (up to ~40% of screen height) and shrinks back when text is removed.
/// Clean rounded design with left-side action icons and a circular send button.
class InputAreaWidget extends StatefulWidget {
  const InputAreaWidget({
    super.key,
    required this.isStreaming,
    required this.onSend,
    required this.onStop,
  });

  final bool isStreaming;
  final void Function(String text, List<ChatAttachment> attachments) onSend;
  final VoidCallback onStop;

  @override
  State<InputAreaWidget> createState() => InputAreaWidgetState();
}

class InputAreaWidgetState extends State<InputAreaWidget> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  bool _focused = false;
  bool _showAdvanced = false;

  final List<ChatAttachment> _attachments = [];

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty && _attachments.isEmpty) return;

    widget.onSend(text, List.from(_attachments));
    _controller.clear();
    setState(() {
      _attachments.clear();
    });
    _focusNode.requestFocus();
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        for (final file in result.files) {
          if (file.path != null) {
            final mimeType =
                lookupMimeType(file.name) ?? 'application/octet-stream';
            _attachments.add(
              ChatAttachment(
                id: const Uuid().v4(),
                path: file.path!,
                name: file.name,
                mimeType: mimeType,
              ),
            );
          }
        }
      });
    }
  }

  void _removeAttachment(String id) {
    setState(() {
      _attachments.removeWhere((attr) => attr.id == id);
    });
  }

  void setInput(String text, List<ChatAttachment> attachments) {
    setState(() {
      _controller.text = text;
      _attachments.clear();
      _attachments.addAll(attachments);
    });
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final chatExt = Theme.of(context).extension<ChatThemeExtension>()!;
    final screenH = MediaQuery.sizeOf(context).height;
    // Max height = 40% of screen so user can see conversation above
    final maxFieldHeight = (screenH * 0.4).clamp(120.0, 400.0);

    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // -- Main input container --
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: chatExt.inputBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _focused
                          ? cs.primary.withValues(alpha: 0.45)
                          : chatExt.subtleBorder,
                      width: _focused ? 1.5 : 1,
                    ),
                    boxShadow: _focused
                        ? [
                            BoxShadow(
                              color: cs.primary.withValues(alpha: 0.06),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -- Attachments Preview --
                      if (_attachments.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _attachments.map((file) {
                                final isImage = file.mimeType.startsWith(
                                  'image/',
                                );
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: cs.surfaceTint.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: chatExt.subtleBorder,
                                    ),
                                    image: isImage
                                        ? DecorationImage(
                                            image: FileImage(File(file.path)),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: Stack(
                                    children: [
                                      if (!isImage)
                                        Center(
                                          child: Icon(
                                            Icons.insert_drive_file,
                                            color: cs.onSurfaceVariant,
                                          ),
                                        ),
                                      Positioned(
                                        top: -2,
                                        right: -2,
                                        child: InkWell(
                                          onTap: () =>
                                              _removeAttachment(file.id),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: cs.inverseSurface,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(2),
                                            child: Icon(
                                              Icons.close,
                                              size: 12,
                                              color: cs.onInverseSurface,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                      // -- Expandable text field and buttons --
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 48,
                          maxHeight: maxFieldHeight,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Attachment button
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 6,
                                bottom: 6,
                              ),
                              child: IconButton(
                                onPressed: widget.isStreaming
                                    ? null
                                    : _pickFiles,
                                icon: const Icon(
                                  Icons.add_circle_outline_rounded,
                                ),
                                color: cs.onSurfaceVariant,
                                tooltip: 'Attach files',
                              ),
                            ),
                            // Text field -- takes full width, grows vertically
                            Expanded(
                              child: Scrollbar(
                                controller: _scrollController,
                                thumbVisibility: false,
                                child: KeyboardListener(
                                  focusNode: FocusNode(),
                                  onKeyEvent: (event) {
                                    if (event is KeyDownEvent &&
                                        event.logicalKey ==
                                            LogicalKeyboardKey.enter) {
                                      final isCtrlOrCmd =
                                          HardwareKeyboard
                                              .instance
                                              .isControlPressed ||
                                          HardwareKeyboard
                                              .instance
                                              .isMetaPressed;
                                      if (isCtrlOrCmd) {
                                        _submit();
                                      }
                                    }
                                  },
                                  child: TextField(
                                    controller: _controller,
                                    focusNode: _focusNode,
                                    scrollController: _scrollController,
                                    maxLines: null, // unlimited growth
                                    textInputAction: TextInputAction.newline,
                                    style: tt.bodyMedium?.copyWith(
                                      color: cs.onSurface,
                                      height: 1.45,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: widget.isStreaming
                                          ? 'Waiting for response...'
                                          : 'Ask anything... (Ctrl+Enter to send)',
                                      hintStyle: tt.bodyMedium?.copyWith(
                                        color: cs.onSurfaceVariant.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                      filled: false,
                                      contentPadding: const EdgeInsets.fromLTRB(
                                        8,
                                        14,
                                        8,
                                        14,
                                      ),
                                      isDense: true,
                                    ),
                                    enabled: !widget.isStreaming,
                                  ),
                                ),
                              ),
                            ),

                            // Send / Stop button
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 6,
                                bottom: 6,
                              ),
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
                                        final active =
                                            value.text.trim().isNotEmpty ||
                                            _attachments.isNotEmpty;
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
                      ),

                      // -- Bottom toolbar: attach icons + advanced --
                      Container(
                        padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                        child: Row(
                          children: [
                            // Attach file
                            _ToolbarIcon(
                              icon: Icons.add_circle_outline,
                              tooltip: 'Attach file',
                              onPressed: () {},
                              colorScheme: cs,
                            ),
                            // Image upload
                            _ToolbarIcon(
                              icon: Icons.image_outlined,
                              tooltip: 'Upload image',
                              onPressed: () {},
                              colorScheme: cs,
                            ),

                            const Spacer(),

                            // Advanced toggle
                            _ToolbarIcon(
                              icon: Icons.tune,
                              tooltip: 'Advanced options',
                              active: _showAdvanced,
                              onPressed: () => setState(
                                () => _showAdvanced = !_showAdvanced,
                              ),
                              colorScheme: cs,
                            ),
                          ],
                        ),
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
                  padding: const EdgeInsets.only(top: 4, bottom: 2),
                  child: Text(
                    'AI can make mistakes. Verify important information.',
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant.withValues(alpha: 0.3),
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
// Small toolbar icon button
// ---------------------------------------------------------------------------

class _ToolbarIcon extends StatefulWidget {
  const _ToolbarIcon({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.colorScheme,
    this.active = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;
  final bool active;

  @override
  State<_ToolbarIcon> createState() => _ToolbarIconState();
}

class _ToolbarIconState extends State<_ToolbarIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = widget.colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _hovered || widget.active
                  ? cs.onSurface.withValues(alpha: 0.06)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: widget.active
                  ? cs.primary
                  : cs.onSurfaceVariant.withValues(alpha: 0.55),
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
