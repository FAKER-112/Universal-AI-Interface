import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/highlight.dart' show highlight;
import 'package:markdown/markdown.dart' as md;

import 'package:ai_client_service/data/models/chat_message.dart';

/// A styled chat bubble that renders content as Markdown for assistant
/// messages, with syntax-highlighted code blocks, language headers, and
/// copy-to-clipboard support.
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

    if (_isUser) {
      return _buildUserBubble(context, cs, tt);
    }
    return _buildAssistantMessage(context, cs, tt);
  }

  // ---- User bubble (right-aligned, tinted) ----

  Widget _buildUserBubble(BuildContext context, ColorScheme cs, TextTheme tt) {
    final maxWidth = MediaQuery.sizeOf(context).width * 0.78;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _RoleLabel(isUser: true),
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.12),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: SelectableText(
            message.content,
            style: tt.bodyMedium?.copyWith(color: cs.onSurface, height: 1.5),
          ),
        ),
      ],
    );
  }

  // ---- Assistant message (full-width, no bubble) ----

  Widget _buildAssistantMessage(
    BuildContext context,
    ColorScheme cs,
    TextTheme tt,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RoleLabel(isUser: false),
        _buildMarkdown(context),
        if (isStreaming)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: _StreamingDots(color: cs.primary),
          ),
      ],
    );
  }

  // ---- Markdown body ----

  Widget _buildMarkdown(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final inlineCodeBg = isDark
        ? cs.onSurface.withValues(alpha: 0.08)
        : cs.onSurface.withValues(alpha: 0.06);

    return MarkdownBody(
      data: message.content,
      selectable: true,
      extensionSet: md.ExtensionSet.gitHubWeb,
      styleSheet: MarkdownStyleSheet(
        // --- Text ---
        p: tt.bodyMedium?.copyWith(color: cs.onSurface, height: 1.7),
        h1: tt.headlineSmall?.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.w700,
          height: 1.4,
        ),
        h2: tt.titleLarge?.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.w700,
          height: 1.4,
        ),
        h3: tt.titleMedium?.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        h4: tt.titleSmall?.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.w600,
        ),
        strong: TextStyle(fontWeight: FontWeight.w700, color: cs.onSurface),
        em: TextStyle(fontStyle: FontStyle.italic, color: cs.onSurface),

        // --- Inline code ---
        code: TextStyle(
          fontFamily: 'monospace',
          fontSize: (tt.bodyMedium?.fontSize ?? 14) * 0.9,
          color: cs.onSurface,
          backgroundColor: inlineCodeBg,
        ),

        // --- Fenced code blocks (fallback styling; custom builder handles
        //     syntax highlighting) ---
        codeblockDecoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : const Color(0xFF282C34),
          borderRadius: BorderRadius.circular(12),
        ),
        codeblockPadding: const EdgeInsets.all(16),

        // --- Blockquote ---
        blockquoteDecoration: BoxDecoration(
          color: cs.primary.withValues(alpha: 0.05),
          border: Border(left: BorderSide(color: cs.primary, width: 3)),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
        ),
        blockquotePadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        // --- Tables ---
        tableBorder: TableBorder.all(
          color: cs.outlineVariant.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        tableHead: tt.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: cs.onSurface,
        ),
        tableBody: tt.bodyMedium?.copyWith(color: cs.onSurface),
        tableHeadAlign: TextAlign.left,
        tableCellsPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),

        // --- Lists ---
        listBullet: TextStyle(color: cs.primary),
        listIndent: 24,
        listBulletPadding: const EdgeInsets.only(right: 8),

        // --- Spacing ---
        blockSpacing: 14,
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: cs.outlineVariant.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
      ),
      builders: {'code': _CodeBlockBuilder()},
    );
  }
}

// ---------------------------------------------------------------------------
// Role label
// ---------------------------------------------------------------------------

class _RoleLabel extends StatelessWidget {
  const _RoleLabel({required this.isUser});
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(
        left: isUser ? 0 : 4,
        right: isUser ? 4 : 0,
        bottom: 6,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUser ? Icons.person_outline : Icons.auto_awesome,
            size: 14,
            color: isUser ? cs.primary : cs.tertiary,
          ),
          const SizedBox(width: 4),
          Text(
            isUser ? 'You' : 'Assistant',
            style: tt.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Code block builder with syntax highlighting + header bar
// ---------------------------------------------------------------------------

class _CodeBlockBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    if (element.tag != 'code') return null;

    // Detect fenced code blocks by looking for a language-* class attribute.
    final langClass = element.attributes['class'];
    final language = langClass?.replaceFirst('language-', '');
    final code = element.textContent.trimRight();

    // If there is no language class and the code has no newlines, it is
    // inline code -- let flutter_markdown handle it normally.
    if (langClass == null && !code.contains('\n')) return null;

    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E2E) : const Color(0xFF282C34);
    final headerColor = isDark
        ? const Color(0xFF16162A)
        : const Color(0xFF21252B);

    // Attempt syntax highlighting.
    final result = (language != null && language.isNotEmpty)
        ? highlight.parse(code, language: language)
        : highlight.parse(code, autoDetection: true);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // -- Header bar --
          Container(
            color: headerColor,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Text(
                  language ?? 'code',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const Spacer(),
                _CopyButton(code: code),
              ],
            ),
          ),
          // -- Code body --
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(14),
            child: SelectableText.rich(
              _buildHighlightedSpan(result.nodes!),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _buildHighlightedSpan(List<dynamic> nodes) {
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
        spans.add(_buildHighlightedSpan(node.children!));
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

// ---------------------------------------------------------------------------
// Copy button for code blocks
// ---------------------------------------------------------------------------

class _CopyButton extends StatefulWidget {
  const _CopyButton({required this.code});
  final String code;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  void _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: _copy,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _copied ? Icons.check : Icons.copy_outlined,
              size: 14,
              color: _copied ? cs.primary : cs.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 4),
            Text(
              _copied ? 'Copied' : 'Copy',
              style: TextStyle(
                fontSize: 12,
                color: _copied
                    ? cs.primary
                    : cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Streaming dots indicator
// ---------------------------------------------------------------------------

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
