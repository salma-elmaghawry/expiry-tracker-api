import 'package:flutter/material.dart';

class ShellDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String labelKey;
  final bool pinnedToBottom;

  const ShellDestination({
    required this.icon,
    required this.selectedIcon,
    required this.labelKey,
    this.pinnedToBottom = false,
  });
}

const List<ShellDestination> shellDestinations = [
  ShellDestination(
    icon: Icons.space_dashboard_outlined,
    selectedIcon: Icons.space_dashboard_rounded,
    labelKey: 'nav.dashboard',
  ),
  ShellDestination(
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2_rounded,
    labelKey: 'nav.batches',
  ),
  ShellDestination(
    icon: Icons.insert_chart_outlined_rounded,
    selectedIcon: Icons.insert_chart_rounded,
    labelKey: 'nav.reports',
  ),
  ShellDestination(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings_rounded,
    labelKey: 'nav.settings',
    pinnedToBottom: true,
  ),
];
