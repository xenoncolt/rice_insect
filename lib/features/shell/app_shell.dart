import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import 'placeholder_screen.dart';
import 'widgets/app_bottom_nav.dart';

/// Holds the four bottom-bar destinations. Only Home is designed so far; the
/// rest land here as their Figma frames get built.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const List<AppNavDestination> _destinations = <AppNavDestination>[
    AppNavDestination(icon: Icons.home, labelKey: 'nav.home'),
    AppNavDestination(icon: Icons.auto_awesome, labelKey: 'nav.askGemini'),
    AppNavDestination(icon: Icons.insights, labelKey: 'nav.status'),
    AppNavDestination(icon: Icons.settings, labelKey: 'nav.settings'),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: switch (_index) {
          0 => const HomeScreen(key: ValueKey<int>(0)),
          _ => PlaceholderScreen(
            key: ValueKey<int>(_index),
            titleKey: _destinations[_index].labelKey,
          ),
        },
      ),
      bottomNavigationBar: AppBottomNav(
        destinations: _destinations,
        currentIndex: _index,
        onSelected: (int index) => setState(() => _index = index),
      ),
    );
  }
}
