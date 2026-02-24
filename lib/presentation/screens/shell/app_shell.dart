import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_client_service/presentation/providers/chat_provider.dart';

/// Responsive shell with a collapsible sidebar on wide screens
/// and bottom navigation on narrow screens.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _breakpoint = 900.0;
  bool _sidebarOpen = true;

  // Navigation helpers -------------------------------------------------------

  int _currentIndex() {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/settings')) return 2;
    if (location.startsWith('/history')) return 1;
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

  // Build --------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= _breakpoint;

    if (isWide) {
      return _buildDesktopLayout(context);
    }
    return _buildMobileLayout(context);
  }

  // -- Desktop (sidebar + content) -------------------------------------------

  Widget _buildDesktopLayout(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          // --- Sidebar ---
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: _sidebarOpen ? 260 : 0,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: cs.surface),
            child: _sidebarOpen
                ? _Sidebar(
                    onCollapse: () => setState(() => _sidebarOpen = false),
                    onNewChat: _startNewChat,
                  )
                : const SizedBox.shrink(),
          ),

          // Divider between sidebar and content
          if (_sidebarOpen)
            VerticalDivider(
              width: 1,
              color: cs.outlineVariant.withValues(alpha: 0.2),
            ),

          // --- Main content ---
          Expanded(
            child: Column(
              children: [
                // Show expand button when sidebar is collapsed
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

  // -- Mobile (bottom nav) ---------------------------------------------------

  Widget _buildMobileLayout(BuildContext context) {
    final selectedIndex = _currentIndex();

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
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

  void _startNewChat() {
    // Clear chat state and navigate
    context.go('/chat/new');
  }
}

// ---------------------------------------------------------------------------
// Sidebar widget
// ---------------------------------------------------------------------------

class _Sidebar extends ConsumerWidget {
  const _Sidebar({required this.onCollapse, required this.onNewChat});

  final VoidCallback onCollapse;
  final VoidCallback onNewChat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final location = GoRouterState.of(context).uri.toString();
    final isSettingsSelected = location.startsWith('/settings');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row: logo + title + collapse toggle
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 4),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cs.primary, cs.tertiary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.auto_awesome, color: cs.onPrimary, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'AI Client',
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                onPressed: onCollapse,
                icon: const Icon(Icons.menu_open, size: 20),
                tooltip: 'Collapse sidebar',
              ),
            ],
          ),
        ),

        // New Chat button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ref.read(chatNotifierProvider.notifier).loadHistory();
                onNewChat();
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New chat'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 4),

        // Section label
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            'Your chats',
            style: tt.labelSmall?.copyWith(
              color: cs.onSurfaceVariant.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Chat history list
        const Expanded(child: _ChatHistoryList()),

        const Divider(indent: 12, endIndent: 12),

        // Settings link
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          child: ListTile(
            leading: Icon(
              Icons.settings_outlined,
              size: 20,
              color: cs.onSurfaceVariant,
            ),
            title: Text('Settings', style: tt.bodyMedium),
            dense: true,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            selected: isSettingsSelected,
            selectedTileColor: cs.primaryContainer.withValues(alpha: 0.3),
            onTap: () => context.go('/settings'),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Chat history list embedded in the sidebar
// ---------------------------------------------------------------------------

class _ChatHistoryList extends StatelessWidget {
  const _ChatHistoryList();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Placeholder sessions -- will be backed by persistence later.
    final sessions = <_HistoryItem>[
      _HistoryItem('Dart Streams Overview', 'Today'),
      _HistoryItem('Flutter Layout Help', 'Today'),
      _HistoryItem('Riverpod State Setup', 'Yesterday'),
    ];

    if (sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No conversations yet',
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
        return ListTile(
          leading: Icon(
            Icons.chat_bubble_outline,
            size: 16,
            color: cs.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          title: Text(
            s.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tt.bodySmall,
          ),
          dense: true,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hoverColor: cs.onSurface.withValues(alpha: 0.05),
          onTap: () {
            // Navigate to specific chat once persistence is ready.
          },
        );
      },
    );
  }
}

class _HistoryItem {
  _HistoryItem(this.title, this.timeLabel);
  final String title;
  final String timeLabel;
}
