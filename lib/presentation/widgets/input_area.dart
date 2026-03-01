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
                            Container(
                              margin: const EdgeInsets.only(left: 4, bottom: 4),
                              width: 40,
                              height: 40,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: widget.isStreaming
                                    ? null
                                    : _pickFiles,
                                icon: const Icon(
                                  Icons.add_circle_outline_rounded,
                                  size: 24,
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
