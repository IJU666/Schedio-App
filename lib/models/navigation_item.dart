import 'package:flutter/material.dart';

class NavigationItem {
  final String id;
  final String label;
  final IconData icon;
  final String route;
  final bool isCenter; // untuk FAB

  NavigationItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.route,
    this.isCenter = false,
  });
}
