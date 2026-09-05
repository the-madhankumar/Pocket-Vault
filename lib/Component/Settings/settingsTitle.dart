import 'package:flutter/material.dart';

Widget settingsGroupTitle(String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(
      20,
      28,
      20,
      8,
    ),
    child: Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.6,
      ),
    ),
  );
}