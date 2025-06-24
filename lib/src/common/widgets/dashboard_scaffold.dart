import 'package:flutter/material.dart';
import 'package:salesbets/src/common/widgets/navigation_rail_menu.dart';
import 'package:salesbets/src/common/widgets/topbar_header.dart';

class DashboardScaffold extends StatelessWidget {
  final int selectedIndex;
  final String title;
  final Widget child;
  final ValueChanged<int> onMenuTap;

  const DashboardScaffold({
    super.key,
    required this.selectedIndex,
    required this.title,
    required this.child,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRailMenu(selectedIndex: selectedIndex, onTap: onMenuTap),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                TopBarHeader(title: title),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
