import 'package:flutter/material.dart';

class AppColors {
  static Color background(bool isDark) =>
      isDark ? Colors.black : Colors.white;

  static Color surface(bool isDark) =>
      isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5);

  static Color box(bool isDark) =>
      isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

  static Color border(bool isDark) =>
      isDark ? Colors.white24 : Colors.black12;

  static Color text(bool isDark) =>
      isDark ? Colors.white : Colors.black;

  static Color secondaryText(bool isDark) =>
      isDark ? Colors.grey.shade400 : Colors.grey.shade600;

  static Color icon(bool isDark) =>
      isDark ? Colors.white70 : Colors.black54;

  static Color hint(bool isDark) =>
      isDark ? Colors.white38 : Colors.black38;

  static Color chip(bool isDark) =>
      isDark ? Colors.grey.shade800 : Colors.grey.shade200;
}