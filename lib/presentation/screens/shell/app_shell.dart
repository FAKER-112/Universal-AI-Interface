import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_client_service/core/theme/app_theme.dart';
import 'package:ai_client_service/presentation/providers/chat_provider.dart';
import 'package:ai_client_service/presentation/providers/theme_provider.dart';

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
    if (w >= _tabletBreak) return _desktopLayout(context);
    if (w >= _mobileBreak) return _tabletLayout(context);
    return _mobileLayout(context);
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
            width: _sidebarOpen ? 280 : 0,
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
  // Tablet (600-1024): icons-only rail + content
  // =========================================================================
  Widget _tabletLayout(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final selected = _currentIndex();

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selected,
            onDestinationSelected: _onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: IconButton(
                onPressed: () {
                  // Open full drawer for tablet
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu, size: 22),
                tooltip: 'Open sidebar',
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.chat_outlined),
                selectedIcon: Icon(Icons.chat),
                label: Text('Chat'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history),
                label: Text('History'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          VerticalDivider(
            width: 1,
            color: cs.outlineVariant.withValues(alpha: 0.2),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
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
// Desktop sidebar (full, in-view)
// ===========================================================================

class _DesktopSidebar extends ConsumerStatefulWidget {
  const _DesktopSidebar({required this.onCollapse});
  final VoidCallback onCollapse;

  @override
  ConsumerState<_DesktopSidebar> createState() => _DesktopSidebarState();
}

class _DesktopSidebarState extends ConsumerState<_DesktopSidebar> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final chatExt = Theme.of(context).extension<ChatThemeExtension>()!;
    final settings = ref.watch(appSettingsProvider);
    final location = GoRouterState.of(context).uri.toString();
    final isSettings = location.startsWith('/settings');

    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -- Header --
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 4),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cs.primary, cs.tertiary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: cs.onPrimary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'AI Client',
                    style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: widget.onCollapse,
                  icon: const Icon(Icons.menu_open, size: 20),
                  tooltip: 'Collapse sidebar',
                  splashRadius: 16,
                ),
              ],
            ),
          ),

          // -- New Chat --
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  ref.read(chatNotifierProvider.notifier).loadHistory();
                  context.go('/chat/new');
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New chat'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          // -- Search --
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: tt.bodySmall,
              decoration: InputDecoration(
                hintText: 'Search chats...',
                hintStyle: tt.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: chatExt.sidebarHover,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                isDense: true,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // -- Section label --
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Text(
              'Your chats',
              style: tt.labelSmall?.copyWith(
                color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // -- Chat history --
          Expanded(
            child: _ChatHistoryList(
              searchQuery: _searchQuery,
              chatExt: chatExt,
            ),
          ),

          Divider(indent: 12, endIndent: 12, color: chatExt.subtleBorder),

          // -- Footer: Settings + Theme toggle + Profile --
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              children: [
                // Settings
                _SidebarTile(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  selected: isSettings,
                  onTap: () => context.go('/settings'),
                ),
                const SizedBox(height: 2),
                // Theme toggle
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
    final tt = Theme.of(context).textTheme;
    final chatExt = Theme.of(context).extension<ChatThemeExtension>()!;
    final w = MediaQuery.sizeOf(context).width;

    return Drawer(
      width: w * 0.85,
      backgroundColor: chatExt.sidebarBg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [cs.primary, cs.tertiary],
                      ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: cs.onPrimary,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'AI Client',
                    style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),

            // New chat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    ref.read(chatNotifierProvider.notifier).loadHistory();
                    context.go('/chat/new');
                    Navigator.of(context).pop(); // close drawer
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New chat'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                'Your chats',
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Expanded(
              child: _ChatHistoryList(
                searchQuery: '',
                chatExt: chatExt,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),

            Divider(indent: 12, endIndent: 12, color: chatExt.subtleBorder),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
// Chat history list
// ===========================================================================

class _ChatHistoryList extends StatelessWidget {
  const _ChatHistoryList({
    required this.searchQuery,
    required this.chatExt,
    this.onTap,
  });

  final String searchQuery;
  final ChatThemeExtension chatExt;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Placeholder data
    final allSessions = [
      _HistoryItem('Dart Streams Overview', 'Today'),
      _HistoryItem('Flutter Layout Help', 'Today'),
      _HistoryItem('Riverpod State Setup', 'Yesterday'),
      _HistoryItem('REST API Design', 'Yesterday'),
      _HistoryItem('Docker Compose Guide', '2 days ago'),
    ];

    final sessions = searchQuery.isEmpty
        ? allSessions
        : allSessions
              .where(
                (s) =>
                    s.title.toLowerCase().contains(searchQuery.toLowerCase()),
              )
              .toList();

    if (sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            searchQuery.isEmpty ? 'No conversations yet' : 'No results',
            style: tt.bodySmall?.copyWith(
              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final s = sessions[index];
        return _ChatHistoryTile(item: s, chatExt: chatExt, onTap: onTap);
      },
    );
  }
}

// ===========================================================================
// Single history tile with hover + context menu
// ===========================================================================

class _ChatHistoryTile extends StatefulWidget {
  const _ChatHistoryTile({
    required this.item,
    required this.chatExt,
    this.onTap,
  });

  final _HistoryItem item;
  final ChatThemeExtension chatExt;
  final VoidCallback? onTap;

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
          margin: const EdgeInsets.symmetric(vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? widget.chatExt.sidebarHover : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 16,
                color: cs.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.item.timeLabel,
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: _hovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_horiz,
                      size: 16,
                      color: cs.onSurfaceVariant,
                    ),
                    padding: EdgeInsets.zero,
                    iconSize: 16,
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'rename',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 16),
                            SizedBox(width: 8),
                            Text('Rename'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 16),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      // Placeholder -- will hook into persistence later
                    },
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.selected
                ? cs.primaryContainer.withValues(alpha: 0.3)
                : _hovered
                ? chatExt.sidebarHover
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: widget.selected ? cs.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: tt.bodyMedium?.copyWith(
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

// ===========================================================================
// Data
// ===========================================================================

class _HistoryItem {
  _HistoryItem(this.title, this.timeLabel);
  final String title;
  final String timeLabel;
}
