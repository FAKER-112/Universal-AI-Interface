import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_client_service/core/theme/app_theme.dart';
import 'package:ai_client_service/presentation/providers/chat_provider.dart';
import 'package:ai_client_service/presentation/providers/theme_provider.dart';
import 'package:ai_client_service/presentation/widgets/logo.dart';

class NewChatIntent extends Intent {
  const NewChatIntent();
}

class OpenSettingsIntent extends Intent {
  const OpenSettingsIntent();
}

/// Responsive shell: collapsible sidebar on desktop, bottom nav + drawer on
/// mobile, icons-only rail on tablet.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _sidebarOpen = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // -- Breakpoints --
  static const _mobileBreak = 600.0;
  static const _tabletBreak = 1024.0;

  // -- Navigation --
  int _currentIndex() {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith('/settings')) return 2;
    if (loc.startsWith('/history')) return 1;
    return 0;
  }

  void _onDestinationSelected(int index) {
    switch (index) {
      case 0:
        context.go('/chat/new');
      case 1:
        context.go('/history');
      case 2:
        context.go('/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    Widget shellContent;
    if (w >= _tabletBreak) {
      shellContent = _desktopLayout(context);
    } else if (w >= _mobileBreak) {
      shellContent = _tabletLayout(context);
    } else {
      shellContent = _mobileLayout(context);
    }

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
            const NewChatIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyN):
            const NewChatIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.comma):
            const OpenSettingsIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.comma):
            const OpenSettingsIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          NewChatIntent: CallbackAction<NewChatIntent>(
            onInvoke: (intent) {
              _onDestinationSelected(0);
              return null;
            },
          ),
          OpenSettingsIntent: CallbackAction<OpenSettingsIntent>(
            onInvoke: (intent) {
              _onDestinationSelected(2);
              return null;
            },
          ),
        },
        child: PlatformMenuBar(
          menus: <PlatformMenuItem>[
            PlatformMenu(
              label: 'AI Client',
              menus: <PlatformMenuItem>[
                if (PlatformProvidedMenuItem.hasMenu(
                  PlatformProvidedMenuItemType.about,
                ))
                  const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.about,
                  ),
                if (PlatformProvidedMenuItem.hasMenu(
                  PlatformProvidedMenuItemType.quit,
                ))
                  const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.quit,
                  ),
              ],
            ),
            PlatformMenu(
              label: 'File',
              menus: <PlatformMenuItem>[
                PlatformMenuItem(
                  label: 'New Chat',
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyN,
                    meta: true,
                  ),
                  onSelected: () => _onDestinationSelected(0),
                ),
                PlatformMenuItem(
                  label: 'Settings',
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.comma,
                    meta: true,
                  ),
                  onSelected: () => _onDestinationSelected(2),
                ),
              ],
            ),
            // Basic Edit menu not needed natively unless using specific macOS features.
            // Cut/Copy/Paste natively provided by TextField context menu.
          ],
          child: shellContent,
        ),
      ),
    );
  }

  // =========================================================================
  // Desktop (>= 1024): full sidebar + content
  // =========================================================================
  Widget _desktopLayout(BuildContext context) {
    final chatExt = Theme.of(context).extension<ChatThemeExtension>()!;

    return Scaffold(
      body: Row(
        children: [
          // -- Sidebar --
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: _sidebarOpen ? 240 : 0,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: chatExt.sidebarBg),
            child: _sidebarOpen
                ? _DesktopSidebar(
                    onCollapse: () => setState(() => _sidebarOpen = false),
                  )
                : const SizedBox.shrink(),
          ),

          if (_sidebarOpen)
            VerticalDivider(width: 1, color: chatExt.subtleBorder),

          // -- Content --
          Expanded(
            child: Column(
              children: [
                if (!_sidebarOpen)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8),
                      child: IconButton(
                        onPressed: () => setState(() => _sidebarOpen = true),
                        icon: const Icon(Icons.menu, size: 22),
                        tooltip: 'Expand sidebar',
                      ),
                    ),
                  ),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // Tablet (600-1024): collapsible sidebar + content
  // =========================================================================
  Widget _tabletLayout(BuildContext context) {
    return _desktopLayout(context);
  }

  // =========================================================================
  // Mobile (< 600): bottom nav + drawer
  // =========================================================================
  Widget _mobileLayout(BuildContext context) {
    final selected = _currentIndex();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const _MobileDrawer(),
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: _onDestinationSelected,
        height: 64,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Desktop sidebar -- minimalistic design
// ===========================================================================

class _DesktopSidebar extends ConsumerWidget {
  const _DesktopSidebar({required this.onCollapse});
  final VoidCallback onCollapse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final chatExt = Theme.of(context).extension<ChatThemeExtension>()!;
    final settings = ref.watch(appSettingsProvider);
    final chatState = ref.watch(chatNotifierProvider);
    final location = GoRouterState.of(context).uri.toString();
    final isSettings = location.startsWith('/settings');

    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -- Header: compact icon row --
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 12, 12),
            child: Row(
              children: [
                ConcentricCirclesLogo(size: 24, color: cs.primary),
                const Spacer(),
                IconButton(
                  onPressed: onCollapse,
                  icon: const Icon(Icons.menu_open, size: 20),
                  tooltip: 'Collapse sidebar',
                  splashRadius: 18,
                  iconSize: 20,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: _SidebarTile(
              icon: Icons.edit_square,
              label: 'New chat',
              onTap: () {
                ref.read(chatNotifierProvider.notifier).newChat();
                context.go('/chat/new');
              },
            ),
          ),

          const SizedBox(height: 4),

          // -- Chat history --
          Expanded(
            child: _ChatHistoryList(chatState: chatState, chatExt: chatExt),
          ),

          // -- Footer: Settings + Theme toggle --
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 6),
            child: Column(
              children: [
                _SidebarTile(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  selected: isSettings,
                  onTap: () => context.go('/settings'),
                ),
                _SidebarTile(
                  icon: settings.themeMode == ThemeMode.dark
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  label: settings.themeMode == ThemeMode.dark
                      ? 'Light mode'
                      : 'Dark mode',
                  onTap: () {
                    final notifier = ref.read(appSettingsProvider.notifier);
                    notifier.setThemeMode(
                      settings.themeMode == ThemeMode.dark
                          ? ThemeMode.light
                          : ThemeMode.dark,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Mobile drawer
// ===========================================================================

class _MobileDrawer extends ConsumerWidget {
  const _MobileDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final chatExt = Theme.of(context).extension<ChatThemeExtension>()!;
    final chatState = ref.watch(chatNotifierProvider);
    final w = MediaQuery.sizeOf(context).width;

    return Drawer(
      width: w * 0.80,
      backgroundColor: chatExt.sidebarBg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: compact icon + new chat button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: ConcentricCirclesLogo(size: 24, color: cs.primary),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: _SidebarTile(
                icon: Icons.edit_square,
                label: 'New chat',
                onTap: () {
                  ref.read(chatNotifierProvider.notifier).newChat();
                  context.go('/chat/new');
                  Navigator.of(context).pop();
                },
              ),
            ),

            const SizedBox(height: 4),

            Expanded(
              child: _ChatHistoryList(
                chatState: chatState,
                chatExt: chatExt,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(6, 4, 6, 6),
              child: _SidebarTile(
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: () {
                  context.go('/settings');
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Chat history list -- reads from real ChatState.sessions
// ===========================================================================

class _ChatHistoryList extends ConsumerWidget {
  const _ChatHistoryList({
    required this.chatState,
    required this.chatExt,
    this.onTap,
  });

  final ChatState chatState;
  final ChatThemeExtension chatExt;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final sessions = chatState.sortedSessions;

    if (sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 28,
                color: cs.onSurfaceVariant.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 8),
              Text(
                'No conversations yet',
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Simulates network refresh or reloads local DB instances
        await Future.delayed(const Duration(milliseconds: 600));
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          final isActive = session.id == chatState.activeSessionId;

          return _ChatHistoryTile(
            session: session,
            isActive: isActive,
            chatExt: chatExt,
            onTap: () {
              ref.read(chatNotifierProvider.notifier).switchSession(session.id);
              context.go('/chat/${session.id}');
              onTap?.call();
            },
            onDelete: () {
              ref.read(chatNotifierProvider.notifier).deleteSession(session.id);
            },
          );
        },
      ),
    );
  }
}

// ===========================================================================
// Single history tile - minimal: title only, time on hover
// ===========================================================================

class _ChatHistoryTile extends StatefulWidget {
  const _ChatHistoryTile({
    required this.session,
    required this.isActive,
    required this.chatExt,
    required this.onTap,
    required this.onDelete,
  });

  final ChatSessionData session;
  final bool isActive;
  final ChatThemeExtension chatExt;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  State<_ChatHistoryTile> createState() => _ChatHistoryTileState();
}

class _ChatHistoryTileState extends State<_ChatHistoryTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: widget.isActive
                ? cs.primaryContainer.withValues(alpha: 0.3)
                : _hovered
                ? widget.chatExt.sidebarHover
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.session.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.bodySmall?.copyWith(
                        fontWeight: widget.isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: widget.isActive ? cs.primary : null,
                      ),
                    ),
                    // Show time label on hover or when active
                    if (_hovered || widget.isActive)
                      Text(
                        widget.session.timeLabel,
                        style: tt.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ),

              // Delete button on hover
              AnimatedOpacity(
                opacity: _hovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: IconButton(
                    onPressed: widget.onDelete,
                    icon: Icon(
                      Icons.close,
                      size: 14,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    padding: EdgeInsets.zero,
                    splashRadius: 12,
                    tooltip: 'Delete',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Sidebar tile helper
// ===========================================================================

class _SidebarTile extends StatefulWidget {
  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final chatExt = Theme.of(context).extension<ChatThemeExtension>()!;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: widget.selected
                ? cs.primaryContainer.withValues(alpha: 0.3)
                : _hovered
                ? chatExt.sidebarHover
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: widget.selected ? cs.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  style: tt.bodySmall?.copyWith(
                    color: widget.selected ? cs.primary : cs.onSurface,
                    fontWeight: widget.selected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
