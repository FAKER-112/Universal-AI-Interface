import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:highlight/highlight.dart' show highlight;
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_tts/flutter_tts.dart';

import 'package:ai_client_service/core/theme/app_theme.dart';
import 'package:ai_client_service/data/models/chat_message.dart';

/// A styled chat bubble that renders content as Markdown for assistant
/// messages, with syntax-highlighted code blocks, language headers,
/// copy-to-clipboard support, inline action buttons, and hover timestamps.
class MessageBubbleWidget extends StatefulWidget {
  const MessageBubbleWidget({
    super.key,
    required this.message,
    this.isStreaming = false,
  });

  final ChatMessage message;
  final bool isStreaming;

  @override
  State<MessageBubbleWidget> createState() => _MessageBubbleWidgetState();
}

class _MessageBubbleWidgetState extends State<MessageBubbleWidget> {
  bool _hovered = false;

  bool get _isUser => widget.message.role is MessageRoleUser;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: _isUser ? _buildUserBubble(context) : _buildAssistantCard(context),
    );
  }

  // ----------------------------------------------------------------
  // User message: right-aligned, subtle filled, rounded rectangle
  // ----------------------------------------------------------------
  Widget _buildUserBubble(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final chatExt = Theme.of(context).extension<ChatThemeExtension>()!;
    final maxWidth = MediaQuery.sizeOf(context).width * 0.72;

    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: chatExt.userBubbleBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: SelectableText(
              widget.message.content,
              style: tt.bodyMedium?.copyWith(color: cs.onSurface, height: 1.6),
            ),
          ),
          // Hover timestamp
          AnimatedOpacity(
            opacity: _hovered ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.only(top: 4, right: 4),
              child: Text(
                _formatTimestamp(widget.message.timestamp),
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // Assistant message: elevated card with avatar, markdown, actions
  // ----------------------------------------------------------------
  Widget _buildAssistantCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final chatExt = Theme.of(context).extension<ChatThemeExtension>()!;

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + content row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar circle
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.only(top: 2, right: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cs.primary, cs.tertiary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_awesome, size: 14, color: cs.onPrimary),
              ),

              // Card content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: chatExt.assistantCardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: chatExt.assistantCardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: cs.shadow.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildMarkdown(context),
                ),
              ),
            ],
          ),

          // Streaming dots
          if (widget.isStreaming)
            Padding(
              padding: const EdgeInsets.only(left: 42, top: 6),
              child: _StreamingDots(color: cs.primary),
            ),

          // Action buttons row (shown on hover or always on mobile)
          _MessageActions(message: widget.message, hovered: _hovered),

          // Hover timestamp
          AnimatedOpacity(
            opacity: _hovered ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.only(left: 42, top: 2),
              child: Text(
                _formatTimestamp(widget.message.timestamp),
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Markdown body ----
  Widget _buildMarkdown(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final chatExt = Theme.of(context).extension<ChatThemeExtension>()!;

    final inlineCodeBg = Theme.of(context).brightness == Brightness.dark
        ? cs.onSurface.withValues(alpha: 0.08)
        : cs.onSurface.withValues(alpha: 0.06);

    return MarkdownBody(
      data: widget.message.content,
      selectable: true,
      extensionSet: md.ExtensionSet.gitHubWeb,
      styleSheet: MarkdownStyleSheet(
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
        code: TextStyle(
          fontFamily: 'monospace',
          fontSize: (tt.bodyMedium?.fontSize ?? 14) * 0.9,
          color: cs.onSurface,
          backgroundColor: inlineCodeBg,
        ),
        codeblockDecoration: BoxDecoration(
          color: chatExt.codeBg,
          borderRadius: BorderRadius.circular(12),
        ),
        codeblockPadding: const EdgeInsets.all(16),
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
        listBullet: TextStyle(color: cs.primary),
        listIndent: 24,
        listBulletPadding: const EdgeInsets.only(right: 8),
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

  String _formatTimestamp(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

// ---------------------------------------------------------------------------
// Inline message action buttons (Copy / Regenerate / Read Aloud / Like / Dislike)
// ---------------------------------------------------------------------------

/// Global TTS instance shared across all message bubbles.
final _tts = FlutterTts();

class _MessageActions extends StatefulWidget {
  const _MessageActions({required this.message, required this.hovered});
  final ChatMessage message;
  final bool hovered;

  @override
  State<_MessageActions> createState() => _MessageActionsState();
}

class _MessageActionsState extends State<_MessageActions> {
  bool _isSpeaking = false;

  /// Strips basic markdown formatting for cleaner TTS output.
  String _stripMarkdown(String text) {
    return text
        .replaceAll(RegExp(r'```[\s\S]*?```'), '') // code blocks
        .replaceAll(RegExp(r'`[^`]+`'), '') // inline code
        .replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'$1') // bold
        .replaceAll(RegExp(r'\*([^*]+)\*'), r'$1') // italic
        .replaceAll(RegExp(r'#{1,6}\s*'), '') // headings
        .replaceAll(RegExp(r'\[([^\]]+)\]\([^)]+\)'), r'$1') // links
        .replaceAll(RegExp(r'---+'), '') // hr
        .replaceAll(RegExp(r'\n{3,}'), '\n\n') // excess newlines
        .trim();
  }

  Future<void> _toggleReadAloud() async {
    if (_isSpeaking) {
      await _tts.stop();
      setState(() => _isSpeaking = false);
    } else {
      setState(() => _isSpeaking = true);
      final text = _stripMarkdown(widget.message.content);
      _tts.setCompletionHandler(() {
        if (mounted) setState(() => _isSpeaking = false);
      });
      await _tts.speak(text);
    }
  }

  @override
  void dispose() {
    if (_isSpeaking) _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Always show on mobile (no hover), show on hover for desktop
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return AnimatedOpacity(
      opacity: (widget.hovered || isMobile) ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.only(left: 42, top: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionIconButton(
              icon: Icons.copy_outlined,
              tooltip: 'Copy',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: widget.message.content));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Copied to clipboard'),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
            _ActionIconButton(
              icon: Icons.refresh_rounded,
              tooltip: 'Regenerate',
              onPressed: () {
                // Placeholder for regeneration
              },
            ),
            _ActionIconButton(
              icon: _isSpeaking
                  ? Icons.stop_circle_outlined
                  : Icons.volume_up_outlined,
              tooltip: _isSpeaking ? 'Stop reading' : 'Read aloud',
              onPressed: _toggleReadAloud,
            ),
            _ActionIconButton(
              icon: Icons.thumb_up_outlined,
              tooltip: 'Good response',
              onPressed: () {},
            ),
            _ActionIconButton(
              icon: Icons.thumb_down_outlined,
              tooltip: 'Bad response',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIconButton extends StatefulWidget {
  const _ActionIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  State<_ActionIconButton> createState() => _ActionIconButtonState();
}

class _ActionIconButtonState extends State<_ActionIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
              color: _hovered
                  ? cs.onSurfaceVariant.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.icon,
              size: 16,
              color: cs.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Code block builder with colorful syntax highlighting + header bar
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

    final langClass = element.attributes['class'];
    final language = langClass?.replaceFirst('language-', '');
    final code = element.textContent.trimRight();

    if (langClass == null && !code.contains('\n')) return null;

    final chatExt = Theme.of(context).extension<ChatThemeExtension>()!;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final result = (language != null && language.isNotEmpty)
        ? highlight.parse(code, language: language)
        : highlight.parse(code, autoDetection: true);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: chatExt.codeBg,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header bar
          Container(
            color: chatExt.codeHeaderBg,
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
          // Code body
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(14),
            child: SelectableText.rich(
              _buildHighlightedSpan(result.nodes!, isDark),
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

  TextSpan _buildHighlightedSpan(
    List<dynamic> nodes,
    bool isDark, [
    String? parentClassName,
  ]) {
    final spans = <InlineSpan>[];
    for (final node in nodes) {
      // Use this node's className if set, otherwise inherit parent's
      final effectiveClass = node.className ?? parentClassName;

      if (node.value != null) {
        spans.add(
          TextSpan(
            text: node.value,
            style: effectiveClass != null
                ? _themeStyle(effectiveClass, isDark)
                : TextStyle(
                    color: isDark
                        ? const Color(0xFFABB2BF)
                        : const Color(0xFF383A42),
                  ),
          ),
        );
      } else if (node.children != null) {
        // Pass the effective class down so children inherit it
        spans.add(
          _buildHighlightedSpan(node.children!, isDark, effectiveClass),
        );
      }
    }
    return TextSpan(children: spans);
  }

  TextStyle? _themeStyle(String className, bool isDark) {
    final theme = isDark ? atomOneDarkTheme : atomOneLightTheme;
    final entry = theme[className];
    if (entry == null) {
      return TextStyle(
        color: isDark ? const Color(0xFFABB2BF) : const Color(0xFF383A42),
      );
    }
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
// Streaming dots indicator (spring animation)
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
            final scale =
                0.6 +
                0.4 *
                    Curves.easeOutBack.transform(
                      (1.0 - (t - 0.5).abs() * 2).clamp(0.0, 1.0),
                    );
            final opacity = (1.0 - (t - 0.5).abs() * 2).clamp(0.3, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
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
