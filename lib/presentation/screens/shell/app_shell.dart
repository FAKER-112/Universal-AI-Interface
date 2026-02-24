import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_client_service/presentation/screens/history/history_screen.dart';

/// Responsive shell: sidebar on wide screens, bottom nav on narrow.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _breakpoint = 900.0;

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/settings')) return 2;
    if (location.startsWith('/history')) return 1;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/chat/new');
      case 1:
        // On mobile, history is a separate tab; on desktop it's the sidebar.
        // For now, just navigate to chat since history is shown in the sidebar.
        context.go('/chat/new');
      case 2:
        context.go('/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= _breakpoint;
    final cs = Theme.of(context).colorScheme;
    final selectedIndex = _currentIndex(context);

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            // --- Sidebar ---
            SizedBox(
              width: 280,
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [cs.primary, cs.tertiary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: cs.onPrimary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'AI Client',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  // New Chat button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => context.go('/chat/new'),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('New Chat'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // History list
                  const Expanded(child: HistoryScreen()),
                  const Divider(),
                  // Settings link
                  ListTile(
                    leading: Icon(
                      Icons.settings_outlined,
                      color: cs.onSurfaceVariant,
                    ),
                    title: const Text('Settings'),
                    dense: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    selected: selectedIndex == 2,
                    selectedTileColor: cs.primaryContainer.withValues(
                      alpha: 0.3,
                    ),
                    onTap: () => context.go('/settings'),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            VerticalDivider(
              width: 1,
              color: cs.outlineVariant.withValues(alpha: 0.3),
            ),
            // --- Main content ---
            Expanded(child: child),
          ],
        ),
      );
    }

    // --- Narrow / Mobile ---
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (i) => _onDestinationSelected(context, i),
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
