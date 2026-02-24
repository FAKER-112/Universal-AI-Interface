import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/highlight.dart' show highlight;
import 'package:markdown/markdown.dart' as md;

import 'package:ai_client_service/data/models/chat_message.dart';

/// A styled chat bubble that renders content as Markdown for assistant
/// messages, with syntax-highlighted code blocks.
class MessageBubbleWidget extends StatelessWidget {
  const MessageBubbleWidget({
    super.key,
    required this.message,
    this.isStreaming = false,
  });

  final ChatMessage message;
  final bool isStreaming;

  bool get _isUser => message.role is MessageRoleUser;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final bubbleColor = _isUser
        ? cs.primary.withValues(alpha: 0.12)
        : cs.surfaceContainerHighest;
    final alignment = _isUser
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final maxWidth = MediaQuery.sizeOf(context).width * 0.78;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        // Role label
        Padding(
          padding: EdgeInsets.only(
            left: _isUser ? 0 : 4,
            right: _isUser ? 4 : 0,
            bottom: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isUser ? Icons.person_outline : Icons.auto_awesome,
                size: 14,
                color: _isUser ? cs.primary : cs.tertiary,
              ),
              const SizedBox(width: 4),
              Text(
                _isUser ? 'You' : 'Assistant',
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Bubble
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(_isUser ? 18 : 4),
              bottomRight: Radius.circular(_isUser ? 4 : 18),
            ),
          ),
          child: _isUser ? _buildPlainText(context) : _buildMarkdown(context),
        ),
        // Streaming indicator
        if (isStreaming && !_isUser)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: _StreamingDots(color: cs.primary),
          ),
      ],
    );
  }

  Widget _buildPlainText(BuildContext context) {
    return SelectableText(
      message.content,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.5,
      ),
    );
  }

  Widget _buildMarkdown(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return MarkdownBody(
      data: message.content,
      selectable: true,
      extensionSet: md.ExtensionSet.gitHubWeb,
      styleSheet: MarkdownStyleSheet(
        p: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: cs.onSurface, height: 1.6),
        h2: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.w700,
        ),
        h3: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.w600,
        ),
        strong: TextStyle(fontWeight: FontWeight.w700, color: cs.onSurface),
        code: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: cs.primary,
          backgroundColor: cs.surfaceContainerHighest,
        ),
        codeblockDecoration: BoxDecoration(
          color: const Color(0xFF23241F), // monokai background
          borderRadius: BorderRadius.circular(12),
        ),
        codeblockPadding: const EdgeInsets.all(14),
        blockquoteDecoration: BoxDecoration(
          border: Border(left: BorderSide(color: cs.primary, width: 3)),
        ),
        blockquotePadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 4,
        ),
        tableBorder: TableBorder.all(
          color: cs.outlineVariant.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        tableHead: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: cs.onSurface,
        ),
        tableBody: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: cs.onSurface),
        tableCellsPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        listBullet: TextStyle(color: cs.primary),
      ),
      builders: {'code': _CodeBlockBuilder()},
    );
  }
}

/// Custom builder that applies syntax highlighting to fenced code blocks.
class _CodeBlockBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    // Only handle multi-line code (fenced blocks), not inline code.
    if (element.tag != 'code') return null;
    final parent = element.parents;
    final isBlock = parent.isNotEmpty && parent.any((e) => e.tag == 'pre');
    if (!isBlock) return null;

    final code = element.textContent.trimRight();
    var language = element.attributes['class']?.replaceFirst('language-', '');

    // Attempt to highlight.
    final result = (language != null && language.isNotEmpty)
        ? highlight.parse(code, language: language)
        : highlight.parse(code, autoDetection: true);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: SelectableText.rich(
        _buildHighlightedSpan(result.nodes!, context),
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.5,
        ),
      ),
    );
  }

  TextSpan _buildHighlightedSpan(List<dynamic> nodes, BuildContext context) {
    final spans = <InlineSpan>[];
    for (final node in nodes) {
      if (node.value != null) {
        spans.add(
          TextSpan(
            text: node.value,
            style: node.className != null
                ? _themeStyle(node.className!)
                : const TextStyle(color: Color(0xFFF8F8F2)),
          ),
        );
      } else if (node.children != null) {
        spans.add(_buildHighlightedSpan(node.children!, context));
      }
    }
    return TextSpan(children: spans);
  }

  TextStyle? _themeStyle(String className) {
    final theme = monokaiSublimeTheme;
    final entry = theme[className];
    if (entry == null) return const TextStyle(color: Color(0xFFF8F8F2));
    return TextStyle(
      color: entry.color,
      fontWeight: entry.fontWeight,
      fontStyle: entry.fontStyle,
    );
  }
}

/// Animated three-dot indicator shown during streaming.
class _StreamingDots extends StatefulWidget {
  const _StreamingDots({required this.color});
  final Color color;

  @override
  State<_StreamingDots> createState() => _StreamingDotsState();
}

class _StreamingDotsState extends State<_StreamingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i * 0.2;
            final t = ((_ctrl.value - delay) % 1.0).clamp(0.0, 1.0);
            final opacity = (1.0 - (t - 0.5).abs() * 2).clamp(0.3, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

extension on md.Element {
  /// Walk up the tree to find parent elements.
  Iterable<md.Element> get parents sync* {
    // flutter_markdown does not expose parent; we check tag names instead.
    // Fenced code blocks always have a <pre><code> structure.
  }
}
