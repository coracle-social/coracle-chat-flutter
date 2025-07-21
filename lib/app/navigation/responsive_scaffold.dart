import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'sidebar_navigation.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget child;
  final StatefulNavigationShell navigationShell;

  const ResponsiveScaffold({
    super.key,
    required this.child,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Row(
        children: [
          if (!isMobile)
            SidebarNavigation(
              selectedIndex: navigationShell.currentIndex,
              onTap: navigationShell.goBranch,
            ),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: navigationShell.goBranch,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.functions), label: 'Simple'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            )
          : null,
    );
  }
}