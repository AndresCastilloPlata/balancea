import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainBottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainBottomNav({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        backgroundColor: const Color(0xFF191A22),
        indicatorColor: const Color(0xFF4ECDC4).withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.grey),
            label: 'Inicio',
            selectedIcon: Icon(Icons.home, color: Color(0xFF4ECDC4)),
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined, color: Colors.grey),
            label: 'Stats',
            selectedIcon: Icon(Icons.bar_chart, color: Color(0xFF4ECDC4)),
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined, color: Colors.grey),
            label: 'Movimientos',
            selectedIcon: Icon(Icons.list_alt, color: Color(0xFF4ECDC4)),
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: Colors.grey),
            label: 'Ajustes',
            selectedIcon: Icon(Icons.settings, color: Color(0xFF4ECDC4)),
          ),
        ],
      ),
    );
  }
}
